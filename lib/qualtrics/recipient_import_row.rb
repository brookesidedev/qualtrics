module Qualtrics
  class RecipientImportRow
    attr_reader :recipient

    def initialize(recipient)
      @recipient = recipient
    end

    def field_map
      {
          'id'                => recipient.id,
          'firstName'         => recipient.first_name,
          'lastName'          => recipient.last_name,
          'email'             => recipient.email,
          'embeddedData'      => recipient.embedded_data,
          'externalReference' => recipient.external_data,
          'unsubscribed'      => recipient.unsubscribed,
          'language'          => recipient.language
      }
    end
  end
end
