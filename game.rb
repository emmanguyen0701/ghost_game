require 'set'
require_relative 'players'

class Game 
    ALPHABET = ("a".."z").to_a
    MAX_LOSS_COUNT = 5

    def initialize(*players)
        words = File.readlines("dictionary.txt").map(&:chomp)
        @players = players
        @fragment = ""
        @dictionary = Set.new(words)
        @losses = Hash.new { |looses, player| losses[player] = 0 }
    end

    def run
        play_round until game_over?
        puts "#{winner} win!!"
    end

    def play_round
        @fragment = ""
        self.display_standing
        
        until round_over?
            take_turn
            next_player!      
        end

        self.update_standing
    end

    def game_over?
        remainning_player == 1
    end

    def winner
        (player, _) = losses.find { |_, losses| losses < MAX_LOSS_COUNT }
        player
     end

    def remainning_player
        losses.count { |key, player| player < MAX_LOSS_COUNT }
    end

    def take_turn
        system("clear")

        puts "It's #{current_player}'s turn"
        letter = nil
        until letter           
            letter = current_player.guess(fragment)     
            unless valid_play?(letter)  
                current_player.alert_invalid_guess(fragment)
                letter = nil
            end
        end
        add_letter(letter)
        puts "#{current_player} added a letter to fragment"
    end

    def current_player
        players.first
    end

    def previous_player
        player = players[-1]
        player if losses[player] < MAX_LOSS_COUNT      
    end

    def next_player!
        players.rotate!
        players.rotate! until losses[current_player] < MAX_LOSS_COUNT
    end

    def record(player)
        count = losses[player]
        "GHOST".slice(0, count)
    end

    def welcome
        system("clear")
        puts "Welcome to the ghost game!"
        puts "Current stadings:"
    end

    def display_standing
        self.welcome
        players.each do |player|
            puts "#{player}: #{record(player)}"
        end
        sleep(1)
    end

    def update_standing
        puts "#{previous_player} spelled #{fragment}"
        puts "#{previous_player} gets a letter!"
        
        if losses[previous_player] == MAX_LOSS_COUNT - 1
            puts "#{previous_player} has been eliminated"
        end

        sleep(3)

        losses[previous_player] += 1
        display_standing
    end

    def round_over?
        is_word?(fragment)
    end

    def is_word?(fragment)
        dictionary.include?(fragment)
    end

    def add_letter(letter)  
        fragment << letter
    end

    def valid_play?(letter)
        ALPHABET.include?(letter) && 
        valid_str?(letter)
    end

    def valid_str?(letter)
        fragment = ""
        potential_word = fragment + letter
        dictionary.each { |word| word.start_with?(potential_word) }
    end

    private

    attr_reader :players, :fragment, :dictionary, :losses

end


if $PROGRAM_NAME == __FILE__
    game = Game.new(
        Players.new("Josh"),
        Players.new("Anna"),
        Players.new("Bob"),
        Players.new("James")   
        )
    game.run
end