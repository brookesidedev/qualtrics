module Qualtrics
  class RecipientImportRow
    attr_reader :recipient

    def initialize(recipient)
      @recipient = recipient
    end

    def to_a
      # self.class.fields.map do |field|
      #   field_map[field]
      # end.concat(sorted_embedded_data.values)
      field_map.values
    end

    def sorted_embedded_data
      if recipient.embedded_data
        recipient.embedded_data.sort_by{ |k, v| k }.to_h
      else
        {}
      end
    end

    def field_map
      {
        'FirstName'    => recipient.first_name,
        'LastName'     => recipient.last_name,
        'Email'         => recipient.email,
        'ExternalRef' => recipient.external_data,
        'Unsubscribed'  => recipient.unsubscribed,
        'Language'      => recipient.language,
        'RecipientID'      => recipient.id
      }.merge(sorted_embedded_data)
    end

    class << self
      def fields
        [
          'FirstName',
          'LastName',
          'Email',
          'ExternalRef',
          'Unsubscribed',
          'Language',
          'RecipientID'
        ]
      end
    end
  end
end
