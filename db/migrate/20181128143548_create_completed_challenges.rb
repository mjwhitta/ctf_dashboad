class CreateCompletedChallenges < ActiveRecord::Migration[5.2]
    def change
        create_table :completed_challenges do |t|
            t.string :username
            t.string :name
        end
    end
end
