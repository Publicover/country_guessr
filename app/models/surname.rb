# frozen_string_literal: true

class Surname < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
