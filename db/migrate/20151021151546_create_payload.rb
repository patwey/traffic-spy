class CreatePayload < ActiveRecord::Migration
  def change
    drop_table :data

    create_table :payloads do |t|
      t.integer :source_id
      t.text :sha
    end
  end
end
