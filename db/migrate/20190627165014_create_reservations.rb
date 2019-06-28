class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :listing, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
