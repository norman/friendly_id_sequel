module FriendlyId
  module SequelAdapter

    module SluggedModel

      include FriendlyId::Slugged::Model

      def self.included(base)
        base.one_to_many :slugs,
          :class => slug_class,
          :key => "sluggable_id",
          :conditions => {:sluggable_type => "#{base.to_s}"},
          :order => "id DESC"
        def base.[](*args)
          if args.size == 1
            return super if args.first.unfriendly_id?
            name, sequence = args.first.to_s.parse_friendly_id
            join_conditions = [:slugs, {:sluggable_id => :id, :sluggable_type => self.to_s}]
            conditions = {:name.qualify("slugs") => name, :sequence.qualify("slugs") => sequence}
            cols = columns.map {|c| c.qualify(table_name)}
            result = join(*join_conditions).select(*cols).where(conditions).first
            return super unless result
            result.friendly_id_status.name = name
            result.friendly_id_status.sequence = sequence
            result
          else
            super
          end
        end
      end

      def self.slug_class
        FriendlyId::SequelAdapter::Slug
      end

      def slug
        @slug ||= slugs(true).first
      end

      def find_slug(name, sequence)
        slugs_dataset.where("slugs.name".lit => name, "slugs.sequence".lit => sequence).first
      end

      private

      def after_save
        return if friendly_id_config.allow_nil? && !@slug
        @slug.sluggable_id = id
        @slug.save
      end

      def build_slug
        self.slug = SluggedModel.slug_class.new :name => slug_text,
          :sluggable_type => self.class.to_s
      end

      def skip_friendly_id_validations
        friendly_id.nil? && friendly_id_config.allow_nil?
      end

      def validate
        build_slug if new_slug_needed?
        method = friendly_id_config.method
      rescue FriendlyId::BlankError
        errors.add(method, "can't be blank")
      rescue FriendlyId::ReservedError
        errors.add(method, "is reserved")
      end

      super
    end
  end
end
