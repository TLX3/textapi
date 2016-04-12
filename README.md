#textapi
Send a post request to apitext.herokuapp.com via commandline:

`curl -X POST -H "Content-type: application/json" -d {"text":"My cat is gray. It doesn\"t have feathers."}' http://apitext.herokuapp.com/words/avg_len`

###Words:
####/words/avg_len, /words/most_com, /words/median

What is a word? "A single distinct meaningful element of speech or writing, used with others (or sometimes alone) to form a sentence and typically shown with a space on either side when written or printed. For the purposes of this project, I’ve only considered words that belong to the english language.

We could identify words belonging to other languages by loading the respective wordlist as a Set to test text against. I used the most extensive english wordlist online by the Moby Project to compare text against to determine if we have a word." This wordlist doesn't consider various pronouns, esoteric technical jargon, acronyms, and slang as words. To load the list, we read it, strip newlines, and hash each word.
```ruby
WORDS = File.readlines('public/dict.txt').map { |w| w.chomp }.inject({}) { |r, s| r.merge!(s => true) }
```
When determining word, I considered case-insensitivity and compound words count as multiple words. I lowercased the string then stripped all characters belonging to ",.:;?!"'()" then replaced each '-' with a whitespace. Then split on whitespace.
```ruby
words = text.downcase.gsub(/[,.:;?!"'()]/,'').gsub(/-/, " ").split(" ").select { |w| wordlist[w] }
```
To determine the average length of a word, I injected the sum of each word lengths and divided by the number of words.
```ruby
avg = lengths.inject(:+)/lengths.size
```
To determine the most common word, I mapped each word to its count and return the key with the greatest value
```ruby
  counts = Hash.new(0)
  words.each { |w| counts[w] += 1 }
  max = counts.max_by { |w, c| c }[0]
```
To determine the word(s) with median frequency in the corpus, I mapped each word to its count then sorted the hash by value and returned the middle key(s) of the hash.
```ruby
  counts = Hash.new(0)
  words.each { |w| counts[w] += 1 }
  counts = Hash[counts.sort_by { |w, c| c }]
  idx = (counts.keys.size)/2
  counts.keys.size.odd? ? median = [counts.keys[idx]] : median = [counts.keys[idx], counts.keys[idx - 1]]
```

###Sentences:
####/sentences/avg_len
Sentence is a set of words that are ended by a terminal point such as a period, question mark, or exclamation point. Given, the large number of edge cases (49 of them), I used the Pragmatic Segmenter gem for sentence boundary detection. To find the average sentence length, I used the segmenter to extract the sentences from the text and then injected the sum of sentence lengths and divided by the number of sentences.
```ruby
  ps = PragmaticSegmenter::Segmenter.new(text: text, clean: true)
  lengths = ps.segment.map { |s| s.length }
  avg = (lengths.inject(:+))/lengths.size
```

###Phones:
####/phones
Only considered North American numbers in these forms with or without parenthesis and brackets:
* 111-111-1111
* +1-111-111-1111
* 1111111111
* 111 111 1111

To find all phone numbers, I stripped all non-numeric characters except whitespaces from the text and then split on whitespace. All remaining text values with length 10 or length 11 with '1' as the first character are valid numbers. To find the other case where the number is given with whitespaces, I took 3 text values at a time and if it was 3-3-4 form then it's a valid number. For a more complete approach, I would have to also consider the case where non-numeric characters are spread between numeric value. Also, to consider international numbers, you could use Google's libphonelibrary to validate numbers.
```ruby
  text.gsub!(/[()+-]/, "")
  text = text.gsub(/[^\d\s]/, "").strip.split(" ")
  numbers += text.select { |n| n.length == 10 || (n.length == 11 && n[0] == '1') }
  text.each_cons(3) { |a| numbers << a.join("") if a[0].length == 3 && a[1].length == 3 && a[2].length == 4 }
```
