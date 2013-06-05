class Host < ActiveRecord::Base
  attr_accessible :name, :category_id, :user_id
  validates_presence_of :category_id, :name
  belongs_to :category
  has_and_belongs_to_many :members
  
  # def memberships user_id
    # memberships = Membership.where(:host_id => self.id, :user_id => user_id)
  # end
#   
  # def notMembers user_id
    # memberships = self.memberships user_id
    # members = []
    # memberships.each do |m|
      # members.add_all Members.where(:id => m.member_id) 
    # end
    # return members
  # end
end
