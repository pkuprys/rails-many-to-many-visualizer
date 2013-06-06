class Member < ActiveRecord::Base
  attr_accessible :name, :user_id, :host_ids
  validates_presence_of :name
  has_and_belongs_to_many :hosts
end