require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'should have columns' do
    assert User.column_names.include?('email')
    assert User.column_names.include?('password_digest')
  end

  test 'should have unique index' do 
    email = users(:one).email 
    new_user = User.new(email: email, password: 'password')
    refute new_user.save
  end

  test 'should validate email' do 
    new_user = User.new(password: 'password')
    refute new_user.save
  end 

  test 'should validate password' do 
    new_user = User.new(email: Faker::Internet.email)
    refute new_user.save
  end
end