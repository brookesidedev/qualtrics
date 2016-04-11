require 'spec_helper'

describe Qualtrics::PanelImport, :vcr => true  do
  it 'has a panel' do
    panel = Qualtrics::Panel.new

    panel_import = Qualtrics::PanelImport.new({
      panel: panel
    })
    expect(panel_import.panel).to eql(panel)
  end

  it 'has a list of recipients' do
    recipients = [Qualtrics::Recipient.new, Qualtrics::Recipient.new]

    panel_import = Qualtrics::PanelImport.new({
      recipients: recipients
    })
    expect(panel_import.recipients).to eql(recipients)
  end

  it 'transmits to qualtrics' do
    panel = Qualtrics::Panel.new({
      name: 'Newest Panel',
      category: 'Great Category'
    })

    recipients = [
      Qualtrics::Recipient.new(
        email: 'example@example.com',
        first_name: 'John',
        last_name: 'Smith'
      )
    ]

    panel_import = Qualtrics::PanelImport.new({
      recipients: recipients,
      panel: panel
    })

    expect(panel_import.save).to be true
  end

  it 'transmits to qualtrics' do
    panel = Qualtrics::Panel.new({
      name: 'Newest Panel',
      category: 'Great Category'
    })

    panel.save

    recipient = Qualtrics::Recipient.new(
      email: 'example@example.com',
      first_name: 'John',
      last_name: 'Smith',
      panel_id: panel.id,
      unsubscribed: '0',
      external_data: 'aok',
      language: 'EN'
    )

    recipient.save

    panel_import = Qualtrics::PanelImport.new({
      recipients: [recipient],
      panel: panel
    })

    expect(panel_import.update_panel).to be true
  end

end
