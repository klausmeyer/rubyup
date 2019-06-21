class RemovePrivateKeyFromIdentities < ActiveRecord::Migration[5.2]
  def change
    remove_column :identities, :private_key
  end
end
