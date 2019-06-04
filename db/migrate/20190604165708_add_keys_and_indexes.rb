class AddKeysAndIndexes < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :jobs, :repositories
    add_foreign_key :jobs, :identities
    add_foreign_key :jobs, :versions, column: :version_from_id
    add_foreign_key :jobs, :versions, column: :version_to_id
  end
end
