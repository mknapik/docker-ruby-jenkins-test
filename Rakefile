require 'mysql2'
require 'pp'

task :default, [:host, :password] do |_, args|
    host = args[:host]
    password = args[:password]

    client = Mysql2::Client.new(host: host, username: 'root', password: password)
    results = client.query("SHOW DATABASES")
    results.each do |row|
        pp row
    end
end
