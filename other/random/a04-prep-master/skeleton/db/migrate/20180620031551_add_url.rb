class AddUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :url, :string
  end
end
