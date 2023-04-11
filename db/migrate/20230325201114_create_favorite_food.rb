class CreateFavoriteFood < ActiveRecord::Migration[7.0]
  # def change
  #   create_table :favorite_food do |t|
  #     t.belongs_to :person
  #     t.string :foot, limit: 20
  #     t.timestamps
  #   end
  # end

  # indexes - это ключи для быстрого поиска по join, where, order by
  # Все типы ключей primary, foreign, uniq - автоматически индексируются в mysql
  # PRIMARY KEY (id, food) - составной первичный ключ
  # UNIQ key - обеспечивает уникальность таблицы по одному или более значениям. не принимает никаких дубликатов.
  # может быть несколько ключей по всей таблице
  # PRIMARY KEY - обеспечивает уникальность таблицы по одному или более значениям. не принимает никаких дубликатов и
  # значений NULL. может быть ток один по всей таблице
  def up
    execute <<-SQL
      CREATE TABLE favorite_food
        (id bigint(20) UNSIGNED AUTO_INCREMENT,
         person_id bigint(20) UNSIGNED,
         food VARCHAR(20),
         CONSTRAINT fk_person_id FOREIGN KEY (person_id) REFERENCES person (id),
         CONSTRAINT pk_favorite_food PRIMARY KEY (id)
        );
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE favorite_food;
    SQL
  end
end
