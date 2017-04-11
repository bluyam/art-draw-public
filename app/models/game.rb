class Game < ActiveRecord::Base
  belongs_to :challenger, :class_name => 'User', :foreign_key => 'challenger_id'
  belongs_to :opponent, :class_name => 'User', :foreign_key => 'opponent_id'
  :clickX
  :clickY
  :clickDrag
  :clickColor
  :challenge_name
  

  before_save :my_awesome_pre_save_method
  protected
  def my_awesome_pre_save_method
    if User.find_by_user_by_username(self.challenge_name) != nil
      self.opponent_id = User.find_by_user_by_username(self.challenge_name).id

    else
      raise "error"
    end
  end
  
  def self.search(search)
    if search
      self.all.where({:challenge_name => ["field LIKE ?", "#{search}%"]})
    else
      self.nil
    end
  end
  
  validates_length_of :title, :maximum => 500
end
