require 'mysql2'

task :default do
    client = Mysql2::Client.new(host: "127.0.0.1", username: 'root', password: ENV['MYSQL_ROOT_PASSWORD'])
    results = client.query("SHOW DATABASES")
    puts results
end