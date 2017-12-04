module OperationsImporter
  def import_all(rows, import_history: nil)
    @mapped_companies = nil
    @mapped_categories = nil
    errors = []

    # prepare import history
    import_history.rows_count = rows.count - 1
    import_history.save

    # index starts with 2 because: skip header, and index 0 = row 1 so index + 1
    # so the index is in human terms rather than machine's term
    rows.each.with_index(2) do |row, idx|
      begin
        record_data = {}
        record_data['company'],
          record_data['invoice_num'],
          record_data['invoice_date'],
          record_data['operation_date'],
          record_data['amount'],
          record_data['reporter'],
          record_data['notes'],
          record_data['status'],
          record_data['kind'] = row

        record_data['company'] = parse_company(record_data['company'])
        record_data['invoice_date'] = parse_date(record_data['invoice_date'])
        record_data['operation_date'] = parse_date(record_data['operation_date'])
        categories = parse_categories(record_data['kind'])
        record_data['kind'] = categories.map(&:name).join(';')
        operation = Operation.new(record_data)
        operation.save!

        categories.each do |category|
          category.operation_categories.create!(operation: operation)
        end

        # update import history necessarily
        if rand > 0.75 && import_history
          import_history.processed_count = idx - 1 # use machine term
          import_history.errors = errors
          import_history.save! rescue nil
        end
      rescue => e
        errors << {row: idx, message: normalize_encoding(e.message)}
      end
    end

    import_history.processed_count = import_history.rows_count
    import_history.errors = errors
    import_history.save
  end

  private

  def parse_date(date)
    if date =~ %r{\d{1,2}/\d{1,2}/\d{4,4}}
      Date.strptime(date, "%m/%d/%Y")
    elsif date =~ %r{\d{4,4}-\d{1,2}-\d{1,2}}
      Date.strptime(date, "%Y-%m-%d")
    elsif date =~ %r{\d{1,2}-\d{1,2}-\d{4,4}}
      Date.strptime(date, "%d-%m-%Y")
    else
      date = date.blank? ? "No data." : date
      fail ArgumentError, "Date format must be either MM/DD/YYYY, YYYY-MM-DD or DD-MM-YYYY. Given: #{date}"
    end
  end

  # it will split the category and return an instance of Category
  def parse_categories(categories)
    @mapped_categories = {} unless @mapped_categories
    return [] if categories.blank?
    categories = categories.split(';').map(&:downcase).uniq

    categories.map! do |category_name|
      category = @mapped_categories[category_name]
      unless category
        category = Category.find_or_create_by(name: category_name)
        @mapped_categories[category_name] = category
      end
      category
    end

    categories
  end

  def parse_company(company_name)
    @mapped_companies = {} unless @mapped_companies
    if company_name
      company_name = company_name.strip
      company = @mapped_companies[company_name]
      return company if @mapped_companies.has_key? company_name

      company = Company.where(name: company_name).first
      @mapped_companies[company_name] = company
      company or fail ArgumentError, "Unknown company: #{company_name}"
    end
  end

  def normalize_encoding(text)
    text.force_encoding("UTF-8") rescue text
  end
end
