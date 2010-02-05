require File.dirname(__FILE__) + "/test_helper"

module FriendlyId
  module Test
    module SequelAdapter

      class StiTest < ::Test::Unit::TestCase

        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::SequelAdapter::Core
        include FriendlyId::Test::SequelAdapter::Slugged

        def klass
          Cat
        end

      end
    end
  end
end
