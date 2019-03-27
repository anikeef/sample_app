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

  test "login with valid information followed by logout" do
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

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to :root

    #Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, false
    assert_select "a[href=?]", user_path(@user), false
  end

  test "login with remember" do
    log_in_as(@user, password: "password", remember_me: "1")
    assert_not_empty cookies[:remember_token]
  end

  test "login without remember" do
    #login with remember to create cookie
    log_in_as(@user, password: "password", remember_me: "1")
    #login without remember to delete cookie
    log_in_as(@user, password: "password", remember_me: "0")
    assert_empty cookies[:remember_token]
  end
end
