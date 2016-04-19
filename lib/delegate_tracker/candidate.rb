class DelegateTracker::Candidate
  attr_accessor :name, :quote, :url, :delegates_earned, :delegates_needed_for_nomination

  def self.create_candidate(party, profile_number)
    candidate = self.new
    candidate.url = Nokogiri::HTML(open(DelegateTracker::CandidateListScraper.new.get_candidate_url(party)[profile_number]))
    candidate.name = candidate.url.css("h1.is-emphasized").text.strip
    candidate.quote = candidate.url.css("p.quote-text").text.strip.tr('"', '')
    candidate.delegates_earned = strip_to_int(candidate.url.css("span.index-text"))
    candidate.delegates_needed_for_nomination = strip_to_int(candidate.url.css("span.needed-text"))
    candidate_profile(candidate)
  end
  def self.strip_to_int(data)
    data.text.strip.downcase.scan(/\d/).join('').to_i
  end
  def self.candidate_profile(candidate)
    pronoun = candidate.name.include?("Hillary") ? "She" : "He"
    puts ""
    puts "#{candidate.name} has won #{candidate.delegates_earned} delegates so far."
    puts ""
    puts "#{pronoun} needs #{candidate.delegates_needed_for_nomination - candidate.delegates_earned} more delegates to win the nomination."
    puts ""
    puts "#{pronoun} is quoted to have said '#{candidate.quote}'"
    puts ""
  end

end