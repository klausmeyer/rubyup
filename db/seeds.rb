# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

repo1 = Repository.find_or_create_by!(
  name: 'namespace/repo1',
  url:  'https://github.example.com/namespace/repo3'
)

repo2 = Repository.find_or_create_by!(
  name: 'namespace/repo2',
  url:  'https://github.example.com/namespace/repo2'
)

repo3 = Repository.find_or_create_by!(
  name: 'namespace/repo3',
  url:  'https://github.example.com/namespace/repo3'
)

if ENV['SEED_JOBS'] == 'true'
  job1 = Job.create!(
    repository: repo1,
    name:       'Update to Ruby 2.6.3',
    config:     Template.config.to_yaml,
    state:      'created'
  ) if repo1.jobs.count < 1

  job2 = Job.create!(
    repository: repo1,
    name:       'Update to Ruby 2.6.3',
    config:     Template.config.to_yaml,
    state:      'completed'
  ) if repo1.jobs.count < 2

  job3 = Job.create!(
    repository: repo2,
    name:       'Update to Ruby 2.6.3',
    config:     Template.config.to_yaml,
    state:      'failed'
  ) if repo2.jobs.empty?
end
