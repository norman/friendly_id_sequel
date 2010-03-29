require "rubygems"
require "active_support"
require "friendly_id"
require "friendly_id/sequel"

DB = Sequel.sqlite
FriendlyId::SequelAdapter::CreateSlugs.apply(DB, :up)

DB.create_table("books") do
  primary_key :id, :type => Integer
  string :name, :unique => true
  string :note
end

class Book < Sequel::Model
  plugin :friendly_id, :name, :use_slug => true
end

Book.create("name" => "Ficciones", "note" => "Jorge Luis Borges's classic short stories.")
p Book["ficciones"]
