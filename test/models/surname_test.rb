require "test_helper"

class SurnameTest < ActiveSupport::TestCase
  test 'should have columns' do 
    assert Surname.column_names.include?('name')
  end 

  test 'should have unique index' do 
    surname = surnames(:one).name 
    new_surname = Surname.new(name: surname)
    refute new_surname.save
  end

  test 'should validate name' do 
    new_surname = Surname.new()
    refute new_surname.save
  end

  test 'should know child surname_nationality' do 
    assert surnames(:one).surname_nationalities.include?(surname_nationalities(:one))
  end 
end
