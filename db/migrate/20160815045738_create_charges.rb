class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.references :user, foreign_key: true
      t.references :subscription, foreign_key: true
      t.string :charge_stripe_id
      t.string :type_of_charge
      t.integer :amount
      t.string :additional_charges
      t.string :date_of_charge
      t.string :card_charged

      t.timestamps
    end
  end
end
