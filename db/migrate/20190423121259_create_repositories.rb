class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :url, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
