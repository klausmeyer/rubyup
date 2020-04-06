class AddBranchToRepository < ActiveRecord::Migration[6.0]
  def change
    add_column :repositories, :branch, :string, null: false, default: 'master'
  end
end
