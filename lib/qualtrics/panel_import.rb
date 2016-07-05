require "qualtrics/panel_import_file"

module Qualtrics
  class PanelImport < Entity
    attr_accessor :panel_id, :recipients, :id

    def initialize(options={})
      @id = options[:id]
      @panel_id = options[:panel_id]
      @recipients = options[:recipients]
    end

    def save
      #### using api v3, v2 does not work
      file = Qualtrics::PanelImportFile.new(recipients)
      payload = {}
      payload['contacts'] = Faraday::UploadIO.new(file.temp_file, 'application/json')

      raw_resp = connection.post(contact_import_path, payload) do |req|
        req.headers['X-API-TOKEN'] = configuration.token
      end

      response = Qualtrics::Response.new(raw_resp)
      if response.status == 200
        self.id = response.send(:body)['result']['id']

        check_import_status
      else
        false
      end
    end

    def check_import_status(looped_times = 0)
      if self.id && looped_times <= 6
        raw_resp = connection.get([contact_import_path, '/', self.id].join('')) do |req|
          req.headers['X-API-TOKEN'] = configuration.token
        end

        response = Qualtrics::Response.new(raw_resp)
        if response.send(:body)['result']['percentComplete'].to_i == 100
          true
        else
          sleep 10
          check_import_status(looped_times + 1)
        end if response.status == 200
      else
        false
      end
    end

    def contact_import_path
      "/API/v3/mailinglists/#{panel_id}/contactimports"
    end

    private

    def connection
      @connection ||= Faraday.new(url: 'https://co1.qualtrics.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded
        # faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.use ::FaradayMiddleware::FollowRedirects, limit: 3
        faraday.adapter :net_http
      end
    end
  end
end
