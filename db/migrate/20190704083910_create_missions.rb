class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.references :listing, foreign_key: true
      t.string :mission_type
      t.integer :price
      t.date :date

      t.timestamps
    end
  end
end
