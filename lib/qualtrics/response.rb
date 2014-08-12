require 'json'

module Qualtrics
	class Response

    def initialize(raw_response)
      @raw_response = raw_response
      if @raw_response.status != 200
        raise Qualtrics::ServerErrorEncountered
      end
    end

    def success?
      body['Meta'].nil? ? false : body['Meta']['Status'] == 'Success'
    end

    def result
      body['Result'].nil? ? {} : body['Result']
    end

    protected

    def body
      if @body.nil?
        if @raw_response.body == ''
          @body = {}
        else
          @body = JSON.parse(@raw_response.body)
        end
      end
      @body
    end
  end
end
