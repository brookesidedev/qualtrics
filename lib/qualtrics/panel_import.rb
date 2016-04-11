require "qualtrics/panel_import_file"

module Qualtrics
  class PanelImport < Entity
    attr_accessor :panel, :recipients

    def initialize(options={})
      @panel = options[:panel]
      @recipients = options[:recipients]
      @embedded_data_columns = options[:embedded_data_columns]
    end

    def save
      payload = set_headers
      payload.delete('RecipientID')

      @file = Qualtrics::PanelImportFile.new(@recipients)
      post 'importPanel', payload, File.read(@file.temp_file)
      true
    end

    def update_panel
      payload = set_headers
      payload['PanelID'] = @panel.id

      @file = Qualtrics::PanelImportFile.new(@recipients, @panel.id)
      post 'importPanel', payload, File.read(@file.temp_file)
      true
    end

    def set_headers
      payload = headers
      payload['LibraryID'] = library_id
      payload['ColumnHeaders'] = 1
      payload[:content_type] = 'multipart/formdata'

      if @embedded_data_columns.to_i > 0
        payload['EmbeddedData'] = ((headers.length + 1).. (headers.length + @embedded_data_columns.to_i)).to_a.join(',')
      end

      payload
    end

    def headers
      {}.tap do |import_headers|
        Qualtrics::RecipientImportRow.fields.each_with_index.map do |field, index|
          import_headers[field] = index + 1
        end
      end
    end
  end
end
