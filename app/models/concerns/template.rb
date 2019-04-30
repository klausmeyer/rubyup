class Template
  def self.name
    'Update Ruby to 2.6.3'
  end

  def self.config
    {
      ticket:       'FOO-123',
      message:      '%{ticket}: update to ruby %{version_to}',
      details:      ':link: https://www.ruby-lang.org/en/news/2019/04/17/ruby-2-6-3-released/',
      version_from: '2.6.2',
      version_to:   '2.6.3',
      files: [
        '.ruby-version',
        '.travis.yml',
        'Gemfile',
        'Dockerfile'
      ]
    }.stringify_keys
  end
end
