class EditFavoriteFood < ActiveRecord::Migration[7.0]
  execute <<-SQL
    ALTER TABLE favorite_food MODIFY person_id bigint(20) unsigned NOT NULL;
  SQL
end
