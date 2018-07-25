class CreateSetupTable < ActiveRecord::Migration[5.2]
  def up
    create_table :ellie_rollover_setup do |t|
      t.string :product_title
      t.bigint :product_id
      t.string :new_title
      t.decimal :new_price, precision: 10, scale: 2
      t.string :new_template
      t.boolean :is_rolled_over, default: false

    end
  end

  def down
    drop_table :ellie_rollover_setup
  end
end
