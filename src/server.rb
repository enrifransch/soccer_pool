# Final Project: Soccer Pool
# Date: 04-May-2017
# Authors:  A01371829 Enrique Franco Scherer
#           A01372348 Alonso Ortiz Hernández 
#           A01371394 Héctor Saldaña Pérez 

require 'sinatra'
require 'json'
require 'sequel'

require 'models/user'

DB = Sequel.connect('sqlite://models/soccer-pool.db')

configure do
  set :root, File.dirname(__FILE__)
  set :public_folder, "public/app"
end

users = DB[:users]
teams = DB[:teams]
matches = DB[:matches]
pools = DB[:pools]
pool_matches = DB[:pool_matches]
user_matches = DB[:user_matches]

valid_user = false
current_user = ''

get '/current_user' do
    current_user.to_json
end

get '/pools' do
    content_type :json
    pools.all.to_json
end

get '/users' do
    content_type :json
    users.all.to_json
end

get '/teams' do 
    content_type :json
    teams.all.to_json
end

get '/pool/:id' do
    query = DB[:pools].where(:id => params[:id])
    content_type :json
    query[:id].to_json
end

get '/pool_matches/:id' do
    query = DB[%Q{select pool_matches.id, team_home, team_away, home_score, away_score, home.name as home, away.name as away
                    from pools 
                    inner join pool_matches on pool_matches.pool_id = pools.id
                    inner join matches on pool_matches.match_id = matches.id
                    inner join teams as home on matches.team_home = home.id
                    inner join teams as away on matches.team_away = away.id
                    where pools.id = ?}, params[:id]]
    content_type :json
    query.to_a.to_json
end

get '/user_matches/:id' do
    query = DB[%Q{select pool_match, prediction, match_id, away.name as away_name, away.country as away_country, home.name as home_name, home.country as home_country
                    from user_matches
                    inner join pool_matches on pool_matches.id = user_matches.pool_match
                    inner join pools on pools.id = pool_matches.pool_id
                    inner join matches on pool_matches.match_id = matches.id
                    inner join teams as away on matches.team_away = away.id
                    inner join teams as home on matches.team_home = home.id
                    where user_matches.user_id = ? and pools.id = ?
                    }, current_user.id, params[:id]]
    content_type :json
    query.to_a.to_json
end

get '/results' do
    query = DB[%Q{select users.id, prediction, pool_id, pool_match, match_id, home_score, away_score
                    from users 
                    inner join user_matches on users.id = user_matches.user_id
                    inner join pool_matches on pool_matches.id = user_matches.pool_match
                    inner join pools on pools.id = pool_matches.pool_id
                    inner join matches on pool_matches.match_id = matches.id
                    inner join teams as away on matches.team_away = away.id
                    inner join teams as home on matches.team_home = home.id
                    where users.role = 0 and pools.pool_status = 0 }]
    content_type :json
    query.to_a.to_json
end

get '/*' do
    puts valid_user
    if (valid_user) then
        File.read("public/app/main/index.html")
    else
       File.read("public/app/login/login.html")
    end
end

post '/new/user' do
    request.body.rewind
    json = JSON.parse(request.body.read)
    begin
        current_user = DB['select id from users where username = ? and password = ?', json['username'], json['password']]
        if current_user[:key]==nil then 
             users << { username: json["username"], email: json["email"], password: json["password"], role: 0 }
        else
            halt 409, { error: 'User already exists' }.to_json
        end
    rescue TypeError    
    end
end

post '/new/pool' do
    pools << { pool_status: 1 }
    content_type :json
    pools.all.to_json
end

post '/users/login' do
    json = JSON.parse(request.body.read)
    query = DB['select id, username, email, password, role from users where username = ? and password = ?', json['username'], json['password']]
    if query[:id]==nil then 
        raise 404 
    else 
        valid_user = true
        query = query.to_a  
        current_user = User.new(query[0][:id], query[0][:username], query[0][:email], query[0][:password], query[0][:role])
    end
end

post '/new_match' do
    json = JSON.parse(request.body.read)
    matches << { team_home: json["homeId"], team_away: json["awayId"], home_score: json["homeScore"], away_score: json["awayScore"] }
    new_match_id = matches.order(:id).last
    pool_matches << { pool_id: json["poolId"], match_id: new_match_id[:id]}
    200
end

put '/close_pool/:id' do
    pools.where(id: params[:id]).update(pool_status: 0)
    200
end

put '/update_score' do
    json = JSON.parse(request.body.read)
    json.each { |team| matches.where(id: team["id"]).update(home_score: team["home_score"], away_score: team["away_score"]) }
    200
end

put '/update_prediction' do
    json = JSON.parse(request.body.read)
    json.each { |user| 
                query = user_matches.where(user_id: current_user.id, pool_match: user['id']) 
                if query[:id] == nil then
                    user_matches << { user_id: current_user.id,  pool_match: user['id'], prediction: user['user_prediction'] }
                else 
                    user_matches.where(user_id: current_user.id, pool_match: user['id']).update(:prediction => user['user_prediction']) 
                end
            }
    200
end

delete '/users/login' do
    valid_user = false
    current_user = nil
end

not_found do
  content_type :json
  halt 404, { error: 'URL not found' }.to_json
end