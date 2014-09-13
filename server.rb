require "erb"
require "sinatra"
require "sinatra/activerecord"

require_relative "challenge"
require_relative "dashboard_config"
require_relative "db/models/completed_challenge"
require_relative "db/models/user"
require_relative "password"

set(:database, adapter: "sqlite3", database: "db/db.sqlite3")
enable :sessions

def authorized?()
    return !session[:status].nil?
end

def login(username)
    session[:status] = "logged_in"
    session[:user] = username
    session[:title] = CONFIG.title
end

def logout(username)
    session[:user] = nil
    session[:status] = nil
    COMPLETED[username] = nil
end

CHALLENGES = Challenge.load_all
COMPLETED = Hash.new
CONFIG = DashboardConfig.new

before do
    content_type(:html)
end

get("/") do
    redirect("/login") if (!authorized?)
    redirect("/dashboard")
end

get("/admin") do
    if ((session[:status] != "logged_in") ||
        (session[:user] != "admin"))
        redirect("/dashboard")
    end

    erb(:admin)
end

get("/completed") do
    redirect("/login") if (!authorized?)

    user = session[:user]
    locals = Hash.new
    if (user == "admin")
        locals = {
            completed: CompletedChallenge.all
        }
    else
        locals = {
            completed: CompletedChallenge.where(username: user)
        }
    end

    erb(:completed, locals: locals)
end

get("/create") do
    erb(:create, locals: {title: CONFIG.title})
end

post("/create") do
    user = User.find_by_username(params[:username])
    if (!user.nil?)
        redirect("/create")
    end

    s, passhash = Password.hash(params[:password])
    User.create(username: params[:username],
                salt: s,
                passhash: passhash,
                score: 0)
    login(params[:username])
    redirect("/dashboard")
end

get("/dashboard") do
    redirect("/login") if (!authorized?)

    if (COMPLETED[session[:user]].nil?)
        COMPLETED[session[:user]] = Array.new
        CompletedChallenge.where(username: session[:user]).each do |c|
            COMPLETED[session[:user]].push(c.name)
        end
    end

    locals = {
        challenges: CHALLENGES.values,
        completed: COMPLETED[session[:user]]
    }
    erb(:dashboard, locals: locals)
end

get("/login") do
    redirect("/dashboard") if (authorized?)
    erb(:login, locals: {title: CONFIG.title})
end

post("/login") do
    user = User.find_by_username(params[:username])
    pass = params[:password]

    redirect("/login") if user.nil?
    if (!Password.authentic?(user.salt, pass, user.passhash))
        redirect("/login")
    end

    login(user.username)
    redirect("/dashboard")
end

get("/logout") do
    logout(session[:user]) if (authorized?)
    redirect("/login")
end

get("/scoreboard") do
    redirect("/login") if (!authorized?)

    users = User.all.to_a.delete_if do |user|
        user.username == "admin"
    end

    erb(:scoreboard, locals: {users: users})
end

post("/submit") do
    name = params[:challenge]
    answer = params[:answer]
    challenge = CHALLENGES[name]

    if (COMPLETED[session[:user]].include?(name) ||
        challenge.nil? ||
        (answer != challenge.answer))
        redirect("/dashboard")
    end

    CompletedChallenge.create(username: session[:user], name: name)
    COMPLETED[session[:user]].push(name)

    user = User.find_by_username(session[:user])
    user.update_column(:score, user.score + challenge.score)

    redirect("/dashboard")
end
