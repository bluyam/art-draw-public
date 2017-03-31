class AddUsernameToGames < ActiveRecord::Migration
  def change
    add_column :games, :username, :string
  end
end
