class OperationCategory < ActiveRecord::Base
  validates_presence_of :operation_id, :category_id
  belongs_to :operation
  belongs_to :category
end
