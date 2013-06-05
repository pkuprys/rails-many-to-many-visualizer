class Membership < ActiveRecord::Base
  attr_accessible :host_id, :member_id, :user_id
  belongs_to :hosts
  belongs_to :members
end
