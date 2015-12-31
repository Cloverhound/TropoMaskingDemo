require 'test_helper'

class MasksControllerTest < ActionController::TestCase

    test "transfer should return proper json" do
        mask_number = "+11221122112"
        from_number = "+11111111111"
        to_number = masks(:one) # references masks fixture


        Mask.expects(:find_by).with(phone_number: mask_number).returns(to_number)  
        post :transfer, {session: {to: {id: mask_number}, from: {id: from_number} } }

        assert_response :success, "transferring call was unsuccessful"
        assert_equal '{"tropo":[{"transfer":{"to":"' + to_number.number.phone_number + '","from":"' + from_number + '"}}]}', response.body
    end

end
