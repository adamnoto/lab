FactoryBot.define do
  factory :category do
    name 'client'
  end

  factory :company do
    name 'Foo'
  end

  factory :operation do
    invoice_num { SecureRandom.hex(3) }
    invoice_date Date.today
    operation_date Date.today
    amount { rand * 100 }
    reporter "Adam"
    notes "Lorem ipsum"
    status 'accepted'

    trait(:accepted) { status 'accepted' }
    trait(:rejected) { status 'rejected' }
    kind 'client'
  end
end
