require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end

  test "edit with invalid data" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path, params: {user: {
      name: "",
      email: "foo@bar",
      password: "qwerty",
      password_confirmation: "qwertyyy"
    }}
    assert_template "users/edit"
    assert_select "#error_explanation li", count: 3
  end

  test "edit with valid data" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = "New User"
    email = "new@email.com"
    patch user_path(@user), params: {user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
    }}
    assert_redirected_to user_path(@user)
    assert_not_empty flash[:success]
    follow_redirect!
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
