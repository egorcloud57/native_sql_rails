class SelectSqlController < ApplicationController
  def index
    # Извлеките ID, имя и фамилию всех банковских сотрудников. Выпол-
    # -ните сортировку по имени.
    query_1 = <<-SQL
      select fname, lname, emp_id 
      from employee
      order by lname
    SQL
    employees = get_sql(query_1) do |objects|
      objects.map{ Struct.new("Employee", *_1.keys).new(*_1.values) }
    end
    puts employees

    # Извлеките ID счета, ID клиента и доступный остаток всех счетов, имею
    # щих статус 'ACTIVE' (активный) и доступный остаток более 2500 долла
    # ров.
    query_2 = <<-SQL
      select account_id, open_emp_id, avail_balance
      from account
      where status = 'ACTIVE' AND avail_balance > 2500;
    SQL
    accounts = get_sql(query_2) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts

    # Напишите запрос к таблице account, возвращающий уникальные ID сотрудников, от
    # рывших счета
    query_3 = <<-SQL
      select DISTINCT open_emp_id
      from account;
    SQL
    accounts2 = get_sql(query_3) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts2

    # group by sum
    # Напишите запрос к таблице account, возвращающий весь текущий баланс для каждого сотрудника открывшего счет
    query_4 = <<-SQL
      select open_emp_id, SUM(avail_balance) as sum
      from account
      group by open_emp_id;
    SQL
    accounts3 = get_sql(query_4) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts3

    # сортировать данные клиентов по последним трем
    # разрядам их федерального ID в порядке уменьшения
    query_5 = <<-SQL
      select cust_id, cust_type_cd, city, state, fed_id
      from customer
      order by RIGHT(fed_id, 3) desc;
    SQL
    customers = get_sql(query_5) do |objects|
      objects.map{ Struct.new("Customer", *_1.keys).new(*_1.values) }
    end
    puts customers
  end
end
