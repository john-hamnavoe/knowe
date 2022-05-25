class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.boolean :active
      t.string :base_url
      t.string :pat_token
      t.string :auth_cookie
      t.integer :expiry_minutes
      t.datetime :auth_cookie_updated_at
      t.string :version
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
