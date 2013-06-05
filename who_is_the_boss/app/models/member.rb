class Member < ActiveRecord::Base
  attr_accessible :name, :user_id
  validates_presence_of :name
  has_and_belongs_to_many :hosts
  
  # def memberships
    # Membership.where(:member_id => self.id, :user_id => session[:user_id])
  # end

end