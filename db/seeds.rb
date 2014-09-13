require_relative "../password"

["admin"].each do |user|
    s, passhash = Password.hash(user)
    User.create(username: user, salt: s, passhash: passhash, score: 0)
end
