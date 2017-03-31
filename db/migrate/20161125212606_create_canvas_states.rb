class CreateCanvasStates < ActiveRecord::Migration
  def change
    create_table :canvas_states do |t|
      t.belongs_to :game, index: true, foreign_key: true
      t.text :clickX
      t.text :clickY
      t.text :clickDrag
      t.text :clickColor

      t.timestamps null: false
    end
  end
end
