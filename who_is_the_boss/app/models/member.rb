class Member < ActiveRecord::Base
  attr_accessible :name, :user_id
  validates_presence_of :name
  has_many :memberships
  has_many :hosts, :through => :memberships
  
  def memberships
    Membership.where(:member_id => self.id, :user_id => session[:user_id])
  end

end