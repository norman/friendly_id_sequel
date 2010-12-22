module FriendlyId
  module SequelAdapter
    module SimpleModel

      def self.included(base)
        def base.primary_key_lookup(pk)
          if !pk.unfriendly_id?
            table = simple_table
            column = friendly_id_config.column
            query = "SELECT * FROM #{table} WHERE #{column} = #{dataset.literal(pk)}"
            with_sql(query).first or super
          else
            super
          end
        end
      end

      # Get the {FriendlyId::Status} after the find has been performed.
      def friendly_id_status
        @friendly_id_status ||= Status.new :record => self
      end

      # Returns the friendly_id.
      def friendly_id
        send self.class.friendly_id_config.column
      end

      # Returns the friendly id, or if none is available, the numeric id.
      def to_param
        (friendly_id || id).to_s
      end

      def validate
        return if skip_friendly_id_validations
        column = friendly_id_config.column
        value = send(column)
        return errors.add(column, "can't be blank") if value.blank?
        return errors.add(column, "is reserved") if friendly_id_config.reserved?(value)
      end

      def before_update
        @old_friendly_id = HomeOwner[id].friendly_id
      end

      def after_update
        update_scopes
      end

      private

      # Update the slugs for any model that is using this model as its
      # FriendlyId scope.
      def update_scopes
        if @old_friendly_id != friendly_id
          friendly_id_config.child_scopes.each do |klass|
            Slug.filter(:sluggable_type => klass.to_s, :scope => @old_friendly_id).update(:scope => friendly_id)
          end
        end
      end

      def skip_friendly_id_validations
        friendly_id.nil? && self.class.friendly_id_config.allow_nil?
      end

      def friendly_id_config
        self.class.friendly_id_config
      end
    end
  end
end
