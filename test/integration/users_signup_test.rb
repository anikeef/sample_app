require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_select "form[action='/users']"
    assert_no_difference "User.count" do
      post signup_path, params: {user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
        }}
    end
    assert_template "users/new"
    assert_select "div.field_with_errors"
    assert_select "div#error_explanation"
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, params: {user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "foobar",
        password_confirmation: "foobar"
      }}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    #Invalid activation link
    get edit_account_activation_path("Invalid", email: user.email)
    assert_not is_logged_in?
    #Invalid email
    get edit_account_activation_path(user.activation_token, email: "ivalid@email.com")
    assert_not is_logged_in?
    #Valid activation
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert is_logged_in?
    assert user.reload.activated?
    assert flash.any?
    follow_redirect!
    assert_template "users/show"
  end
end
