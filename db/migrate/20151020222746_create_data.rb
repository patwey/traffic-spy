class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.text :source_id
    end
  end
end
