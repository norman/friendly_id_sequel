require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test

    class ScopedModelTest < ::Test::Unit::TestCase

      include FriendlyId::Test::Generic
      include FriendlyId::Test::Slugged
      include FriendlyId::Test::SequelAdapter::Core
      include FriendlyId::Test::SequelAdapter::Slugged

      def setup
        @homeowner  = HomeOwner.create(:name => "john")
        @house      = House.create(:name => "123 Main", :home_owner => @homeowner)
        @usa        = Country.create(:name => "USA")
        @canada     = Country.create(:name => "Canada")
        @resident   = Resident.create(:name => "John Smith", :country => @usa)
        @resident2  = Resident.create(:name => "John Smith", :country => @canada)
        # @owner      = Company.create(:name => "Acme Events")
        # @site       = Site.create(:name => "Downtown Venue", :owner => @owner)
      end

      def teardown
        Post.delete
        City.delete
        FriendlyId::SequelAdapter::Slug.delete

        # Resident.all.destroy!
        # Country.all.destroy!
        # User.all.destroy!
        # House.all.destroy!
        # Slug.all.destroy!
      end

      test "a slugged model should auto-detect that it is being used as a parent scope" do
        assert_equal [Resident], Country.friendly_id_config.child_scopes
      end

      test "a child model should contain the scope of its parent" do
        assert_equal "usa", @resident.slugs.first.scope
      end

      test "a slugged model should update its child model's scopes when its friendly_id changes" do
        @usa.update(:name => "United States")
        assert_equal "united-states", @usa.friendly_id
        assert_equal "united-states", @resident.reload.slugs.first.scope
      end

      test "a non-slugged model should auto-detect that it is being used as a parent scope" do
        assert_equal [House], HomeOwner.friendly_id_config.child_scopes
      end

      test "should update the slug when the scope changes" do
        @resident.update :country => Country.create(:name => "Argentina")
        assert_equal "argentina", @resident.reload.slugs.first.scope
      end

      test "updating only the scope should not append sequence to friendly_id" do
        old_friendly_id = @resident.friendly_id
        @resident.update :country => Country.create(:name => "Argentina")
        assert_equal old_friendly_id, @resident.friendly_id
      end

      test "updating the scope should increment sequence to avoid conflicts" do
        old_friendly_id = @resident.friendly_id
        @resident.update :country => @canada
        assert_equal "#{old_friendly_id}--2", @resident.friendly_id
        assert_equal "canada", @resident.reload.slugs.first.scope
      end

      test "a non-slugged model should update its child model's scopes when its friendly_id changes" do
        @homeowner.update(:name => "jack")
        assert_equal "jack", @homeowner.friendly_id
        assert_equal "jack", @house.reload.slugs.first.scope
      end

      test "should should not show the scope in the friendly_id" do
        assert_equal "john-smith", @resident.friendly_id
        assert_equal "john-smith", @resident2.friendly_id
      end

#       test "should find a single scoped record with a scope as a string" do
#         assert Resident.get(@resident.friendly_id, :scope => @resident.country)
#       end
# 
#       test "should find a single scoped record with a scope" do
#         assert Resident.get(@resident.friendly_id, :scope => @resident.country)
#       end
# 
#       test "should raise an error when finding a single scoped record with no scope" do
#         assert_raises DataMapper::ObjectNotFoundError do
#           Resident.get!(@resident.friendly_id)
#         end
#       end
# 
#       test "should append scope error info when missing scope causes a find to fail" do
#         begin
#           Resident.get!(@resident.friendly_id)
#           fail "The find should not have succeeded"
#         rescue DataMapper::ObjectNotFoundError => e
#           assert_match(/scope expected/i, e.message)
#         end
#       end
# 
#       test "should append scope error info when the scope value causes a find to fail" do
#         begin
#           Resident.get!(@resident.friendly_id, :scope => "badscope")
#           fail "The find should not have succeeded"
#         rescue DataMapper::ObjectNotFoundError => e
#           assert_match(/scope \\"badscope\\"/, e.message)
#         end
#       end
# 
#       test "should update the sluggable field when a polymorphic relationship exists" do
#         @site.update(:name => "Uptown Venue")
#         assert_equal "Uptown Venue", @site.name
#       end
# 
    end
  end
end

