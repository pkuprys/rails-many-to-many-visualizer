class Host < ActiveRecord::Base
  attr_accessible :name, :category_id, :user_id
  validates_presence_of :category_id, :name
  belongs_to :category
  has_and_belongs_to_many :members
end
