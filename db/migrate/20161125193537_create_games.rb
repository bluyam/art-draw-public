class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.belongs_to :challenger, index: true, foreign_key: true
      t.belongs_to :opponent, index: true, foreign_key: true
      t.boolean :active
      t.string :title
      t.text :clickX
      t.text :clickY
      t.text :clickDrag
      t.text :clickColor
      t.timestamps null: false
    end
  end
  
end
