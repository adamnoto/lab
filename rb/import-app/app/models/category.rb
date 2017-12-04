class Category < ActiveRecord::Base
  validates_presence_of :name

  has_many :operation_categories
  has_many :operations, through: :operation_categories
end
