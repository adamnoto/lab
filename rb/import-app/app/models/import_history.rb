class ImportHistory < ActiveRecord::Base
  def success_count
    processed_count - failed_count
  end

  def errors
    return @errors if @errors
    @errors = JSON.parse(errors_json || '[]')
  end

  def errors=(errors)
    @errors = errors || []
    write_attribute(:errors_json, @errors.to_json)
    @errors
  end

  def failed_count
    errors.count
  end

  def progress
    ((1.0 * processed_count / rows_count) * 100.0).round(1)
  end

  def to_h
    {
      rows_count: rows_count,
      errors: errors,
      failed: errors.count,
      processed: processed_count,
      success_count: success_count,
      progress: progress
    }
  end
end
