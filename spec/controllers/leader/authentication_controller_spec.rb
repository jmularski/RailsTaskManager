# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authentication::AuthenticationController do
  describe "#signup with" do
    subject { post :signup, params: {authentication: leader} }

    context "valid params" do
      let(:leader) { attributes_for(:user) }

      it { is_expected.to be_successful }
      it { check_for_token(subject.body) }
    end

    context "no email" do
      let(:leader) { attributes_for(:user, email: nil) }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    context "invalid email" do
      let(:leader) { attributes_for(:user, email: "bad_email") }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    context "no password" do
      let(:leader) { attributes_for(:user, password: nil) }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    context "account with that email already exists" do
      before { create(:user, email: "a@a.pl") }
      let(:leader) { attributes_for(:user, email: "a@a.pl") }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end
  end

  describe "#signin with" do
    subject { post :signin, params: {authentication: leader} }

    context "valid params" do
      before { post :signup, params: {authentication: leader} }

      let(:leader) { attributes_for(:user) }

      it { is_expected.to be_successful }
      it { check_for_token(subject.body) }
    end

    context "email without signup" do
      let(:leader) { attributes_for(:user) }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    context "wrong password" do
      before { post :signup, params: {authentication: {email: leader[:email], password: "a"}} }
      let(:leader) { attributes_for(:user) }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    ## FIX IT, WRONG TESTS
    context "no email" do
      before { post :signup, params: {authentication: {email: "a@a.pl", password: leader[:password]}} }

      let(:leader) { attributes_for(:user, email: nil) }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    context "no password" do
      before { post :signup, params: {authentication: {email: leader[:email], password: "hello_world"}} }

      let(:leader) { attributes_for(:user, password: nil) }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end
  end

  describe "#send_reset_password" do
    subject { post :send_reset_password, params: {authentication: {email: email}} }

    context "everything valid" do
      before { post :signup, params: {authentication: leader} }
      let(:leader) { attributes_for(:user, email: "example@example.com") }
      let(:email) { leader[:email] }

      it { is_expected.to be_successful }
      it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    end

    context "no email" do
      let(:email) { nil }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end

    context "wrong email" do
      let(:email) { "abcd" }

      it { is_expected.to be_unauthorized }
      it { check_for_error(subject.body) }
    end
  end
end

def check_for_error(body)
  body = JSON.parse(body)
  expect(body["error"]).to be_present
end

def check_for_token(body)
  body = JSON.parse(body)
  expect(body["token"]).to be_present
end
