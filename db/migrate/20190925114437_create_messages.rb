class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :from_id
      t.integer :to_id
      t.string :room_id

      t.timestamps
    end
    add_index :messages, [:room_id, :created_at]
  end
end
