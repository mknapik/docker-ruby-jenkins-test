require 'mysql2'
require 'pp'

task :default, [:host, :password] => [:setup, :test]
task :setup, [:host, :password] do |_, args|
  host = args[:host]
  password = args[:password]

  client = Mysql2::Client.new(host: host, username: 'root', password: password)
  client.query('DROP DATABASE IF EXISTS docker_ruby_jenkins_test')
  client.query('CREATE DATABASE docker_ruby_jenkins_test')
  client.select_db('docker_ruby_jenkins_test')

  500.times do |i|
    r = client.query(
      <<-SQL
        CREATE TABLE `foobar#{i}` (
          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
          `a` varchar(23) NOT NULL,
          `b` tinyint(3) unsigned NOT NULL,
          `c` tinyint(3) unsigned NOT NULL,
          `d` datetime NULL,
          `e` tinyint(3) unsigned NULL,
          `f` int(10) unsigned DEFAULT NULL,
          `g` int(10) unsigned DEFAULT NULL,
          `h` int(10) unsigned DEFAULT NULL,
          PRIMARY KEY (`id`),
          UNIQUE KEY `index_#{i}` (`a`,`b`,`c`,`d`,`e`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
      SQL
    )
  end
end

task :test, [:host, :password] do |_, args|
  host = args[:host]
  password = args[:password]

  client = Mysql2::Client.new(host: host, username: 'root', password: password)
  client.select_db('docker_ruby_jenkins_test')

  50.times do |j|
    500.times do |i|
      client.query("INSERT INTO `foobar#{i}` (a, b, c) VALUES ('#{j}', #{j}, #{j})")
    end
  end
end
