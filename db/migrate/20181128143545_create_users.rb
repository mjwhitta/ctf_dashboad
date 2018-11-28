class CreateUsers < ActiveRecord::Migration[5.2]
    def change
        create_table :users do |t|
            t.string :username
            t.string :salt
            t.string :passhash
            t.integer :score
        end
    end
end
