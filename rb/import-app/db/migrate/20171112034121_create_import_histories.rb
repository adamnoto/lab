class CreateImportHistories < ActiveRecord::Migration
  def change
    create_table :import_histories do |t|
      t.integer :rows_count, null: false, default: 0
      t.integer :processed_count, null: false, default: 0
      t.text :errors_json

      t.timestamps null: false
    end
  end
end
