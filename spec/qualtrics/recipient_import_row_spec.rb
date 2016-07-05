require 'spec_helper'

describe Qualtrics::RecipientImportRow do
  let(:email) { 'fake@fake.com' }
  let(:first_name) { 'Johnny' }
  let(:last_name) { 'Fakesalot' }
  let(:external_data) { '1234' }
  let(:embedded_data) { '4567' }
  let(:unsubscribed) { 0 }
  let(:language) { 'EN' }
  let(:recipient) do
    Qualtrics::Recipient.new({
      email: email,
      first_name: first_name,
      last_name: last_name,
      external_data: external_data,
      unsubscribed: unsubscribed,
      language: language
    })
  end
  let(:recipient_row) do
    Qualtrics::RecipientImportRow.new(recipient)
  end

  it 'has a recipient' do
    expect(recipient_row.recipient).to eql(recipient)
  end

  def index(field)
    Qualtrics::RecipientImportRow.fields.index(field)
  end

end