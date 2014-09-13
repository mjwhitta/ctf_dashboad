require "digest"
require "securerandom"

class Password
    def self.authentic?(s, pass, passhash)
        pwhash = Digest::SHA256.hexdigest("#{s}#{pass}")
        return (pwhash == passhash)
    end

    def self.hash(pass)
        s = salt
        passhash = Digest::SHA256.hexdigest("#{s}#{pass}")
        return [s, passhash]
    end

    def self.salt
        SecureRandom.random_bytes(16).unpack("C*").pack("U*")
    end
end
