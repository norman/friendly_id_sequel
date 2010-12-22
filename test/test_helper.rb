require "rubygems"
require "bundler"
Bundler.setup

require "sequel"
require "friendly_id"
require "friendly_id/test"
require "friendly_id_sequel"
require "logger"
require "test/unit"
require "mocha"

require File.expand_path("../core", __FILE__)
require File.expand_path("../simple", __FILE__)
require File.expand_path("../slugged", __FILE__)

DB = Sequel.sqlite
FriendlyId::SequelAdapter::CreateSlugs.apply(DB, :up)

require File.expand_path('../support/models', __FILE__)

DB.loggers << Logger.new($stdout) if ENV["LOG"]
