class PhonesController < ApplicationController
  def find_numbers
    text = params[:text]
    numbers = []
    text.gsub!(/[()+-]/, "")
    text = text.gsub(/[^\d\s]/, "").strip.split(" ")
    numbers += text.select { |n| n.length == 10 || (n.length == 11 && n[0] == '1') }
    text.each_cons(3) { |a| numbers << a.join("") if a[0].length == 3 && a[1].length == 3 && a[2].length == 4 }
    render :json => numbers.to_json
  end
end
