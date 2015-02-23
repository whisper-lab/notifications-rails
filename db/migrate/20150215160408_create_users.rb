class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :sex

      t.decimal :lat
      t.decimal :lng

      t.timestamps null: false
    end
  end
end
