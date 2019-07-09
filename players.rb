
class Players
    def initialize(name)
        @name = name        
    end

    def alert_invalid_guess(fragment)
        puts "#{fragment} is not a valid move!"
        puts "Your guess must be a letter of the alphabet"
        puts "You must be able to form a word starting with the new fragment."
    end

    def to_s
        @name
    end

    def guess(fragment)
        puts "The current fragment is #{fragment}"
        puts "Add a letter: "        
        input = gets.chomp   
    end

end
