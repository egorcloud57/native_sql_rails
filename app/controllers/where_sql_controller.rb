class WhereSqlController < ApplicationController
  def index
    # [LIKE '_a%e%' символы маски а так же REGEXP]
    # Создайте запрос, выбирающий всех клиентов физических лиц, второй
    # буквой фамилии которых является буква 'a' и есть 'e' в любой пози
    # ции после 'a'.
    query_1 = <<-SQL
      select *
      from individual
      where fname LIKE '_a%e%';
    SQL
    individuals = get_sql(query_1) do |objects|
      objects.map{ Struct.new("Individual", *_1.keys).new(*_1.values) }
    end
    puts individuals

    # [between, in]
    # Создайте запрос, выбирающий все счета с product_cd MM, CHK, SAV отккрытый баланс которых будет от 1000 до 5000.
    query_2 = <<-SQL
      select *
      from account
      where product_cd IN ('MM', 'CHK', 'SAV') and avail_balance BETWEEN 2000.00 and 5000.00;
    SQL
    accounts = get_sql(query_2) do |objects|
      objects.map{ Struct.new("Account", *_1.keys).new(*_1.values) }
    end
    puts accounts
  end
end
