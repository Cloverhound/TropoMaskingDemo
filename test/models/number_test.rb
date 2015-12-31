require 'test_helper'

class NumberTest < ActiveSupport::TestCase
    setup do
        @number = numbers(:one) # references numbers fixture
    end


    test "extract_number_from_uri should extract number" do
        phone_number = @number.extract_number_from_uri("https://api.tropo.com/addresses/number/+123")
        assert_equal "+123", phone_number, "number was not properly extracted" 
    end

end
