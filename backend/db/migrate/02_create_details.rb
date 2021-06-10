class CreateDetails < ActiveRecord::Migration[5.1]
    def change
        create_table :details do |t|
            t.string :info
            t.string :label
            t.integer :contact_id
        end
    end
end