class TransactionController < ApplicationController
  # закрыть продукт с маркировкой MM паралельно проставив дату ухода на пенсию текущей, а так же обновить все
  # аккаунты с маркировкой MM проставив статус CLOSED и дату последней активности на текущую. Сделать с точками
  # сохранения и в случае неудаче откат к первой точке.
  def update
    # все что пишется чз точку с запятой должно быть отдельными запросами, в данном примере будет ошибка.
    result = query_sql(
      <<-SQl
        START TRANSACTION;

        update product 
        SET date_retired=DATE(NOW()) 
        WHERE product_cd='MM';

        SAVEPOINT before_close_accounts;
  
        update account 
        SET status='CLOSED', close_date=DATE(NOW()), last_activity_date=DATE(NOW())
        WHERE product_cd='MM';

        ROLLBACK TO SAVEPOINT before_close_accounts;
  
        COMMIT;
      SQl
    )
    puts result
  end
end