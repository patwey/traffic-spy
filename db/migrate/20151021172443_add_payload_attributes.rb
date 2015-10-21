class AddPayloadAttributes < ActiveRecord::Migration
  def change
    add_column :payloads, :url, :text
    add_column :payloads, :requested_at, :text
    add_column :payloads, :responded_in, :integer
    add_column :payloads, :referred_by, :text
    add_column :payloads, :request_type, :text
    add_column :payloads, :event_name, :text
    add_column :payloads, :user_agent, :text
    add_column :payloads, :resolution_width, :text
    add_column :payloads, :resolution_height, :text
  end
end
