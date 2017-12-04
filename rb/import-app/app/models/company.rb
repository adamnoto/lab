class Company < ActiveRecord::Base
  extend CompanyInformer
  has_many :operations

  validates_presence_of :name
end
