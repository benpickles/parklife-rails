FactoryBot.define do
  factory :post do
    sequence(:slug) { |n| "slug-#{n}" }
    sequence(:title) { |n| "Title #{n}" }
    body { 'foo' }
  end
end
