class WordsController < ApplicationController
  def avg_len
    text = params[:text]
    wordlist = Wordlist::WORDS
    words = text.downcase.gsub(/[,.:;?!"'()]/,'').gsub(/-/, " ").split(" ").select { |w| wordlist[w] }
    lengths = []
    words.each { |w| lengths << w.length }
    !lengths.empty? ? avg = lengths.inject(:+)/lengths.size : avg = 0
    render :json => avg.to_json
  end

  def most_com
    text = params[:text]
    wordlist = Wordlist::WORDS
    words = text.downcase.gsub(/[,.:;?!"'()]/,'').gsub(/-/, " ").split(" ").select { |w| wordlist[w] }
    counts = Hash.new(0)
    words.each { |w| counts[w] += 1 }
    max = counts.max_by { |w, c| c }[0]
    render :json => max.to_json
  end

  def median
    text = params[:text]
    wordlist = Wordlist::WORDS
    words = text.downcase.gsub(/[,.:;?!"'()]/,'').gsub(/-/, " ").split(" ").select { |w| wordlist[w] }
    counts = Hash.new(0)
    words.each { |w| counts[w] += 1 }
    counts = Hash[counts.sort_by { |w, c| c }]
    idx = (counts.keys.size)/2
    counts.keys.size.odd? ? median = [counts.keys[idx]] : median = [counts.keys[idx], counts.keys[idx - 1]]
    render :json => median.to_json
  end
end
