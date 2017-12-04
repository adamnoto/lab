class CreateOperationCategories < ActiveRecord::Migration
  def change
    create_table :operation_categories do |t|
      t.integer :operation_id, null: false
      t.integer :category_id, null: false

      t.timestamps null: false
    end

    execute "ALTER TABLE operation_categories ADD FOREIGN KEY (operation_id) REFERENCES operations (id);"
    execute "ALTER TABLE operation_categories ADD FOREIGN KEY (category_id) REFERENCES categories (id)"
  end
end
