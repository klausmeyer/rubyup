FactoryBot.define do
  factory :repository do
    name { 'example/repo' }
    url  { 'git@github.example.com:example/repo.git' }
  end
end
