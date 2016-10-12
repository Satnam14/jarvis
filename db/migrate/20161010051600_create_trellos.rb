class CreateTrellos < ActiveRecord::Migration[5.0]
  def change
    create_table :trellos do |t|

      t.timestamps
    end
  end
end
