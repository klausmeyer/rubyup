# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_or_initialize_by(email: 'admin@example.com')
user.password              = '12345678'
user.password_confirmation = user.password
user.save!

version_261 = Version.find_or_create_by!(string: '2.6.1', state: 'failed')
version_262 = Version.find_or_create_by!(string: '2.6.2', state: 'available')
version_263 = Version.find_or_create_by!(string: '2.6.3', state: 'available')

identity = Identity.find_or_create_by!(
  name:           'Ruby Up!',
  email:          'rubyup@example.com',
  github_api_key: '26f7bdd38014c4994fecd7373ca7b424'
)

repo1 = Repository.find_or_create_by!(
  name:   'namespace/repo1',
  url:    'git@github.example.com:namespace/repo1.git',
  branch: 'master'
)

repo2 = Repository.find_or_create_by!(
  name:   'namespace/repo2',
  url:    'git@github.example.com:namespace/repo2.git',
  branch: 'master'
)

repo3 = Repository.find_or_create_by!(
  name:   'namespace/repo3',
  url:    'git@github.example.com:namespace/repo3.git',
  branch: 'develop'
)

if ENV['SEED_JOBS'] == 'true'
  job1 = Job.create!(
    repository:   repo1,
    name:         'Update to Ruby 2.6.3',
    identity:     identity,
    version_from: version_262,
    version_to:   version_263,
    config:       Template.config,
    state:        'created',
    logs:         ['First Execution', 'Second Execution']
  ) if repo1.jobs.count < 1

  job2 = Job.create!(
    repository:   repo1,
    name:         'Update to Ruby 2.6.3',
    identity:     identity,
    version_from: version_262,
    version_to:   version_263,
    config:       Template.config,
    state:        'completed'
  ) if repo1.jobs.count < 2

  job3 = Job.create!(
    repository:   repo2,
    name:         'Update to Ruby 2.6.3',
    identity:     identity,
    version_from: version_262,
    version_to:   version_263,
    config:       Template.config,
    state:        'failed'
  ) if repo2.jobs.empty?
end
