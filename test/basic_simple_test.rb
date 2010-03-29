require File.dirname(__FILE__) + "/test_helper"

module FriendlyId
  module Test
    module SequelAdapter

      # Tests for Sequel models using FriendlyId without slugs.
      class BasicSimpleTest < ::Test::Unit::TestCase
        include FriendlyId::Test::Generic
        include FriendlyId::Test::Simple
        include FriendlyId::Test::SequelAdapter::Core
        include FriendlyId::Test::SequelAdapter::Simple
      end
    end
  end
end
