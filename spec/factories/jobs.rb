FactoryBot.define do
  factory :job do
    association :repository
    association :identity

    name   { Template.name }
    config { Template.config }
    state  { 'created' }
    logs   { [] }
  end
end
