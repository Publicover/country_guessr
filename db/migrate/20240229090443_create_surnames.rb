class CreateSurnames < ActiveRecord::Migration[7.0]
  def change
    create_table :surnames do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
