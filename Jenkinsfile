node('docker') {
    checkout(scm)

    withEnv(["MYSQL_ROOT_PASSWORD=akjhadsfhreltouocivuxuasdof"]) {
        docker.image('mysql:5.6').withRun("-e MYSQL_ROOT_PASSWORD=${env.MYSQL_ROOT_PASSWORD}") { mysqlContainer ->
            docker.image('ruby:2.3').inside("-u root --link=${mysqlContainer.id}:mysql") {
                sh 'ruby --version'
                sh 'apt-get update'
                sh 'apt-get install --yes --force-yes libmysqlclient-dev'

                sh 'bundle exec rake'
            }
        }
    }
}