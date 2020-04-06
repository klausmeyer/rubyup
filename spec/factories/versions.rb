FactoryBot.define do
  factory :version do
    string { '2.6.3' }
    link   { 'https://www.ruby-lang.org/en/news/2019/04/17/ruby-2-6-3-released/' }
    state  { 'available' }
  end

  factory :version_old, parent: :version do
    string { '2.6.2' }
    link   { 'https://www.ruby-lang.org/en/news/2019/03/13/ruby-2-6-2-released/' }
  end

  factory :version_new, parent: :version do
    string { '2.6.3' }
    link   { 'https://www.ruby-lang.org/en/news/2019/04/17/ruby-2-6-3-released/' }
  end
end
