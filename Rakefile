require 'mysql2'
require 'pp'

host = ENV['MYSQL_HOST']
password = ENV['MYSQL_ROOT_PASSWORD']
task :default do
    client = Mysql2::Client.new(host: host, username: 'root', password: password)
    results = client.query("SHOW DATABASES")
    results.each do |row|
        pp row
    end
end
