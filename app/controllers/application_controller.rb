# frozen_string_literal: true

# ApplicationController class inherits a constructor from ActionController::Base
class ApplicationController < ActionController::Base
  def validate_date(string)
    string.match(/\d{4}-\d{2}-\d{2}/)
  end

  def matches
    query = request.query_parameters
    date = query['date']
    date = Date.parse(date).strftime('%Y-%m-%d')
    output = if date && validate_date(date)
               WorldCup.matches_on(date)
             else
               WorldCup.matches
             end
    render json: output.as_json
  end
end
