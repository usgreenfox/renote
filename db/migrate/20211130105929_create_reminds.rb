class CreateReminds < ActiveRecord::Migration[5.2]
  def change
    create_table :reminds do |t|
      t.references :user, foreign_key: true
      t.references :note, foreign_key: true
      t.integer :first_notice, default: 1, null: false
      t.integer :second_notice, default: 7, null: false
      t.integer :third_notice, default: 30, null: false

      t.timestamps
    end
  end
end
