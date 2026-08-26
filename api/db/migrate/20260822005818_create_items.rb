class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
