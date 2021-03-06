# frozen_string_literal: true

require "factory_bot"

FactoryBot.factories.map(&:name).each do |factory_name|
  RSpec.describe "Factory #{factory_name}" do
    it "is valid" do
      expect(build(factory_name)).to be_valid
    end
  end
end
