require 'spec_helper'

describe Qualtrics::PanelImport, :vcr => true  do
  it 'has a panel id' do
    panel_id = Qualtrics::Panel.new

    panel_import = Qualtrics::PanelImport.new({
      panel_id: panel_id
    })
    expect(panel_import.panel_id).to eql(panel_id)
  end

  # it 'has a panel' do
  #   panel = Qualtrics::Panel.new
  #
  #   panel_import = Qualtrics::PanelImport.new({
  #     panel: panel
  #   })
  #   expect(panel_import.panel).to eql(panel)
  # end

  it 'has a list of recipients' do
    recipients = [Qualtrics::Recipient.new, Qualtrics::Recipient.new]

    panel_import = Qualtrics::PanelImport.new({
      recipients: recipients
    })
    expect(panel_import.recipients).to eql(recipients)
  end

  # it 'transmits to qualtrics' do
  #   panel = Qualtrics::Panel.new({
  #     name: 'Newest Panel',
  #     category: 'Great Category'
  #   })
  #
  #   recipients = [
  #     Qualtrics::Recipient.new(
  #       email: 'example@example.com',
  #       first_name: 'John',
  #       last_name: 'Smith'
  #     )
  #   ]
  #
  #   panel.save
  #
  #   panel_import = Qualtrics::PanelImport.new({
  #     recipients: recipients,
  #     panel_id: panel.id
  #   })
  #
  #   expect(panel_import.save).to be true
  # end


end
