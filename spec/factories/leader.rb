FactoryBot.define do
  factory :leader, class: 'Leader' do
    email {Faker::Internet.email}
    password {Faker::Internet.password}
  end
end