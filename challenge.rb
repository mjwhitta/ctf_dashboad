require "json"
require "pathname"

class Challenge < Hash
    CHALLENGE_DIR = Pathname.new("views/challenges").expand_path

    def answer()
        return self["answer"]
    end

    def initialize(json)
        json.keys.each do |key|
            self[key] = json[key]
        end
    end

    def self.load_all()
        challenges = Hash.new
        Dir["#{CHALLENGE_DIR}/*.json"].each do |challenge|
            begin
                c = Challenge.new(JSON.parse(File.read(challenge)))
                challenges[c.name] = c
            rescue
                puts "Challenge #{challenge} is not valid JSON!"
            end
        end

        return challenges
    end

    def name()
        return self["name"]
    end

    def score()
        return self["score"].to_i
    end

    def source()
        return self["source"]
    end
end
