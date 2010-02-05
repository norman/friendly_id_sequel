require File.dirname(__FILE__) + "/test_helper"

module FriendlyId
  module Test
    module SequelAdapter

      module Simple

        def klass
          User
        end

        def other_class
          Book
        end

        def instance
          @instance ||= klass.send(create_method, :name => "hello world")
        end

      end
    end
  end
end
