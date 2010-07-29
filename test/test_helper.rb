require "rubygems"
require "bundler"
Bundler.setup

require "sequel"
require "friendly_id"
require "friendly_id/test"
require "friendly_id_sequel"
require "logger"
require "test/unit"
require "mocha"

require File.expand_path("../core", __FILE__)
require File.expand_path("../simple", __FILE__)
require File.expand_path("../slugged", __FILE__)

DB = Sequel.sqlite
FriendlyId::SequelAdapter::CreateSlugs.apply(DB, :up)

%w[books users].each do |table|
  DB.create_table(table) do
    primary_key :id, :type => Integer
    string :name, :unique => true
    string :note
  end
end

class Book < Sequel::Model; end
class User < Sequel::Model; end
[Book, User].each do |klass|
  klass.plugin :friendly_id, :name
end

%w[animals cities people posts].each do |table|
  DB.create_table(table) do
    primary_key :id, :type => Integer
    string :name
    string :note
  end
end

class Animal < Sequel::Model; end
class Cat < Animal; end
class City < Sequel::Model; end
class Post < Sequel::Model; end
class Person < Sequel::Model
  def normalize_friendly_id(string)
    string.upcase
  end
end

[Cat, City, Post, Person].each do |klass|
  klass.plugin :friendly_id, :name, :use_slug => true
end

DB.loggers << Logger.new($stdout) if ENV["LOG"]
