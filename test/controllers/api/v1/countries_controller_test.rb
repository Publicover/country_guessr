require "test_helper"

class Api::V1::CountriesControllerTest < ActionDispatch::IntegrationTest
  test 'should not get response without token' do 
    get api_v1_countries_guess_path, params: { name: 'Ba'}
    assert_response :unprocessable_entity
  end

  test 'should get country of origin' do 
    login_as_user 
    get api_v1_countries_guess_path, params: { name: 'Ba' }, headers: @user_headers
    assert_response :success 
    assert_equal json['guessed_country'], ['African']
    assert_equal json['requested_name'], 'Ba'
  end
end
