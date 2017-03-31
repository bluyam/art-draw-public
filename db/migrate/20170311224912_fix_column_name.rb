class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :games, :username, :challenge_name
  end
end
