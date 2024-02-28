require "test_helper"

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'jim@home.com', password: 'password', password_confirmation: 'password')
    @headers = valid_headers(@user.id).except('Authorization')
    @valid_creds = { email: @user.email, password: @user.password }.to_json
    @invalid_creds = { email: Faker::Internet.email, password: Faker::Internet.password }.to_json
  end

  test 'when request is valid' do
    post auth_login_path, headers: @headers, params: @valid_creds
    assert_not_nil json['auth_token']
  end

  test 'when request is invalid' do
    post auth_login_path, headers: @headers, params: @invalid_creds
    assert_match json['message'], Message.invalid_credentials
  end
end