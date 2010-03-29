This is an in-development experimental adapter for
[FriendlyId](http://norman.github.com/friendly_id) using Sequel.

It currently supports all of FriendlyId's features except:

* Cached slugs
* Scoped slugs
* Rake tasks
* Rails Generator

Currently, only finds using `[]` are supported; I'll be adding some custom
filters to make working with slugged records easier if anybody ends up using
this.

    @post = Post["this-is-a-title"]
    @post.friendly_id # this-is-a-title

## Usage

    gem install friendly_id friendly_id_sequel

    require "friendly_id"
    require "friendly_id/sequel"

    class Post < Sequel::Model
      plugin :friendly_id :title, :use_slug => true
    end


For more information on the available features, please see the
[FriendlyId Guide](http://norman.github.com/friendly_id/file.Guide.html).
