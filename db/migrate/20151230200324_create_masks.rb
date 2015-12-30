class CreateMasks < ActiveRecord::Migration
  def change
    create_table :masks do |t|
      t.string :phone_number
      t.references :number, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
