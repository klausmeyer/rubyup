class Template
  def self.name
    "Update Ruby to #{ruby_version}"
  end

  def self.config
    {
      message: name,
      details: ":link: #{ruby_link}"
    }
  end

  private

  def self.ruby_version
    return 'x.y.z' if (version = Version.for_select.last).nil?

    version.string
  end

  def self.ruby_link
    return 'https://www.ruby-lang.org/' if (version = Version.for_select.last).nil?

    version.link
  end
end
