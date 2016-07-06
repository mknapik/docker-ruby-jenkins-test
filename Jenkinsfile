import org.jenkinsci.plugins.docker.workflow.Docker.

node('docker') {
    checkout(scm)
    def projectName = "${env.EXECUTOR_NUMBER}"

    try {
        sh "docker-compose -p $projectName up -d"

        sh """
            docker-compose -p $projectName exec bash -c "
                ruby --version
                find /usr/local/bundle
                bundle install --quiet --frozen
                bundle exec rake default[mysql,'']
            "
        """
    } finally {
        sh 'docker-compose down'
    }

}