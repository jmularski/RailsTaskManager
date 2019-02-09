# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authentication::AuthenticationController do
  describe "#signup with" do
    before(:each) do
      bypass_rescue
    end
    subject { post :signup, params: {authentication: leader} }

    context "valid params" do
      let(:leader) { attributes_for(:user) }

      it { is_expected.to be_successful }
      it { check_for_token(subject.body) }
    end

    context "no email" do
      let(:leader) { attributes_for(:user, email: nil) }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "invalid email" do
      let(:leader) { attributes_for(:user, email: "bad_email") }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "no password" do
      let(:leader) { attributes_for(:user, password: nil) }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "account with that email already exists" do
      before { create(:user, email: "a@a.pl") }
      let(:leader) { attributes_for(:user, email: "a@a.pl") }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
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

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "wrong password" do
      before { post :signup, params: {authentication: {email: leader[:email], password: "a"}} }
      let(:leader) { attributes_for(:user) }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "no email" do
      before { post :signup, params: {authentication: {email: "a@a.pl", password: leader[:password]}} }

      let(:leader) { attributes_for(:user, email: nil) }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "no password" do
      before { post :signup, params: {authentication: {email: leader[:email], password: "hello_world"}} }

      let(:leader) { attributes_for(:user, password: nil) }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
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

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end

    context "wrong email" do
      let(:email) { "abcd" }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
    end
  end

  describe "#reset_password" do
    subject { post :reset_password, params: {authentication: data} }

    context "everything valid" do
      let(:leader) { create(:user) }
      let(:data) { {token: TokenUtils.encode({id: leader[:id]}, (Time.now.to_i + 3600).to_s), new_password: "abcd"} }

      it { is_expected.to be_successful }
      # write test for changing password
    end

    context "no token" do
      let(:data) { {token: nil, new_password: "abcd"} }

      it { expect { subject }.to raise_error(ExceptionHandler::DecodeError) }
    end

    context "invalid token" do
      let(:data) { {token: "abcd", new_password: "hello"} }

      it { expect { subject }.to raise_error(ExceptionHandler::DecodeError) }
    end

    context "expired token" do
      let(:leader) { create(:user) }
      let(:data) { {token: TokenUtils.encode({id: leader[:id]}, (Time.now.to_i - 5000).to_s), new_password: "abcd"} }

      it { expect { subject }.to raise_error(ExceptionHandler::ExpiredSignature) }
    end

    context "no password" do
      let(:leader) { create(:user) }
      let(:data) { {token: TokenUtils.encode({id: leader[:id]}, (Time.now.to_i + 3600).to_s), new_password: nil} }

      it { expect { subject }.to raise_error(ExceptionHandler::AuthenticationError) }
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
