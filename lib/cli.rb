require 'nokogiri'
require 'open-uri'
require "pry"


class CLI

  def call
    party_selection
  end

  def prompt(message = "What would you like to do today?")
    puts message
    print ":> "
    gets.chomp
  end

  def parties
    puts "Welcome to the 2016 Presidential Candidate Delegate Tracker!"
    puts ""
    puts "Which party would you like to view?"
    puts "1. Democrats"
    puts "2. Republicans"
    puts "Q. Quit"
  end

  def party_selection
    party_selection = prompt(parties)
    case party_selection
    when "1"
      candidate_selection("democrat")
    when "2"
      candidate_selection("republican")
    end
  end
  
  def candidate_selection(party)
    scraper = Scraper.new
    until [user_selection = prompt(scraper.candidates_list(party)).downcase].include?('q')
      if user_selection.to_i <= (scraper.count(party)) || user_selection == "r"
        case user_selection
        when "1"
          candidate = Candidate.new.profile(party, 0)
        when "2"
          candidate = Candidate.new.profile(party, 1)
        when "3"
          candidate = Candidate.new.profile(party, 2)
        when "4"
          candidate = Candidate.new.profile(party, 3)
        when "r"
          candidate = Candidate.new.profile(party, (rand 0 .. Scraper.new.count(party)-1))
        end
      else
        puts "Please select from the options provided."
      end
    end
    party_selection
  end
end

class Scraper

  def candidates(party)
    candidate_source = Nokogiri::HTML(open("http://www.politico.com/2016-election/results/delegate-count-tracker"))
    candidate_list = candidate_source.css(".contains-#{party} .candidate-name")[0..4].css('a[href]').each_with_object({}) { |n, h| h[n.text.strip] = n['href'] }
  end

  def candidates_list(party)
    if party == "democrat"
      party_proper = "Democratic"
    else
      party_proper = "Republican"
    end
    puts "Which #{party_proper} candidate would you like to learn about?"
    puts ""
    candidates(party).each_with_index{|(k,v), index| puts "#{index+=1}. #{k}"}
    puts "R. Random candidate"
    puts "Q. Return to party selection."
  end

  def get_candidate_url(party)
    candidates(party).each_with_index.map{ |(k,v), index| "#{v}"}
  end

  def count(party)
    self.candidates(party).count
  end

end

class Candidate

  def profile(party, profile_number)
    profile_source = Nokogiri::HTML(open(Scraper.new.get_candidate_url(party)[profile_number]))
    candidate_name = profile_source.css("h1.is-emphasized").text.strip
    candidate_quote = profile_source.css("p.quote-text").text.strip.tr('"', '')
    candidate_delegates_earned = strip_to_int(profile_source.css("span.index-text"))
    delegates_needed_for_nomination = strip_to_int(profile_source.css("span.needed-text"))
    pronoun = candidate_name.include?("Hillary") ? "She" : "He"
    puts ""
    puts "#{candidate_name} has won #{candidate_delegates_earned} delegates so far."
    puts ""
    puts "#{pronoun} needs #{delegates_needed_for_nomination - candidate_delegates_earned} more delegates to win the nomination."
    puts ""
    puts "#{pronoun} is quoted to have said '#{candidate_quote}'"
    puts ""
  end
  def strip_to_int(data)
    data.text.strip.downcase.scan(/\d/).join('').to_i
  end

end


CLI.new.call