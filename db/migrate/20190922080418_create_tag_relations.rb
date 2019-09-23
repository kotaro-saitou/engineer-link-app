class CreateTagRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_relations do |t|
      t.references :user, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
      t.index [:user_id, :tag_id], unique: true
    end
  end
end
