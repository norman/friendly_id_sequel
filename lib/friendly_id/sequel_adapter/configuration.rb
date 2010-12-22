module FriendlyId
  module SequelAdapter

    # Extends FriendlyId::Configuration with some implementation details and
    # features specific to Sequel.
    class Configuration < FriendlyId::Configuration

      # An array of classes for which the configured class serves as a
      # FriendlyId scope.
      attr_reader :child_scopes

      def child_scopes
        @child_scopes ||= associated_friendly_classes.select do |klass|
          klass.friendly_id_config.scopes_over?(configured_class)
        end
      end

      def scopes_over?(klass)
        scope? && scope == klass.to_s.underscore.to_sym
      end

      def scope_for(record)
        scope? ? record.send(scope).friendly_id : nil
      end

      private

      def associated_friendly_classes
        configured_class.association_reflections.values.map{ |association|
          association[:class_name].constantize
        }.select { |klass| 
          klass.respond_to?(:friendly_id_config)
        }
      end
    end
  end
end

