require "rubygems"
require "sequel"
require "sequel/extensions/migration"
require "active_support"
require "friendly_id"
require "friendly_id/test"
require "logger"
require "test/unit"
require "mocha"

DB = Sequel.sqlite

require File.dirname(__FILE__) + "/../lib/friendly_id_sequel"
require File.dirname(__FILE__) + "/../lib/friendly_id/sequel_adapter/create_slugs"
require File.dirname(__FILE__) + "/core"
require File.dirname(__FILE__) + "/simple"
require File.dirname(__FILE__) + "/slugged"

FriendlyId::SequelAdapter::CreateSlugs.apply(DB, :up)
require File.dirname(__FILE__) + "/../lib/friendly_id/sequel_adapter/slug"

%w[books users].each do |table|
  DB.create_table(table) do
    primary_key :id, :type => Integer
    string :name, :unique => true
    string :note
  end
end

class Book < Sequel::Model; end
class User < Sequel::Model; end

Book.plugin :friendly_id, :name
User.plugin :friendly_id, :name

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

# DB.loggers << Logger.new($stdout)
