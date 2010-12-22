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



DB.create_table(:residents) do
  primary_key :id, :type => Integer
  string :name
  integer :country_id
end
# A slugged model that uses a scope
class Resident < Sequel::Model
  many_to_one :country
  plugin :friendly_id, :name, :use_slug => true, :scope => :country
end

DB.create_table(:countries) do
  primary_key :id, :type => Integer
  string :name
end
# A slugged model used as a scope
class Country < Sequel::Model
  one_to_many :residents
  plugin :friendly_id, :name, :use_slug => true
end

DB.create_table(:home_owners) do
  primary_key :id, :type => Integer
  string :name
end
# A model that doesn't use slugs
class HomeOwner < Sequel::Model
  plugin :friendly_id, :name
  one_to_many :house
end

DB.create_table(:houses) do
  primary_key :id, :type => Integer
  string :name
  integer :home_owner_id
end
# A model that uses a non-slugged model for its scope
class House < Sequel::Model
  many_to_one :home_owner
  plugin :friendly_id, :name, :use_slug => true, :scope => :home_owner
end


