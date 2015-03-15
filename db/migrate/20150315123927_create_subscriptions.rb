class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.references :channel, index: true
      t.datetime :subscription_date

      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
    add_foreign_key :subscriptions, :channels
  end
end
