module Jobs
  class Create
    def initialize(blueprint:, repositories:)
      self.blueprint    = blueprint
      self.repositories = repositories
    end

    def call
      repositories.each do |repo|
        job = blueprint.dup
        job.repository_id = repo
        job.save!
      end
    end

    private

    attr_accessor :blueprint, :repositories
  end
end
