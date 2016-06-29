node('docker') {
    checkout(scm)
    sh 'ls'

    withEnv(["MYSQL_PORT=${3306 + (env.EXECUTOR_NUMBER ? env.EXECUTOR_NUMBER : 0).toInteger()}"]) {
        docker.image('mysql:5.6').withRun("-e MYSQL_ROOT_PASSWORD=root -p ${env.MYSQL_PORT}:3306") {
            docker.image('ruby:2.3').inside {
                sh 'ls'
                sh 'ruby --version'
                sh 'mysql --version'
                sh 'bundle'
            }
        }
    }
}