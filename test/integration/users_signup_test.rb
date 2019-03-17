require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid data should not be accepted" do
    get signup_path
    assert_select "form[action='/signup']"
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

  test "valid data should be accepted" do
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, params: {user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "foobar",
        password_confirmation: "foobar"
        }}
      follow_redirect!
      assert_template "users/show"
      assert flash.any?
    end
  end
end
