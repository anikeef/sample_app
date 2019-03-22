require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end

  test "invalid login information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {
      email: "nonexistent@user.com",
      password: "foobar"
    }}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: {session: {
      email: @user.email,
      password: "password"
    }}
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, false
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
