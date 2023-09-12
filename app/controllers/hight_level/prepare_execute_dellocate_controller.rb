module HightLevel
  class PrepareExecuteDellocateController < ::ApplicationController
    def index
      # Вы можете использовать либо :=, либо = в качестве оператора присваивания в инструкции SET
      # SET @counter := 100;
      # Второй способ присвоить значение переменной - это использовать инструкцию SELECT. В этом случае вы должны использовать оператор присваивания :=, потому что в инструкции SELECT MySQL обрабатывает оператор = как оператор equal .
      # SELECT @variable_name := value;
      # После присвоения вы можете использовать переменную в последующем операторе, где разрешено выражение, например, в предложении WHERE, операторах INSERT или UPDATE.

      # выбрать всех сотрудников с самым большим доступным балансом
      query = <<-SQL
        DELIMITER // 
        set @limit = (SELECT COUNT(*)/2 FROM account); PREPARE q FROM 'SELECT e.fname, a.avail_balance FROM employee e inner join account a on a.open_emp_id = e.emp_id order by a.avail_balance desc LIMIT ?'; EXECUTE q USING @limit; DEALLOCATE PREPARE q; 
        //
      SQL

      # puts ActiveRecord::Base.connection.exec_query(query) Activerecord не может толково преобразовать для mysql

      ActiveRecord::Base.connection.exec_query("set @limit = (SELECT COUNT(*)/2 FROM account);")
      ActiveRecord::Base.connection.exec_query("PREPARE q FROM 'SELECT e.fname, a.avail_balance FROM employee e inner join account a on a.open_emp_id = e.emp_id order by a.avail_balance desc LIMIT ?';")
      @r = ActiveRecord::Base.connection.exec_query("EXECUTE q USING @limit")
      ActiveRecord::Base.connection.exec_query("DEALLOCATE PREPARE q;")
      puts @r

      # хитрый пример с решением посложнее в один запрос и cross join
      # связанные подзапросы выполняются каждый раз для одной строки кандидата!
      # скалярные подзапросы применимы везде, где может появляться выражение, включая блоки select и order by за
      # проса и блок values (значения) выражения insert.
      query_2 = <<-SQL
        select e.fname, S.avail_balance from (select a.avail_balance, a.open_emp_id, a.account_id, @row:= @row+1 row_number, (select ROUND(COUNT(*)/2) from account) topn FROM account a CROSS JOIN (SELECT @row:=0) r order by a.avail_balance desc) S inner join employee e on S.open_emp_id = e.emp_id where S.row_number <= S.topn;
      SQL

      puts ActiveRecord::Base.connection.exec_query(query_2)
    end
  end
end