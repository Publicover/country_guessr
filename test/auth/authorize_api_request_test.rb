require 'test_helper'

class AuthorizeApiRequestTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @header = { 'Authorization' => token_generator(@user.id) }
    @request_object = AuthorizeApiRequest.new(@header)
  end

  test 'call with valid request' do
    result = @request_object.call
    assert_equal result[:user], @user
  end

  test 'call with invalid request missing token' do
    invalid_request_object = AuthorizeApiRequest.new({})
    assert_raises ExceptionHandler::MissingToken do
      invalid_request_object.call
    end
  end

  test 'call with invalid request invalid token' do
    invalid_request_object = AuthorizeApiRequest.new('Authorization' => token_generator(5))
    assert_raises ExceptionHandler::InvalidToken do
      invalid_request_object.call
    end
  end

  test 'call with expired token' do
    invalid_header = { 'Authorization' => expired_token_generator(@user.id) }
    assert_raises ExceptionHandler::InvalidToken do
      AuthorizeApiRequest.new(invalid_header).call
    end
  end

  test 'call with fake token' do
    invalid_header = { 'Authorization' => 'faketokenhere' }
    assert_raises ExceptionHandler::InvalidToken do
      AuthorizeApiRequest.new(invalid_header).call
    end
  end
end