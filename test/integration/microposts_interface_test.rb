require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    log_in_as(@user)
  end

  test "micropost interface" do
    get root_url
    assert_select "div.pagination"
    #invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_url, params: {micropost: {content: " "}}
    end
    assert_select "div#error_explanation"
    #valid submission
    content = "Lorem ipsum"
    assert_difference "Micropost.count", 1 do
      post microposts_url, params: {micropost: {content: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    #delete post
    assert_select "a", text: "delete"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_url(first_micropost)
    end
    #visit different user
    get user_path(users(:example2))
    assert_select "a", text: "delete", count: 0
  end

  test "sidebar count" do
    get root_url
    assert_match "#{@user.microposts.count} microposts", response.body
  end
end
