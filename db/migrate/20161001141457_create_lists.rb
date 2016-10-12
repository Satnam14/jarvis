class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      # Trello Fields
      t.string :title, null: false
      t.integer :board_id, null: false
      t.boolean :archived, null: false, default: false

      # Our Fields
      t.integer :priority
      t.timestamps
    end

    add_index :lists, :title
    add_index :lists, :board_id
  end
end
