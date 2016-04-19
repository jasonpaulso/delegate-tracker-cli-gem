class DelegateTracker::CLI

  def call
    party_selection
    goodbye
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
      candidate_selection_list("democrat")
    when "2"
      candidate_selection_list("republican")
    end
  end
  
  def candidate_selection_list(party)
    scraper = DelegateTracker::CandidateListScraper.new
    until [user_selection = prompt(scraper.candidates_list(party)).downcase].include?('q')
      if user_selection.to_i <= (scraper.count(party)) || user_selection == "r"
        case user_selection
        when "1"
          DelegateTracker::Candidate.create_candidate(party, 0)
        when "2"
          DelegateTracker::Candidate.create_candidate(party, 1)
        when "3"
          DelegateTracker::Candidate.create_candidate(party, 2)
        when "4"
          DelegateTracker::Candidate.create_candidate(party, 3)
        when "r"
          DelegateTracker::Candidate.create_candidate(party, (rand 0 .. scraper.count(party)-1))
        end
      else
        puts "Please select from the options provided."
      end
    end
    party_selection
  end
  def goodbye
    puts "Thanks! And don't forget to VOTE!!!"
  end

end