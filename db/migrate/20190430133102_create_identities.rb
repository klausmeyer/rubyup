class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :name
      t.string :email
      t.text :private_key

      t.timestamps
    end
  end
end
