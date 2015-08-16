require 'test_helper'

class ErrPropertiesControllerTest < ActionController::TestCase
  setup do
    @err_property = err_properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:err_properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create err_property" do
    assert_difference('ErrProperty.count') do
      post :create, err_property: {  }
    end

    assert_redirected_to err_property_path(assigns(:err_property))
  end

  test "should show err_property" do
    get :show, id: @err_property
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @err_property
    assert_response :success
  end

  test "should update err_property" do
    patch :update, id: @err_property, err_property: {  }
    assert_redirected_to err_property_path(assigns(:err_property))
  end

  test "should destroy err_property" do
    assert_difference('ErrProperty.count', -1) do
      delete :destroy, id: @err_property
    end

    assert_redirected_to err_properties_path
  end
end
