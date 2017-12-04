module CompanyInformer
  class InformationFetcher
    attr_reader :company

    def initialize(company)
      @company = company
    end

    def number_of_operations
      company.operations.count
    end

    def number_of_accepted_operations
      company.operations.where(status: 'accepted').count
    end

    def average_operation_amount
      amount = company.operations.average(:amount)
      amount.to_f.round(2) if amount
    end

    def monthly_highest_operation(date: Date.today)
      start_date, end_date = date.beginning_of_month, date.end_of_month
      amount = company.operations
        .where(operation_date: start_date..end_date)
        .maximum(:amount)
      amount.to_f.round(2) if amount
    end

    def to_h
      {
        noops: number_of_operations,
        opsacp: number_of_accepted_operations,
        avgamt: average_operation_amount,
        mohigh: monthly_highest_operation
      }
    end
  end # InformationFetcher

  def info(id)
    InformationFetcher.new(id).to_h
  end

  def all_info
    Company.select(:name, :id).includes(:operations).map do |comp|
      data = {}
      data[:comp] = comp.attributes
      data[:comp][:op] = info(comp).to_h
      data
    end
  end
end
