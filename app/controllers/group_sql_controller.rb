class GroupSqlController < ApplicationController
  def index
    # Создайте запрос для подсчета числа строк в таблице account.
    query_1 = <<-SQL
      select COUNT(account_id) count from account;
    SQL
    accounts = get_sql(query_1) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts

    # Измените свой предыдущий запрос для подсчета числа счетов,
    # имеющихся у каждого клиента. Для каждого клиента выведите ID кли -
    # ента и количество счетов. отфильтруете клиентов у которых больше 2 счетов
    query_2 = <<-SQL
      select c.cust_id, count(a.account_id) count_account 
      from customer c 
      inner join account a on c.cust_id = a.cust_id 
      group by cust_id
      having count_account > 2;
    SQL
    accounts = get_sql(query_2) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts

    # Найдите общий доступный остаток по типу счетов и отделению, где
    # на каждый тип и отделение приходится более одного счета. Результа
    # ты должны быть упорядочены по общему остатку (от наибольшего
    # к наименьшему).
    query_3 = <<-SQL
      SELECT product_cd, open_branch_id, SUM(avail_balance) tot_balance 
      from account 
      group by product_cd, open_branch_id 
      having open_branch_id > 1 
      order by tot_balance desc;
    SQL
    accounts = get_sql(query_3) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts


    # Найдите общее кол-во клиентов по типу и стране где страна начинается на M и cust_type_cd = I
    query_4 = <<-SQL
      Select count(cust_id), cust_type_cd, state 
      from customer 
      group by state, cust_type_cd 
      having cust_type_cd = 'I' and left(state, 1) = 'M';
    SQL
    customers = get_sql(query_4) do |objects|
      objects.map{ Struct.new("Customer", *_1.keys).new(*_1.values) }
    end
    puts customers
  end
end
