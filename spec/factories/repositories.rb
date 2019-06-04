FactoryBot.define do
  factory :repository do
    sequence(:name) { |n| "example/repo#{n}" }
    sequence(:url)  { |n| "git@github.example.com:example/repo#{n}.git" }
  end
end
