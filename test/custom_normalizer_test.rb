require File.expand_path("../test_helper", __FILE__)

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
