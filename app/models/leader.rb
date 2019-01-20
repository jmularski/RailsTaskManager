class Leader < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
