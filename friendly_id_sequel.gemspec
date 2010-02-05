require "lib/friendly_id/sequel_adapter/version"

spec = Gem::Specification.new do |s|
  s.name              = "friendly_id_sequel"
  s.rubyforge_project = "friendly_id_sequel"
  s.version           = FriendlyId::SequelAdapter::Version::STRING
  s.authors           = "Norman Clarke"
  s.email             = "norman@njclarke.com"
  s.homepage          = "http://norman.github.com/friendly_id_sequel"
  s.summary           = "A Sequel adapter for FriendlyId"
  s.description       = "An adapter for using Sequel::Model with FriendlyId."
  s.has_rdoc          = true
  s.test_files        = Dir.glob "test/**/*_test.rb"
  s.files             = Dir["lib/**/*.rb", "lib/**/*.rake", "*.md", "LICENSE", "Rakefile", "test/**/*.*"]
  s.add_dependency    "friendly_id", "~> 2.3"
  s.add_dependency    "sequel", ">= 3.8.0"
end
