require File.dirname(__FILE__) + "/test_helper"

module FriendlyId
  module Test
    module SequelAdapter

      class CustomNormalizerTest < ::Test::Unit::TestCase

        include FriendlyId::Test::SequelAdapter::Core
        include FriendlyId::Test::SequelAdapter::Slugged
        include FriendlyId::Test::CustomNormalizer

        def klass
          Person
        end

      end
    end
  end
end
