FactoryBot.define do
  factory :identity do
    name           { 'John Doe' }
    email          { 'john.doe@example.com' }
    github_api_key { 'github-api-key' }
  end
end
