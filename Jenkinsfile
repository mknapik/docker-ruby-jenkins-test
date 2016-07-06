node('docker') {
    checkout(scm)

    withDockerCompose { compose ->
        compose.run('web', """
            ruby --version
                bundle install --quiet --frozen
                bundle exec rake default[db,'']
        """)
    }
}

class DockerCompose implements Serializable {
    private final String projectName;
    private org.jenkinsci.plugins.workflow.cps.CpsScript script;

    def DockerCompose(String projectName, org.jenkinsci.plugins.workflow.cps.CpsScript script) {
        this.projectName = projectName
        this.script = script
    }

    def run(String service, String cmd) {
        script.sh """
            docker-compose -p $projectName run $service bash -c "
                $cmd
            "
        """
    }

    def up() {
        script.sh "docker-compose -p $projectName up -d"
    }

    def down() {
        script.sh "docker-compose -p $projectName down --rmi local"
    }
}

def withDockerCompose(Closure cl) {
    def compose = new DockerCompose("${env.EXECUTOR_NUMBER}", this)

    try {
        compose.up()

        cl(compose)
    } finally {
        compose.down()
    }
}