module GroupMeAnalyzer

  #Most liked message
  #First ever message
  #Last ever message
  #Most frequent poster
  #Most used word
  #Word frequency breakdown
  #Time of Day posting --> Graph!
  #Number of attachments
  #Number of messages
  #Average sentence length
  #Total number of words posted

  def self.analyze_group(messages)
    most_liked_message = nil
    first_message = messages.first
    last_message = messages.last
    user_freq = Hash.new
    word_freq = Hash.new
    time_freq = Hash.new
    num_attachments = 0
    num_words = 0
    messages.each do |message|
      next if !message['system']
      if !most_liked_message.blank? && message['favorited_by'].count > most_liked_message['favorited_by'].count
        most_liked_message = message
      elsif most_liked_message.blank?
        most_liked_message = message
      end
      
      if user_freq[message['name']].nil?
        user_freq[message['name']] = 1
      else
        user_freq[message['name']] += 1
      end

      text = message['text'].downcase.gsub(/[^a-z\s]/, '')
      text.split.each do |word|
        num_words += 1
        if word_freq[word].nil?
          word_freq[word] = 1
        else
          word_freq[word] += 1
        end
      end
      #Time.hour rounds down so message that returns 17 would be 17-18 (5-6 PM)
      if user_freq[Time.at(message['created_at']).hour].nil?
        user_freq[Time.at(message['created_at']).hour] = 1
      else
        user_freq[Time.at(message['created_at']).hour] += 1
      end

      num_attachments += message['attachments'].count

    end

    average_words_message = num_words / messages.count
    user_freq = user_freq.sort_by {|_key, value| value}
    word_freq = word_freq.sort_by {|_key, value| value}
    time_freq = time_freq.sort_by {|_key, value| value}

    { most_liked: most_liked_message, first: first_message, last: last_message, user_frequency: user_freq, word_frequency: word_freq, time_frequency: time_freq, num_attachments: num_attachments, num_words: num_words, average_words: average_words_message}
  end

end
