require "sequel"
require File.join(File.dirname(__FILE__), "friendly_id", "sequel_adapter", "simple_model")
require File.join(File.dirname(__FILE__), "friendly_id", "sequel_adapter", "slugged_model")
require File.join(File.dirname(__FILE__), "friendly_id", "sequel_adapter", "create_slugs")

module Sequel

  module Plugins

    module FriendlyId

      def self.configure(model, method, opts={})
        model.instance_eval do
          if friendly_id_config.use_slug?
            require File.join(File.dirname(__FILE__), "friendly_id", "sequel_adapter", "slug")
            include ::FriendlyId::SequelAdapter::SluggedModel
          else
            include ::FriendlyId::SequelAdapter::SimpleModel
          end
        end
      end

      module ClassMethods
        attr_accessor :friendly_id_config
        def friendly_id_config
          @friendly_id_config ||= ::FriendlyId::Configuration.new(self, *friendly_id_opts)
        end
      end

    end
  end

end
