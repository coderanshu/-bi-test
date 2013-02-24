require 'test_helper'

class BodySystemsControllerTest < ActionController::TestCase
  setup do
    @body_system = body_systems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:body_systems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create body_system" do
    assert_difference('BodySystem.count') do
      post :create, body_system: { name: @body_system.name, order: @body_system.order }
    end

    assert_redirected_to body_system_path(assigns(:body_system))
  end

  test "should show body_system" do
    get :show, id: @body_system
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @body_system
    assert_response :success
  end

  test "should update body_system" do
    put :update, id: @body_system, body_system: { name: @body_system.name, order: @body_system.order }
    assert_redirected_to body_system_path(assigns(:body_system))
  end

  test "should destroy body_system" do
    assert_difference('BodySystem.count', -1) do
      delete :destroy, id: @body_system
    end

    assert_redirected_to body_systems_path
  end
end
