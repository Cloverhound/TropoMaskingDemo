class Mask < ActiveRecord::Base
    belongs_to :number


    before_destroy do
    
        puts 'deleting mask: ' + phone_number

        user = ENV['TROPO_USERNAME']
        pass = ENV['TROPO_PASSWORD']
        app_id = ENV['TROPO_MASKING_APP_ID'] 

        uri = URI.parse("https://api.tropo.com/v1/applications/#{app_id}/addresses/number/#{phone_number}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")

        request = Net::HTTP::Delete.new(uri.request_uri)
        request.basic_auth(user, pass)

        response = http.request(request)
        if response.code != '200'
            if response.code == '404'
                puts 'Warning: mask ' + phone_number + ' was not found in Tropo'
            else
                raise 'Unable to delete mask ' + phone_number + ' from tropo: ' + response.message
            end
        end
    end

end
