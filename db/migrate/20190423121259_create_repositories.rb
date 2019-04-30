class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.references :identity, null: false

      t.timestamps
    end
  end
end
