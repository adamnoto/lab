describe Operation do
  subject { described_class }
  before do
    Operation.instance_variable_set(:@mapped_companies, nil)
    Operation.instance_variable_set(:@mapped_categories, nil)
  end

  describe '#parse_date' do
    let(:date) { Date.strptime("02/12/1992", "%d/%m/%Y") }

    it 'accepts DD/MM/YYYY' do
      expect(subject.send(:parse_date, "12/02/1992")).to eq date
      expect(subject.send(:parse_date, "12/2/1992")).to eq date
    end

    it 'accepts YYYY-MM-DD' do
      expect(subject.send(:parse_date, "1992-12-02")).to eq date
      expect(subject.send(:parse_date, "1992-12-2")).to eq date
    end

    it 'accepts DD-MM-YYYY' do
      expect(subject.send(:parse_date, "02-12-1992")).to eq date
      expect(subject.send(:parse_date, "2-12-1992")).to eq date
    end

    it 'raises error when not match' do
      expect { subject.send(:parse_date, "02/12/92") }.to raise_error(ArgumentError)
    end
  end # parse_date

  describe '#parse_categories' do
    let(:categories1) { 'Delegation;client;important' }
    let(:categories2) { 'client;delegation;Negligible' }

    before { expect(Category.count).to eq 0 }

    it 'creates all instances when all is missing' do
      categories = subject.send(:parse_categories, categories1)
      expect(categories).to_not be_blank
      expect(Category.count).to eq 3
    end

    it 'is unique and commutative' do
      subject.send(:parse_categories, categories1)
      subject.send(:parse_categories, categories2)
      expect(Category.count).to eq 4
      expect(Category.select(:name).all.pluck(:name)).to eq %w[delegation client important negligible]
    end

    it 'does not create a category instance if found' do
      Category.create!(name: 'delegation')
      expect(Category.count).to eq 1
      subject.send(:parse_categories, categories1)
      expect(Category.count).to eq 3
    end

    it 'returns an empty array if string is blank' do
      expect(subject.send(:parse_categories, '')).to eq []
    end
  end # parse_categories

  describe '#parse_company' do
    let!(:company) { Company.create(name: "Bal") }

    it 'allows whitespaces before and after name' do
      expect(subject.send(:parse_company, " Bal")).to eq company
      expect(subject.send(:parse_company, "Bal ")).to eq company
    end

    it 'allows exact match' do
      expect(subject.send(:parse_company, "Bal")).to eq company
    end

    it 'raises error when not match' do
      expect { subject.send(:parse_company, "Bax") }.to raise_error(ArgumentError)
    end
  end
end
