class AddUrlRequestTypesAndEventNames < ActiveRecord::Migration
  def change
    drop_table :payloads

    create_table :payloads do |t|
      t.integer "source_id"
      t.text    "sha"
      t.integer "url_id"
      t.text    "requested_at"
      t.integer "responded_in"
      t.text    "referred_by"
      t.integer "request_type_id"
      t.integer "event_name_id"
      t.text    "user_agent"
      t.text    "resolution_width"
      t.text    "resolution_height"
    end

    create_table :urls do |t|
      t.text "url"
    end

    create_table :request_types do |t|
      t.text "request_type"
    end

    create_table :event_names do |t|
      t.text "event_name"
    end
  end
end
