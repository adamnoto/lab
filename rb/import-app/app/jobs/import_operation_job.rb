class ImportOperationJob
  include SuckerPunch::Job

  def perform(rows, import_history)
    Operation.import_all(rows, import_history: import_history)
  end
end
