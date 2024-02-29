class CreateSurnameNationalities < ActiveRecord::Migration[7.0]
  def change
    create_table :surname_nationalities do |t|
      t.references :surname, null: false, foreign_key: true
      t.references :nationality, null: false, foreign_key: true
      t.string :surname_name
      t.string :nationality_name

      t.timestamps
    end
  end
end
