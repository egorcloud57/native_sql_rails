class CreatePerson < ActiveRecord::Migration[7.0]
  # def change
  #   create_table :person do |t|
  #     t.string :fname, limit: 20
  #     t.string :lname, limit: 20
  #     t.string :address, limit: 30
  #     t.string :city, limit: 20
  #     t.string :state, limit: 20
  #     t.string :country, limit: 20
  #     t.string :postal_code, limit: 20
  #     t.date :birth_date
  #     t.column :gender, "ENUM('M', 'F') NOT NULL"
  #     t.timestamps
  #   end
  # end

  # UNSIGNED - никогда не будет отрицательным
  # SMALLINT - числа 2^16 степени
  # VARCHAR(20) - длинна строки 20 байт
  def up
    execute <<-SQl
        CREATE TABLE person
          (id bigint(20) UNSIGNED AUTO_INCREMENT,
           fname VARCHAR(20),
           lname VARCHAR(20),
           address VARCHAR(30),
           city VARCHAR(20),
           state VARCHAR(20),
           country VARCHAR(20),
           postal_code VARCHAR(20),
           gender ENUM('M','F') NOT NULL,
           birth_date DATE,
           CONSTRAINT pk_person PRIMARY KEY (id)
          );
    SQl
  end

  def down
    execute <<-SQL
      DROP TABLE person;
    SQL
  end
end
