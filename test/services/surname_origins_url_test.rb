# frozen_string_literal: true 

require 'test_helper'

class SurnameOriginsUrlTest < ActiveSupport::TestCase
  test 'should have base url' do 
    assert_equal SurnameOriginsUrl.base_url, 'https://www.familyeducation.com/'
  end 

  test 'should have surnames url' do 
    assert_equal SurnameOriginsUrl.surnames_url, 'baby-names/surname/origin'
  end 

  test 'should have full url' do 
    assert_equal SurnameOriginsUrl.full_url, 'https://www.familyeducation.com/baby-names/surname/origin'
  end
end