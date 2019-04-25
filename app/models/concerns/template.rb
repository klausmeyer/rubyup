class Template
  def self.config
    {
      ticket:       'FOO-123',
      message:      '%{ticket}: update to ruby %{version_to}',
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
