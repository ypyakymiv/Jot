class AddGeoToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :address, :string
    add_column :events, :lat, :float
    add_column :events, :lng, :float
  end
end
