class JoinSqlController < ApplicationController
  def index_inner_join
    # [3 таблицы и подзапросы]
    # вывести имена и фамилии сотрудников, дату открытия счета и город клиента относящегося к этому счету.
    # у сотрудников есть открытые счета с 2000 по 2003 года
    # для клиентов из городов Quincy и Salem. Таблицы счетов и клиентов выводить за счет подзапросов
    query_1 = <<-SQL
      select e.lname, e.fname, c.city, a.open_date, a.account_id
      from employee as e 
      INNER JOIN (select cust_id, open_emp_id, open_date, account_id from account where
        (open_date BETWEEN '2000-01-01' and '2003-01-01')) as a
      on e.emp_id = a.open_emp_id
      INNER JOIN (select cust_id, city from customer where city in ('Quincy', 'Salem')) as c
      on a.cust_id = c.cust_id;
    SQL
    employees = get_sql(query_1) do |objects|
      objects.map{ Struct.new("Employee", *_1.keys).new(*_1.values) }
    end
    puts employees

    # Создайте запрос для выбора всех сотрудников, начальник которых при
    # писан к другому отделу. Извлеките ID, имя и фамилию сотрудника.
    query_2 = <<-SQL
      select e.emp_id, e.fname, e.lname
      from employee as e INNER JOIN employee as manager 
      on e.superior_emp_id = manager.emp_id
      where e.dept_id != manager.dept_id
    SQL
    employees2 = get_sql(query_2) do |objects|
      objects.map{ Struct.new("Employee", *_1.keys).new(*_1.values) }
    end
    puts employees2
  end

  def index_outer_join
    # right outer join - данные из правой таблицы при присоединении всегда берутся все c left наоборот.

    # Напишите запрос, возвращающий все типы счетов и открытые счета
    # этих типов (для соединения с таблицей product используйте столбец
    # product_cd таблицы account). Должны быть включены все типы счетов,
    # даже если не был открыт ни один счет определенного типа.
    query_3 = <<-SQL
      select p.product_cd, a.avail_balance 
      from account a 
      right outer join product p 
      on a.product_cd = p.product_cd;
    SQL
    products = get_sql(query_3) do |objects|
      objects.map{ Struct.new("Product", *_1.keys).new(*_1.values) }
    end
    puts products

    # Проведите внешнее соединение таблицы account с таблицами individ
    # ual и business (посредством столбца account.cust_id) таким образом,
    # чтобы результирующий набор содержал по одной строке для каждого
    # счета. Должны быть включены столбцы count.account_id, account.prod
    # uct_cd, individual.fname, individual.lname и business.name.
    query_4 = <<-SQL
      select a.account_id count, a.product_cd, i.fname, i.lname, b.name
      from account a 
      left outer join individual i 
      on a.cust_id = i.cust_id
      left outer join business b
      on a.cust_id = b.cust_id;
    SQL
    accounts = get_sql(query_4) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts
  end
end
