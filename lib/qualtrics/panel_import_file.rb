require 'tempfile'
require 'csv'
require 'qualtrics/recipient_import_row'

module Qualtrics
  class PanelImportFile
    attr_reader :recipients

    def initialize(recipients)
      @recipients = recipients
    end

    def temp_file
      if @temp_file.nil?
        tmp_file = Tempfile.new('panel_import')
        temp_path = tmp_file.path
        tmp_file.close

        contents = @recipients.map do |recipient|
          Qualtrics::RecipientImportRow.new(recipient).field_map
        end.to_json

        File.open(temp_path, 'wb') do |file|
          file.write(contents)
        end

        @temp_file = temp_path
      end
      @temp_file
    end
  end
end
