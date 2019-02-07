# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject { create :user }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should_not allow_value("blah").for(:email) }
    it { should allow_value("a@b.com").for(:email) }
  end

  ## Figure out a way to add password test - some problems with BCrypt
end
