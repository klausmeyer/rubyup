class AddVersionsToJobs < ActiveRecord::Migration[5.2]
  def change
    change_table :jobs do |t|
      t.references :version_from, null: false
      t.references :version_to, null: false
    end
  end
end
