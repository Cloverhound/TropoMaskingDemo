require 'test_helper'

class MasksControllerTest < ActionController::TestCase
  setup do
    @mask = masks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:masks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mask" do
    assert_difference('Mask.count') do
      post :create, mask: { number_id: @mask.number_id, phone_number: @mask.phone_number }
    end

    assert_redirected_to mask_path(assigns(:mask))
  end

  test "should show mask" do
    get :show, id: @mask
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mask
    assert_response :success
  end

  test "should update mask" do
    patch :update, id: @mask, mask: { number_id: @mask.number_id, phone_number: @mask.phone_number }
    assert_redirected_to mask_path(assigns(:mask))
  end

  test "should destroy mask" do
    assert_difference('Mask.count', -1) do
      delete :destroy, id: @mask
    end

    assert_redirected_to masks_path
  end
end
