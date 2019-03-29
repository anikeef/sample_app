require 'test_helper'

class ShowUserTest < ActionDispatch::IntegrationTest
  def setup
    @activated_user = users(:example)
    @unactivated_user = users(:lana)
  end

  test "show user" do
    get user_path(@activated_user)
    assert_template "users/show"
    assert_select "h1", @activated_user.name
    get user_path(@unactivated_user)
    assert_redirected_to root_url
  end
end
