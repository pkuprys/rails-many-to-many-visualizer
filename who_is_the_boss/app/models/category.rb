class Category < ActiveRecord::Base
  attr_accessible :name, :user_id
  validates_presence_of :name
  has_many :hosts
end
