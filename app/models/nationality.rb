# frozen_string_literal: true

class Nationality < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
