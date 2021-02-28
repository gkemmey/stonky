class CreateInitialDatabase < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest

      t.timestamps
    end
    add_index :users, 'lower(username)', name: 'index_users_on_username', unique: true
  end
end
