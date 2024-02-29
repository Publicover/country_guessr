# frozen_string_literal: true

class Surname < ApplicationRecord
  has_many :surname_nationalities, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
