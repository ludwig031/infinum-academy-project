# frozen_string_literal: true

# WorldCup module creates namespace for events and matches
module WorldCup
  require 'httparty'
  attr_accessor :response

  include HTTParty
  base_uri 'https://worldcup.sfg.io/matches'

  def self.matches
    matches = []
    response_hash = get('', verify: false)
    response_hash.each do |match_hash|
      matches << Match.new(match_hash)
    end
    matches
  end

  def self.matches_on(query_date)
    matches = []
    response_hash = get("?start_date=#{query_date}", verify: false)
    response_hash.each do |match|
      matches << Match.new(match)
    end
    matches
  end
end
