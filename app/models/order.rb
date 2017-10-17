class Order < ApplicationRecord
    has_many :chopps , dependent: :destroy
    belongs_to :user
end
