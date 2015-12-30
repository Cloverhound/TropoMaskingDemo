class Number < ActiveRecord::Base
    has_many :masks, dependent: :destroy 
    validates :phone_number, phone: true
    validates :phone_number, format: { with: /\+.*/, message: "Must be in international format" }


    @@user = ENV['TROPO_USERNAME']
    @@pass = ENV['TROPO_PASSWORD']
    @@mask_app_id = ENV['TROPO_MASKING_APP_ID']


    def generate_mask
        puts 'generating mask for ' + phone_number

        uri = URI.parse("https://api.tropo.com/v1/applications/#{@@mask_app_id}/addresses")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")

        request = Net::HTTP::Post.new(uri.request_uri)
        request.basic_auth(@@user, @@pass)
        request.set_form_data({type: 'number', prefix: get_area_code()})

        response = http.request(request)

        if response.code === '200'
            response_uri = JSON.parse(response.body)['href']
            return extract_number_from_uri(response_uri)
        else
          puts 'generating mask with prefix ' + get_area_code() + ' failed with http ' + response.code + ' and message: ' + response.body
          return generate_random_mask

        end
    end

    
    def generate_random_mask
        puts 'generating random mask for ' + phone_number

        uri = URI.parse("https://api.tropo.com/v1/applications/#{@@mask_app_id}/addresses")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")

        request = Net::HTTP::Post.new(uri.request_uri)
        request.basic_auth(@@user, @@pass)

        request.set_form_data({type: 'number', prefix: '1'})
        response = http.request(request)
        if response.code === '200'
            response_uri = JSON.parse(response.body)['href']
            return extract_number_from_uri(response_uri)
        else
            puts 'generating mask without prefix failed with http ' + response.code + 'and message: ' + response.body

            return nil
        end
    end


    def get_area_code
        return phone_number[1...5]
    end


    def extract_number_from_uri(uri)
        index_of_plus = uri.index('+')
        return uri[index_of_plus..-1]
    end
end
