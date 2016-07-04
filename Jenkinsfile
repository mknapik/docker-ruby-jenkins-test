node('docker') {
    checkout(scm)

    def cachePath = "${env.HOME}/shared/bundle/${env.EXECUTOR_NUMBER}"
    def image = docker.build()
    image.inside("-v ${cachePath}:/usr/local/bundle/cache ${opts}") {
        sh 'ruby --version'
        sh 'whoami'
    }

    withMysql { mysqlLink ->
        withRuby('2.3', "--link=${mysqlLink}") {
            sh 'ruby --version'
            sh 'find /usr/local/bundle'
            sh "bundle install --quiet --frozen"
            sh "bundle exec rake default[mysql,${env.MYSQL_PASSWORD}]"
        }
    }
}

def withRuby(String rubyVersion, String opts = '', Closure cl) {
    def cachePath = "${env.HOME}/shared/bundle/${env.EXECUTOR_NUMBER}"
    docker.image('ruby:2.3').inside("-u root  -v ${cachePath}:/usr/local/bundle/cache ${opts}") {
        cl()
    }
}

def withMysql(cl) {
    withEnv(["MYSQL_PASSWORD=akjhadsfhreltouocivuxuasdof", "MYSQL_USER=root", "MYSQL_PORT=3306", "MYSQL_HOST=mysql"]) {
        docker.image('mysql:5.6').withRun("-e MYSQL_ROOT_PASSWORD=${env.MYSQL_PASSWORD}") { mysqlContainer ->
            cl("${mysqlContainer.id}:${env.MYSQL_HOST}")
        }
    }
}
