require "rails_helper"

RSpec.describe Leader::AuthenticationController do
  describe '#signup with' do
  
    subject { post :signup, :params => { authentication: leader } }

    context 'valid params' do
      let(:leader) { attributes_for(:leader) }

      it { is_expected.to be_successful}
      it 'returns JWT' do
        body = JSON.parse(subject.body)
        expect(body['token']).to be_present
      end 
    end

    context 'no email' do
      let(:leader) { attributes_for(:leader, email: nil) }
      
      it { is_expected.to be_unauthorized}
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end
      
    context 'invalid email' do
      let(:leader) { attributes_for(:leader, email: 'bad_email') }
      
      it { is_expected.to be_unauthorized}
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end

    context 'no password' do
      let(:leader) { attributes_for(:leader, password: nil) }
      
      it { is_expected.to be_unauthorized}
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end
    
    context 'account with that email already exists' do
      before { create(:leader, email: 'a@a.pl') }
      let(:leader) { attributes_for(:leader, email: 'a@a.pl') }

      it { is_expected.to be_unauthorized}
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end

  end

  describe '#signin with' do

    subject { post :signin, :params => { authentication: leader } }
    
    context 'valid params' do
      before  { post :signup, :params => { authentication: leader } }

      let(:leader) { attributes_for(:leader) }

      it { is_expected.to be_successful }
      it 'returns JWT' do
        body = JSON.parse(subject.body)
        expect(body['token']).to be_present
      end
    end

    context 'email without signup' do
      let(:leader) { attributes_for(:leader) }

      it { is_expected.to be_unauthorized }
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end

    context 'wrong password' do
      before  { post :signup, :params => { authentication: { email: leader[:email], password: 'a' } } }
      let(:leader) { attributes_for(:leader) }

      it { is_expected.to be_unauthorized }
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end

    context 'no email' do
      before  { post :signup, :params => { authentication: leader } }

      let(:leader) { attributes_for(:leader, email: nil) }

      it { is_expected.to be_unauthorized }
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end

    context 'no password' do
      before  { post :signup, :params => { authentication: leader } }

      let(:leader) { attributes_for(:leader, email: nil) }

      it { is_expected.to be_unauthorized }
      it 'returns error' do
        body = JSON.parse(subject.body)
        expect(body['error']).to be_present
      end
    end

  end
end