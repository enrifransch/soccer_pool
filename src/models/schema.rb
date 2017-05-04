require 'sequel'

DB = Sequel.connect('sqlite://soccer-pool.db')

DB.drop_table? :user_matches
DB.drop_table? :pool_matches
DB.drop_table? :matches
DB.drop_table? :users
DB.drop_table? :teams
DB.drop_table? :pools

DB.create_table :users do
    primary_key :id
    String      :username
    String      :email
    String      :password
    Integer     :role
end

DB.create_table :teams do
    primary_key :id
    String      :name
    String      :country
end

DB.create_table :matches do
    primary_key :id
    foreign_key :team_home, :teams
    foreign_key :team_away, :teams
    Integer     :home_score
    Integer     :away_score
end

DB.create_table :pools do
    primary_key :id
    Integer     :pool_status
end

DB.create_table :pool_matches do
    primary_key :id
    foreign_key :pool_id, :pools
    foreign_key :match_id, :matches
end

DB.create_table :user_matches do
    primary_key :id
    foreign_key :user_id, :users
    foreign_key :pool_match, :pool_matches
    Integer     :prediction
end

users = DB[:users]
teams = DB[:teams]
matches = DB[:matches]
pools = DB[:pools]
pool_matches = DB[:pool_matches]
user_matches = DB[:user_matches]

users << { username: 'soccerfan', email: 'socc@mail.com', password: '1234', role: 0 }
users << { username: 'cheerfuljon', email: 'cjon@mail.com', password: '1234', role: 1 }
users << { username: 'ronaldo666', email: 'ron666@mail.com', password: '1234', role: 0 }
users << { username: 'morpheus', email: 'matrx@mail.com', password: '1234', role: 0 }

teams << { name: 'FC Barcelona', country: 'Spain' }
teams << { name: 'Manchester United', country: 'UK' }
teams << { name: 'Juventus FC', country: 'Italy' }
teams << { name: 'Bayern Munich', country: 'Germany' }
teams << { name: 'Monterrey FC', country: 'Mexico' }
teams << { name: 'Paris Saint-Germain', country: 'France' }
teams << { name: 'AC Milan', country: 'Italy' }
teams << { name: 'Real Madrid', country: 'Spain' }

matches << { team_home: 1, team_away: 3, home_score: 0, away_score: 2 }
matches << { team_home: 5, team_away: 4, home_score: 3, away_score: 3 }
matches << { team_home: 1, team_away: 2, home_score: 3, away_score: 1 }
matches << { team_home: 3, team_away: 2, home_score: 5, away_score: 3 }
matches << { team_home: 4, team_away: 1, home_score: 1, away_score: 2 }
matches << { team_home: 2, team_away: 4, home_score: 2, away_score: 0 }
matches << { team_home: 3, team_away: 5, home_score: 0, away_score: 0 }

pools << { pool_status: 1}
pools << { pool_status: 0}
pools << { pool_status: 0}

pool_matches << { pool_id: 1, match_id: 1}
pool_matches << { pool_id: 1, match_id: 2}
pool_matches << { pool_id: 1, match_id: 3}
pool_matches << { pool_id: 2, match_id: 4}
pool_matches << { pool_id: 2, match_id: 5}
pool_matches << { pool_id: 3, match_id: 6}
pool_matches << { pool_id: 3, match_id: 7}

user_matches << { user_id: 1,  pool_match: 1, prediction: 0 }
user_matches << { user_id: 1,  pool_match: 2, prediction: 1 }
user_matches << { user_id: 1,  pool_match: 3, prediction: 2 }
user_matches << { user_id: 1,  pool_match: 4, prediction: 1 }
user_matches << { user_id: 1,  pool_match: 5, prediction: 1 }
user_matches << { user_id: 1,  pool_match: 6, prediction: 0 }
user_matches << { user_id: 1,  pool_match: 7, prediction: 2 }

user_matches << { user_id: 2,  pool_match: 1, prediction: 1 }
user_matches << { user_id: 2,  pool_match: 2, prediction: 2 }
user_matches << { user_id: 2,  pool_match: 3, prediction: 2 }
user_matches << { user_id: 2,  pool_match: 4, prediction: 0 }
user_matches << { user_id: 2,  pool_match: 5, prediction: 0 }
user_matches << { user_id: 2,  pool_match: 6, prediction: 1 }
user_matches << { user_id: 2,  pool_match: 7, prediction: 2 }

user_matches << { user_id: 3,  pool_match: 1, prediction: 1 }
user_matches << { user_id: 3,  pool_match: 2, prediction: 2 }
user_matches << { user_id: 3,  pool_match: 3, prediction: 1 }
user_matches << { user_id: 3,  pool_match: 4, prediction: 0 }
user_matches << { user_id: 3,  pool_match: 5, prediction: 2 }
user_matches << { user_id: 3,  pool_match: 6, prediction: 1 }
user_matches << { user_id: 3,  pool_match: 7, prediction: 1 }
