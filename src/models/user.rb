class User

    attr_reader :username, :role, :id

    def initialize(id, username, email, password, role)
        @id = id
        @username = username
        @email = email
        @password = password
        @role = role
    end

    def to_s
        puts "#{@id} #{@username} #{@email} #{@role}"
    end

    def to_json
        {'user_id'=>@id, 'username'=>@username, 'email'=>@email, 'role'=>@role}.to_json
    end
end
