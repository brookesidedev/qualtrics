require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Survey < Entity
    attr_accessor :responses, :id, :survey_name,
                  :survey_owner_id, :survey_status, :survey_start_date,
                  :survey_expiration_date, :survey_creation_date,
                  :creator_id, :last_modified, :last_activated,
                  :user_first_name, :user_last_name

    def initialize(options={})
      @responses = options[:responses]
      @id = options[:id]
      @survey_name = options[:survey_name]
      @survey_owner_id = options[:survey_owner_id]
      @survey_status = options[:survey_status]
      @survey_start_date = options[:survey_start_date]
      @survey_expiration_date = options[:survey_expiration_date]
      @survey_creation_date = options[:survey_creation_date]
      @creator_id = options[:creator_id]
      @last_modified = options[:last_modified]
      @last_activated = options[:last_activated]
      @user_first_name = options[:user_first_name]
      @user_last_name = options[:user_last_name]
    end

    def self.all(library_id = nil)
      lib_id = library_id || configuration.default_library_id
      response = get('getSurveys', {'LibraryID' => lib_id})
      if response.success?
        response.result['Surveys'].map do |survey|
          new(underscore_attributes(survey))
        end
      else
        []
      end
    end

    def self.get_survey(id)
      response = get('getSurveyName', {
        'SurveyID' => id
      })

      if response.status == 200
        response.result
      else
        false
      end
    end

    def retrieve_all_raw_responses(start_date, end_date)
      response = get('getLegacyResponseData', {
        'SurveyID' => id,
        'StartDate' => formatted_time(start_date),
        'EndDate' => formatted_time(end_date),
        'Format' => 'CSV',
        'ExportTags' => 1
      })

      if response.status == 200
        response.result
      else
        false
      end
    end

    def self.attribute_map
      {
        'responses' => :responses,
        'SurveyID' => :id,
        'SurveyName' => :survey_name,
        'SurveyOwnerID' => :survey_owner_id,
        'SurveyStatus' => :survey_status,
        'SurveyStartDate' => :survey_start_date,
        'SurveyExpirationDate' => :survey_expiration_date,
        'SurveyCreationDate' => :survey_creation_date,
        'CreatorID' => :creator_id,
        'LastModified' => :last_modified,
        'LastActivated' => :last_activated,
        'UserFirstName' => :user_first_name,
        'UserLastName' => :user_last_name
      }
    end

    def destroy
      response = post('deleteSurvey', {
        'SurveyID' => id
      })
      response.success?
    end

    def activate
      response = post('activateSurvey', {
        'SurveyID' => id
      })
      response.success?
    end

    def deactivate
      response = post('deactivateSurvey', {
        'SurveyID' => id
      })
      response.success?
    end
  end
end
