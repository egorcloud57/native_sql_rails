class UnionController < ApplicationController
  # Union
  # [В обеих таблицах должно быть одинаковое число столбцов.
  # Типы данных столбцов двух таблиц должны быть одинаковыми
  # (или сервер должен уметь преобразовывать один тип в другой).]
  def index
    # Напишите составной запрос для выбора имен и фамилий всех клиен
    # тов физических лиц, а также имен и фамилий всех сотрудников. осортировать по имени.
    query_1 = <<-SQL
      (select fname as имя, lname as фамилия
      from employee)
      union 
      (select fname, lname
      from individual)
      order by имя;
    SQL
    peoples = get_sql(query_1) do |objects|
      objects.map{ Struct.new("People", *_1.keys).new(*_1.values) }
    end
    puts peoples
  end
end
