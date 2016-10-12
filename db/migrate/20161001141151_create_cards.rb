class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      # Trello Fields
      t.string :title, null: false
      t.integer :list_id, null: false
      t.boolean :archived, default: false
      t.integer :position

      t.timestamps
    end

    add_index :cards, :list_id
    add_index :cards, :title
  end
end
