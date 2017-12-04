class Operation < ActiveRecord::Base
  extend OperationsImporter
  belongs_to :company

  validates_presence_of :invoice_num, :invoice_date, :amount, :operation_date, :kind, :status
  validates_numericality_of :amount, greater_than: 0
  validates_uniqueness_of :invoice_num

  has_many :operation_categories
  has_many :categories, through: :operation_categories
end
