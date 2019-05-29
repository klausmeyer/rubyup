FactoryBot.define do
  factory :version do
    string { '2.6.3' }
  end

  factory :version_old, parent: :version do
    string { '2.6.2' }
  end

  factory :version_new, parent: :version do
    string { '2.6.3' }
  end
end
