require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Panel < Entity
    attr_accessor :id, :name, :category

    def self.all(library_id = nil)
      lib_id = library_id || configuration.default_library_id
      response = get('getPanels', {'LibraryID' => lib_id})
      if response.success?
        response.result['Panels'].map do |panel|
          new(underscore_attributes(panel))
        end
      else
        []
      end
    end

    def self.find_by_name(name)
      self.all.select {|panel| panel.name == name}.first
    end

    def self.attribute_map
      {
        'LibraryID' => :library_id,
        'Category' => :category,
        'Name' => :name,
        'PanelID' => :id
      }
    end

    def initialize(options={})
      @name = options[:name]
      @id = options[:id]
      @category = options[:category]
      @library_id = options[:library_id]
    end

    def save
      response = nil
      if persisted?
        raise Qualtrics::UpdateNotAllowed
      else
        response = post('createPanel', attributes)
      end

      if response.success?
        self.id = response.result['PanelID']
        true
      else
        false
      end
    end

    def add_recipients(recipients)
      panel_import = Qualtrics::PanelImport.new({
          panel: self,
          recipients: recipients
      })
      panel_import.save
    end

    def members(library_id = nil)
      return @members if @members.present?

      @members = Array.new
      lib_id = library_id || configuration.default_library_id
      response = get('getPanel', {'PanelID' => self.id, 'LibraryID' => lib_id})

      response.body.each do |m|
        options = {}
        options[:id] = m["RecipientID"]
        options[:panel_id] = m[self.id]
        options[:email] = m["Email"]
        options[:first_name] = m['FirstName']
        options[:last_name] = m['LastName']
        options[:external_data] = m['ExternalDataReference']
        options[:embedded_data] = m['EmbeddedData']
        options[:unsubscribed] = m['Unsubscribed']

        @members << Qualtrics::Recipient.new(options)
      end

      @members
    end

    def destroy
      response = post('deletePanel', {
        'LibraryID' => library_id,
        'PanelID' => self.id
        })
      response.success?
    end

    def attributes
      {
        'LibraryID' => library_id,
        'Category' => category,
        'Name' => name
      }
    end
  end
end
