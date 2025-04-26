class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :key, null: false

      t.timestamps
    end

    add_index :sessions, :key, unique: true
  end
end
