require 'test_helper'

class ErdsControllerTest < ActionController::TestCase
  setup do
    @erd = erds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:erds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create erd" do
    assert_difference('Erd.count') do
      post :create, erd: {  }
    end

    assert_redirected_to erd_path(assigns(:erd))
  end

  test "should show erd" do
    get :show, id: @erd
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @erd
    assert_response :success
  end

  test "should update erd" do
    patch :update, id: @erd, erd: {  }
    assert_redirected_to erd_path(assigns(:erd))
  end

  test "should destroy erd" do
    assert_difference('Erd.count', -1) do
      delete :destroy, id: @erd
    end

    assert_redirected_to erds_path
  end
end
