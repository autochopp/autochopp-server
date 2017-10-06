class Order < ApplicationRecord
    has_many :chopps
    belongs_to :user
end
