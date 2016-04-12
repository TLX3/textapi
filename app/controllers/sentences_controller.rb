class SentencesController < ApplicationController
  def avg_len
    text = params[:text]
    ps = PragmaticSegmenter::Segmenter.new(text: text, clean: true)
    lengths = ps.segment.map { |s| s.length }
    avg = (lengths.inject(:+))/lengths.size
    render :json => avg.to_json
  end
end
