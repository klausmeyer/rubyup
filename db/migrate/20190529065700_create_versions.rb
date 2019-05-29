class CreateVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versions do |t|
      t.string :string, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
