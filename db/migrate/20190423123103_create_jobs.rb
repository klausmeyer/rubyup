class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.references :repository, null: false
      t.string :name, null: false
      t.text :config, null: false
      t.string :state, null: false
      t.text :logs, null: true

      t.timestamps
    end
  end
end
