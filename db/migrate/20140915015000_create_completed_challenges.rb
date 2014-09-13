class CreateCompletedChallenges < ActiveRecord::Migration
    def change
        create_table :completed_challenges do |t|
            t.string :username
            t.string :name
        end
    end
end
