require 'test_helper'

class ErrsControllerTest < ActionController::TestCase
  setup do
    @err = errs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:errs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create err" do
    assert_difference('Err.count') do
      post :create, err: {  }
    end

    assert_redirected_to err_path(assigns(:err))
  end

  test "should show err" do
    get :show, id: @err
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @err
    assert_response :success
  end

  test "should update err" do
    patch :update, id: @err, err: {  }
    assert_redirected_to err_path(assigns(:err))
  end

  test "should destroy err" do
    assert_difference('Err.count', -1) do
      delete :destroy, id: @err
    end

    assert_redirected_to errs_path
  end
end
