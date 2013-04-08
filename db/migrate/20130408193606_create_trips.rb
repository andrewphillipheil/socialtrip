class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.date :start_date
      t.date :end_date
      t.text :description
      t.references :user

      t.timestamps
    end
  end
end
