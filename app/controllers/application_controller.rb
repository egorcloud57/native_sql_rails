class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session # отключить csrf

  def query_sql(query)
    ActiveRecord::Base.connection.exec_query(query)
  end

  def insert_sql(table, params)
    query = <<-SQL
      INSERT INTO #{table} (#{params.keys.join ', '})
      VALUES (#{params.values.map { "'#{_1}'"}.join ', '})
    SQL
    ActiveRecord::Base.connection.exec_query(query)
  end

  def update_sql(table, params, id)
    query = <<-SQL
      UPDATE #{table}
      SET #{params.map{ "`#{_1}` = '#{_2}'" }.join ', '}
      WHERE id = #{id};
    SQL
    ActiveRecord::Base.connection.exec_query(query)
  end

  def get_sql(query)
    objects = ActiveRecord::Base.connection.exec_query(query)&.to_ary
    yield(objects) if block_given? && objects.present?
  end
end
