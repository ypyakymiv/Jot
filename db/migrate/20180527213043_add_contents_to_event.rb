class AddContentsToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :contents, :json
  end
end
