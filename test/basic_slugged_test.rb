require File.expand_path("../test_helper", __FILE__)

module FriendlyId
  module Test
    module SequelAdapter

      # Tests for Sequel models using FriendlyId with slugs.
      class BasicSluggedTest < ::Test::Unit::TestCase
        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::SequelAdapter::Core
        include FriendlyId::Test::SequelAdapter::Slugged

         test "instances should be findable by a hash of options" do
          instance = klass.send(create_method, :name => "206")
          assert_equal instance, klass.send(find_method, {:name => "206"})
        end
      end
    end
  end
end
