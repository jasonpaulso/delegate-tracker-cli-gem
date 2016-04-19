class DelegateTracker::CandidateListScraper

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