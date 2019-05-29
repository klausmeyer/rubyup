FactoryBot.define do
  factory :job do
    association :repository
    association :identity
    association :version_from, factory: :version_old
    association :version_to, factory: :version_new

    name   { Template.name }
    config { Template.config }
    state  { 'created' }
    logs   { [] }
  end
end
