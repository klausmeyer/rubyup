class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :github_api_key, null: false
      t.text :private_key, null: false

      t.timestamps
    end
  end
end
