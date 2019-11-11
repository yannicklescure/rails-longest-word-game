require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = generate_grid(9)
  end

  def score
    @start_time = Time.parse params[:start]
    @end_time = Time.now
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @result = run_game(@word, @letters, @start_time, @end_time)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    alphabet = ('A'..'Z').to_a
    grid_array = []
    (0...grid_size).each do |i|
      grid_array[i] = alphabet[(0..25).to_a.sample]
    end
    grid_array
  end

  def run_game(attempt, grid, start_time, end_time)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    json = open(url).read
    hash = JSON.parse(json)

    result = { time: end_time - start_time, score: 0, message: 'well done', alert: 'alert-success' }

    if hash['found'] == false
      result[:message] = 'not an english word'
      result[:score] = 0
      return result
    end

    grid_h = {}
    grid.each { |char| grid_h[char].nil? ? grid_h[char] = 1 : grid_h[char] += 1 }
    attempt_h = {}
    attempt.upcase.scan(/\w/).each { |char| attempt_h[char].nil? ? attempt_h[char] = 1 : attempt_h[char] += 1 }

    attempt_h.each do |key, _value|
      if grid_h.key?(key)
        if attempt_h[key] > grid_h[key]
          return result = { time: end_time - start_time, score: 0, message: 'letters overused', alert: 'alert-danger' }
        end
      else
        return result = { time: end_time - start_time, score: 0, message: 'not in the grid', alert: 'alert-danger' }
      end
    end

    if result[:time] <= 5
      attempt.size > 3 ? result[:score] = 5 : result[:score] = 3
    else
      result[:score] = 1
    end
    result
  end
end
