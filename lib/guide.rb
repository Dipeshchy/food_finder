require 'restaurant'
class Guide

    class Config
        @@actions = ['list', 'find', 'add', 'quit']
        def self.actions; @@actions; end
    end

    def initialize(path=nil)
        # locate the restaurant text file at path
        Restaurant.filepath = path
        if Restaurant.file_usable?
            puts "Found restaurant file."
        # or create a new file
        elsif Restaurant.create_file
            puts "Created restaurant file"
        # exit if create file
        else
            puts "Exiting.\n\n"
            exit!
        end

    end

    def launch!
        introduction
        # action loop
        result = nil
        until result == :quit
             #   what do u want to do?(list,find,add,quit)
             action, args = get_action
             #   do that action
            result = do_action(action, args)
        end
        conclusion
    end

    def get_action
        action = nil
        until Guide::Config.actions.include?(action)
            puts "Actions: "+Guide::Config.actions.join(", ") if action
            print "> "
            user_response = gets.chomp
            args = user_response.downcase.strip.split(' ')
            action = args.shift
        end
        return [action, args]
    end

    def do_action(action, args=[])
        case action
            when 'list'
                list
            when 'find'
                keyword = args.shift
                find(keyword)
            when 'add'
                add
            when 'quit'
                return :quit           
            else
                puts "\nI dont understand that command.\n"
        end     
    end

    def add
        puts "\nAdd a Restaurant\n\n".upcase
        restaurant = Restaurant.new
        print "Restaurant name: "
        restaurant.name = gets.chomp.strip
        
        print "Cuisine type: "
        restaurant.cuisine = gets.chomp.strip

        print "Average Price: "
        restaurant.price = gets.chomp.strip

        if restaurant.save
            puts "\nRestaurant added!!\n\n"
        else
            puts "\nSave Error!! Restaurant not add!!\n\n"
        end

    end

    def list
        puts "\nListing Restaurants\n\n".upcase
        restaurants = Restaurant.saved_restaurants
        restaurants.each do |rest|
            puts rest.name.to_s + " | " + rest.cuisine.to_s + " | " + rest.price.to_s
        end
        puts "\n"
    end

    def find(keyword="")
        puts "\nFind a Restaurant\n".upcase
        if keyword
            # search
            restaurants = Restaurant.saved_restaurants
            found = restaurants.select do |rest|
                rest.name.downcase.include?(keyword.downcase) || 
                rest.cuisine.downcase.include?(keyword.downcase) || 
                rest.price.to_i <= keyword.to_i
            end 
            if found.count > 0
                found.each do |rest|
                    puts rest.name.to_s + " | " + rest.cuisine.to_s + " | " + rest.price.to_s
                end 
                puts "\n\n"
            else
                puts "No Restaurant found.\n\n"
            end
        else
            puts "Find using a key phrase to search the restaurant"
        end
    end

    def introduction
            puts "\n<<< Welcome to the Food Finder >>>/n/n"
            puts "This is an interactive guide to help you find the food you crave!!!\n\n"
    end

    def conclusion
        puts "\n<<< Goodbye and Bon Appetit! >>>\n\n"
    end
end
