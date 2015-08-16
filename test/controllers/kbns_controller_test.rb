require 'test_helper'

class KbnsControllerTest < ActionController::TestCase
  setup do
    @kbn = kbns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kbns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kbn" do
    assert_difference('Kbn.count') do
      post :create, kbn: {  }
    end

    assert_redirected_to kbn_path(assigns(:kbn))
  end

  test "should show kbn" do
    get :show, id: @kbn
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kbn
    assert_response :success
  end

  test "should update kbn" do
    patch :update, id: @kbn, kbn: {  }
    assert_redirected_to kbn_path(assigns(:kbn))
  end

  test "should destroy kbn" do
    assert_difference('Kbn.count', -1) do
      delete :destroy, id: @kbn
    end

    assert_redirected_to kbns_path
  end
end
