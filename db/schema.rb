# frozen_string_literal: true

ActiveRecord::Schema.define(version: 2021_01_30_181316) do

  create_table 'cages', force: :cascade do |t|
    t.integer 'maximum_capacity', default: 5
    t.integer 'power_status', default: 1
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'dinosaurs', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'species', null: false
    t.integer 'cage_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['cage_id'], name: 'index_dinosaurs_on_cage_id'
  end

  add_foreign_key 'dinosaurs', 'cages'
end
