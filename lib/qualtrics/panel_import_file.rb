require 'tempfile'
require 'csv'
require 'qualtrics/recipient_import_row'

module Qualtrics
  class PanelImportFile
    attr_reader :recipients, :panel_id

    def initialize(recipients, panel_id = nil)
      @recipients = recipients
      @panel_id = panel_id
    end

    def temp_file
      if @temp_file.nil?
        tmp_file = Tempfile.new('panel_import')
        csv_path = tmp_file.path
        tmp_file.close
        CSV.open(csv_path, 'wb', :force_quotes => true, :write_headers => true, :headers => headers) do |csv|
          @recipients.each do |recipient|
            csv << Qualtrics::RecipientImportRow.new(recipient).to_a
          end
        end
        @temp_file = csv_path
      end
      @temp_file
    end

    def headers
      keys = Qualtrics::RecipientImportRow.new(@recipients.first).field_map.keys
      if @panel_id
        keys
      else
        keys.delete_at(6)
        keys
      end
    end
  end
end
