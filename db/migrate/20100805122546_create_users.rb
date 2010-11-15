class CreateUsers < ActiveRecord::Migration
  def self.up
    # მომხმარებელთა ცხრილის შექმნა
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.boolean :admin

      t.timestamps
    end

    # მომხმარებლის სახელი უნდა იყოს უნიკალური
    add_index :users, :name, :unique => true
  end

  def self.down
    drop_table :users
  end
end
