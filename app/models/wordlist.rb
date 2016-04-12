class Wordlist < ActiveRecord::Base
    WORDS = File.readlines('public/dict.txt').map { |w| w.chomp }.inject({}) { |r, s| r.merge!(s => true) }
end
