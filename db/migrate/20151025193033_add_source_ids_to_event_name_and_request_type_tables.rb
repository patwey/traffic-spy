class AddSourceIdsToEventNameAndRequestTypeTables < ActiveRecord::Migration
  def change
    add_column :event_names, :source_id, :integer
    add_column :request_types, :source_id, :integer
  end
end
