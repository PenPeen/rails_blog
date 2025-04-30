class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.references :user, null: false
      t.string :uuid, null: false, index: { unique: true }
      t.datetime :expired_at, null: false
      t.timestamps
    end
  end
end
