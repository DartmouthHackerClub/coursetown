require 'test_helper'

class ReviewControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get course" do
    get :course
    assert_response :success
  end

  test "should get prof" do
    get :prof
    assert_response :success
  end

  test "should get course_prof" do
    get :course_prof
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

# TODO flesh out this test
  test "paths" do
    assert_routing "/reviews/prof/1", {:controller => :reviews, :action => :prof, :id => 1}
  end

end
