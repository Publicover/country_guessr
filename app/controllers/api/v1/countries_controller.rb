# frozen_string_literal: true

class Api::V1::CountriesController < ApplicationController
  def guess
    start_time = Time.zone.now
    @echo = params['name']
    # find_by returns nil so we don't error out
    @guess = Surname.find_by(name: @echo)
    @guess_response = if @guess.nil?
                        'That is not in our database'
                      else
                        @guess.surname_nationalities.pluck(:nationality_name)
                      end
    total_time = Time.zone.now - start_time
    render status: :ok, json: {
      guessed_country: @guess_response,
      requested_name: @echo,
      time_processed: total_time
    }.to_json
  end
end
