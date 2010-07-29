require "sequel"
require "friendly_id/sequel_adapter/simple_model"
require "friendly_id/sequel_adapter/slugged_model"
require "friendly_id/sequel_adapter/create_slugs"

unless Object.public_method_defined? :blank
  require "sequel/extensions/blank.rb"
end

unless String.public_method_defined? :constantize
  require "sequel/extensions/inflector.rb"
end

module Sequel
  module Plugins
    module FriendlyId

      def self.configure(model, method, opts={})
        model.instance_eval do
          self.friendly_id_config = ::FriendlyId::Configuration.new(model, method, opts)
          if friendly_id_config.use_slug?
            require "friendly_id/sequel_adapter/slug"
            include ::FriendlyId::SequelAdapter::SluggedModel
          else
            include ::FriendlyId::SequelAdapter::SimpleModel
          end
        end
      end

      module ClassMethods
        attr_accessor :friendly_id_config
      end
    end
  end
end
