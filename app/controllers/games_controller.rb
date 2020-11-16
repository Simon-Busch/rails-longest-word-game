require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @new = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    found_word(params[:word])
    compare_words(params[:word], params[:array])
    @message = winning(params[:word], params[:array])[:message]
    @score = winning(params[:word], params[:array])[:score]
    # @winning = "#{message} #{score}"
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    Array.new(grid_size) { ('a'..'z').to_a.sample }
  end
  
  # def calculate_time(start, finish)
  #   finish - start
  # end
  
  def found_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized) # return a hash
    user["found"]
  end
  
  def compare_words(attempt, grid)
    attempt_hash = Hash.new(0)
    attempt.split('').each { |letter| attempt_hash[letter.downcase] += 1 }
    grid_hash = Hash.new(0)
    grid.split("").each { |letter| grid_hash[letter.downcase] += 1 }
    attempt_hash.each do |key, value|
      return false if value > grid_hash[key]
    end
  
    return true
  end
  
  def winning(attempt, grid)
    result = { score: 0 }
    if found_word(attempt) == false # TRUE / FALSE
      result[:message] = "not an english word"
    elsif compare_words(attempt, grid) == false
      result[:message] = "not in the grid"
    else
      result[:message] = "Well done"
      result[:score] = (attempt.size * 12)
    end
    result
  end
  
  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    time = end_time - start_time
    winning(attempt, grid, time)
  end

end


