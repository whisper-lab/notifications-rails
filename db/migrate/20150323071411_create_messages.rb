class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :channel, index: true, null: false
      t.string :title
      t.text :body
      t.boolean :sent
      t.datetime :date

      t.timestamps null: false
    end
  end
end
