# frozen_string_literal: true

class Nationality < ApplicationRecord
  has_many :surname_nationalities, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
