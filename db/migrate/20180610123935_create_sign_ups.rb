class CreateSignUps < ActiveRecord::Migration[5.1]
  def change
    create_table :sign_ups do |t|
      t.timestamps
    end
    add_reference :sign_ups, :user, index: true, null: false
    add_reference :sign_ups, :event, index: true, null: false
    add_index :sign_ups, [:user_id, :event_id], unique: true
  end
end
