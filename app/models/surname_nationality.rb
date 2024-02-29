# frozen_string_literal: true

class SurnameNationality < ApplicationRecord
  belongs_to :surname
  belongs_to :nationality

  validates :surname_name, :nationality_name, presence: true
  validate :unique_names

  def unique_names
    return if SurnameNationality.where(surname_id: surname_id, nationality_id: nationality_id).empty?

    raise StandardError.new, Message.duplicate_record
  end
end
