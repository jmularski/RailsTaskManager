require "rails_helper"

RSpec.describe Leader::AuthenticationController do
  describe '#signup with' do

    context 'successful params' do
      let(:leader) { build(:leader) }
      subject { post :signup, :params => { authentication: attributes_for(:leader) } }

      it { is_expected.to be_successful}
      it 'returns JWT' do
        body = JSON.parse(subject.body)
        expect(body['token']).to be_present
      end 
    end

    context 'bad params - ' do
      
      context 'no email' do
      end
      
      context 'invalid email' do
      end

      context 'no password' do
      end
    
    end

  end

  describe '#signin' do
  end
end