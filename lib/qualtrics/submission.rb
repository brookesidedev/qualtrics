module Qualtrics
  class Submission < Entity

    attr_accessor :id, :survey_id, :distribution_id, :finished_survey, :time_stamp,
                  :result, :type, :read, :session_id

    def initialize(options={})
      @id = options[:id]
      @survey_id = options[:survey_id]
      @distribution_id = options[:distribution_id]
      @finished_survey = options[:finished_survey]
      @time_stamp = options[:time_stamp]
      @result = options[:result]
      @type = options[:type]
      @read = options[:read]
      @session_id = options[:session_id]
    end

    def raw_csv
      response = get('getLegacyResponseData', {
        'SurveyID' => survey_id,
        'ResponseID' => id,
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
        'ResponseID' => :id,
        'SurveyID' => :survey_id,
        'TimeStamp' => :time_stamp,
        'EmailDistributionID' => :distribution_id,
        'FinishedSurvey' => :finished_survey
      }
    end

    def self.email_map
      {
        'EmailDistributionID' => :distribution_id,
        'Type' => :type,
        'Date' => :time_stamp,
        'Result' => :result,
        'SurveyID' => :survey_id,
        'SessionID' => :session_id,
        'Read' => :read
      }
    end
  end
end