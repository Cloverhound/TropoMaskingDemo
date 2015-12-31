require 'test_helper'

class NumbersControllerTest < ActionController::TestCase

  setup do
    @number = numbers(:one) # references numbers fixture
  end


  test "mask_number should reject invalid phone_number input" do
    invalid_number = "84720727"

    post :mask_number, :format => :json, number: invalid_number

    assert_response :error, "generate mask succeeded for an invalid phone number" 
  end


  test "mask_number should create number for phone_number input and call method generate_mask" do

    valid_number = @number.phone_number
    fake_mask = "+12121212121"

    Number.any_instance.expects(:generate_mask).returns(fake_mask)
    Phonelib.expects(:invalid?).returns(false)

    post :mask_number, :format => :json, number: valid_number

    generated_mask = JSON.parse(response.body)["message"]

    assert_response :success, "generating mask was unsuccesful"
    assert_equal fake_mask, generated_mask, "nil mask was returned"

  end 
end
