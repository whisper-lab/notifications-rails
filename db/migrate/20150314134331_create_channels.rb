class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :description
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :channels, :users
  end
end
