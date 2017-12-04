class OperationsController < ApplicationController
  def index
    respond_to do |format|
      format.html { render }
      format.json do
        company_id = params[:company_id]
        operations = Operation.where(company_id: company_id)
          .select(:id, :invoice_num, :invoice_date, :operation_date, :amount, :reporter, :notes, :status, :kind, :company_id)
          .order("operation_date DESC")
          .all.limit(10)
          .map(&:attributes)
        render json: operations
      end
    end
  end

  def import
  end

  def process_import
    file = params[:file].read

    begin
      data = CSV.parse(file)[1..-1]
    rescue CSV::MalformedCSVError
      render json: {success: false, message: 'Please upload a proper CSV file'} and return
    end

    import_history = ImportHistory.create!
    ImportOperationJob.perform_async(data, import_history)
    render json: {success: true, import_history_id: import_history.id}
  end
end
