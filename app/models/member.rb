class Member < ApplicationRecord
  belongs_to :project, dependent: :destroy
end
