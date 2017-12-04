class ImportHistoryController < ApplicationController
  def show
    id = params[:id]
    import_history = ImportHistory.find(id)
    render json: import_history.to_h
  end
end
