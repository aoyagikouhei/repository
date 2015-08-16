require 'test_helper'

class KbnPropertiesControllerTest < ActionController::TestCase
  setup do
    @kbn_property = kbn_properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kbn_properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kbn_property" do
    assert_difference('KbnProperty.count') do
      post :create, kbn_property: {  }
    end

    assert_redirected_to kbn_property_path(assigns(:kbn_property))
  end

  test "should show kbn_property" do
    get :show, id: @kbn_property
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kbn_property
    assert_response :success
  end

  test "should update kbn_property" do
    patch :update, id: @kbn_property, kbn_property: {  }
    assert_redirected_to kbn_property_path(assigns(:kbn_property))
  end

  test "should destroy kbn_property" do
    assert_difference('KbnProperty.count', -1) do
      delete :destroy, id: @kbn_property
    end

    assert_redirected_to kbn_properties_path
  end
end
