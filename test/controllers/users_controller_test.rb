require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @other_user = users(:example2)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should redirect edit if not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update if not logged in" do
    patch user_path(@user), params: {user: {name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user)
    patch user_path(@other_user), params: {user: {name: @other_user.name, email: @other_user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end
end
