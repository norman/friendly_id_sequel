require File.dirname(__FILE__) + "/test_helper"

module FriendlyId
  module Test
    module SequelAdapter

      # Tests for Sequel models using FriendlyId with slugs.
      class BasicSluggedTest < ::Test::Unit::TestCase
        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::SequelAdapter::Core
        include FriendlyId::Test::SequelAdapter::Slugged
      end
    end
  end
end
