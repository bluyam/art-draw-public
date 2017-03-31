class AddClickXToGames < ActiveRecord::Migration
  def change
    add_column :games, :clickX, :text
    add_column :games, :clickY, :text
    add_column :games, :clickColor, :text
    add_column :games, :clickDrag, :text
  end
end
