module FriendlyId
  module SequelAdapter
    class Slug < ::Sequel::Model

      def to_friendly_id
        sequence.to_i > 1 ? friendly_id_with_sequence : name
      end

      # Whether this slug is the most recent of its owner's slugs.
      def current?
        sluggable.slug == self
      end

      private

      def sluggable
        sluggable_type.constantize[sluggable_id]
      end

      def before_create
        self.sequence = next_sequence
        self.created_at = Time.now
      end

      def enable_name_reversion
        conditions = { :sluggable_id => sluggable_id, :sluggable_type => sluggable_type,
            :name => name, :scope => scope }
        self.class.filter(conditions).delete
      end

      def friendly_id_with_sequence
        "#{name}#{separator}#{sequence}"
      end

      def next_sequence
        enable_name_reversion
        conditions =  { :name => name, :scope => scope, :sluggable_type => sluggable_type }
        prev = self.class.filter(conditions).order(:sequence.desc).first
        prev ? prev.sequence.succ : 1
      end

      def separator
        sluggable_type.constantize.friendly_id_config.sequence_separator
      end

      def validate
        errors.add(:name, "can't be blank") if name.blank?
      end
    end
  end
end
