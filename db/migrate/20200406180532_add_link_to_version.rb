class AddLinkToVersion < ActiveRecord::Migration[6.0]
  def change
    add_column :versions, :link, :string
  end
end
