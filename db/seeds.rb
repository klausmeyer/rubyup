# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

key = <<~RSA
  -----BEGIN RSA PRIVATE KEY-----
  MIICWwIBAAKBgQDhew+CQZZ36Sufqlw7eht+eYUjG63R0Jf370TGMqSmBqQ81a7R
  650kbeKkD4K/lzshGw31PqcMOS/iX6aU+yOdCfCK5nT3Cs69zO/fnO3e/VQTGTnW
  7/+3SnSyt9iJq6MbNQtv49PAKBumCL+ok/yM0jJxuMEVTxoLTxLAXRpqxQIDAQAB
  AoGAN18fGd+9cckC+3y8laaQ5eg1t79uWh4dk7dgbkO1h0gOQRpAijCQMIgDpkJg
  22fqD2EzdkxifW/1wGO45tEdl1bKCQx7kypesJfzbDjqAk2IrRZ6aGRaNcw3hWCR
  8dMAV6vFf69SEGJ1lDkr045L8+v41TxHVJwzw2vkD6TvUSkCQQD+67GUdQICb0sO
  29lxXhTjTGei2O1khru/ATLnFFH+4E3N5sIERxE9002PBtkc2k+fT2bzU+VY+q+d
  Y5t+dif3AkEA4m91CYUJdSTlk9yqo3YpGlUf8ZEgiZ4rcs6OCNT6Ca8x3eou/VSi
  HjPAbcJoCf2miHvigovfcyyAwwfQhG+sIwJACVvRyyd4iWpYkRUVKIpRrf6SF3Jr
  VLN1lQ+QNNeUIw1NDfAY01tgkKp/QG757Ys+PRUHLIu58chSRi7v+HaSBQJAIIo3
  3Xha1ZTJ0Sfi9b6jRX96KbLbZCtwvvzj+GzyybV9ixB+VDV3XrO9MYjAfr8O0YpM
  EMqc/+YjUuOqmX2a1QJAM7uq3yMuPjDIlj+JtxC3h/wlIh1yIPAEPBq38UAZnwez
  oezyhlalJG5aOEVKE3aI1MH72C02dNvhtxrtGH7YCQ==
  -----END RSA PRIVATE KEY-----
RSA

identity = Identity.find_or_create_by!(
  name:           'Ruby Up!',
  email:          'rubyup@example.com',
  github_api_key: '26f7bdd38014c4994fecd7373ca7b424',
  private_key:    key
)

repo1 = Repository.find_or_create_by!(
  name:     'namespace/repo1',
  url:      'https://github.example.com/namespace/repo3'
)

repo2 = Repository.find_or_create_by!(
  name:     'namespace/repo2',
  url:      'https://github.example.com/namespace/repo2'
)

repo3 = Repository.find_or_create_by!(
  name:     'namespace/repo3',
  url:      'https://github.example.com/namespace/repo3'
)

if ENV['SEED_JOBS'] == 'true'
  job1 = Job.create!(
    repository: repo1,
    name:       'Update to Ruby 2.6.3',
    identity:   identity,
    config:     Template.config,
    state:      'created',
    logs:       ['First Execution', 'Second Execution']
  ) if repo1.jobs.count < 1

  job2 = Job.create!(
    repository: repo1,
    name:       'Update to Ruby 2.6.3',
    identity:   identity,
    config:     Template.config,
    state:      'completed'
  ) if repo1.jobs.count < 2

  job3 = Job.create!(
    repository: repo2,
    name:       'Update to Ruby 2.6.3',
    identity:   identity,
    config:     Template.config,
    state:      'failed'
  ) if repo2.jobs.empty?
end
