This is an in-development experimental adapter for
[FriendlyId](http://norman.github.com/friendly_id) using Sequel.

It currently supports all of FriendlyId's features except:

* Cached slugs
* Scoped slugs
* Rake tasks
* Rails Generator

Currently, only finds using `[]` are supported:

    @post = Post["this-is-a-title"]
    @post.friendly_id # this-is-a-title

## Usage

    gem install friendly_id friendly_id_sequel

    require "rubygems"
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

For more information on the available features, please see the
[FriendlyId Guide](http://norman.github.com/friendly_id/file.Guide.html).
