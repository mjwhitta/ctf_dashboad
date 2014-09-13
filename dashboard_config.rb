require "json"
require "pathname"

class DashboardConfig < Hash
    def initialize()
        config = Pathname.new("dash.conf").expand_path
        if (config.exist?)
            begin
                json = JSON.parse(File.read(config))
                json.keys.each do |key|
                    self[key.to_sym] = json[key]
                end
            rescue
                puts "dash.conf is invalid JSON!"
            end
        end
    end

    def title()
        if (has_key?(:title))
            return self[:title]
        else
            return ""
        end
    end
end
