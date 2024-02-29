require "test_helper"

class NationalityTest < ActiveSupport::TestCase
  test 'should have columns' do 
    assert Nationality.column_names.include?('name')
  end 

  test 'should have unique index' do 
    name = nationalities(:one).name 
    new_nationality = Nationality.new(name: name)
    refute new_nationality.save
  end 

  test 'should validate name' do 
    new_nationality = Nationality.new()
    refute new_nationality.save
  end
end
