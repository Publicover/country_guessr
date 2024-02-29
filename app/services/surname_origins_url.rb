# frozen_string_literal: true

class SurnameOriginsUrl
  def self.base_url
    'https://www.familyeducation.com/'
  end

  def self.surnames_url
    'baby-names/surname/origin'
  end

  def self.full_url
    "#{base_url}#{surnames_url}"
  end
end
