class CaseWhenController < ApplicationController
  def index
    # Перепишите следующий запрос, использующий простое выражение
    # case, таким образом, чтобы получить аналогичные результаты с помо
    # щью выражения case с перебором вариантов. Попытайтесь свести
    # к минимуму количество блоков when.

    # SELECT emp_id,
    #   CASE title
    #     WHEN 'President' THEN 'Management'
    #     WHEN 'Vice President' THEN 'Management'
    #     WHEN 'Treasurer' THEN 'Management'
    #     WHEN 'Loan Manager' THEN 'Management'
    #     WHEN 'Operations Manager' THEN 'Operations'
    #     WHEN 'Head Teller' THEN 'Operations'
    #     WHEN 'Teller' THEN 'Operations'
    #     ELSE 'Unknown'
    #   END
    # FROM employee;

    query_1 = <<-SQL
      select emp_id,
        case
          when title in ('President', 'Vice President', 'Treasurer', 'Loan Manager') then 'Management'
          when title in ('Operations Manager', 'Head Teller', 'Tellerr') then 'Operations'
          else 'Unknown'
        end title
      from employee;
    SQL

    employess = get_sql(query_1) do |objects|
      objects.map { Struct.new("Employee", *_1.keys).new(*_1.values) }
    end

    puts employess

    # Перепишите следующий запрос так, чтобы результирующий набор со
    # держал всего одну строку и четыре столбца (по одному для каждого от
    # деления). Назовите столбцы branch_1, branch_2 и т. д.

    # SELECT open_branch_id, COUNT(*) FROM account GROUP BY open_branch_id;

    query_2 = <<-SQL
      select 
        sum(
          case
            when open_branch_id = 1 then 1
            else 0
          end
        ) branch_1,
        sum(
          case
            when open_branch_id = 2 then 1
            else 0
          end
        ) branch_2,
        sum(
          case
            when open_branch_id = 3 then 1
            else 0
          end
        ) branch_3,
        sum(
          case
            when open_branch_id = 4 then 1
            else 0
          end
        ) branch_4
      from account;
    SQL

    accounts = get_sql(query_2) do |objects|
      objects.map { Struct.new("Account", *_1.keys).new(*_1.values) }
    end

    puts accounts
  end
end
