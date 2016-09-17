node('docker') {
    wrap([$class: 'TimestamperBuildWrapper']) {
        checkout(scm)

        withDockerCompose { compose ->
            compose.createJenkinsUser('web')
            compose.exec('web', 'jenkins', """
                whoami
                ruby --version
                ls -lah .
                bundle install --quiet --frozen
                bundle exec rake default[db,'']
            """)
        }
    }
}

class UserGroup implements Serializable {
    final String user
    final String group

    def UserGroup(String user, String group) {
        this.user = user
        this.group = group
    }
}

class DockerCompose implements Serializable {
    private final String projectName;
    private org.jenkinsci.plugins.workflow.cps.CpsScript script;

    def DockerCompose(String projectName, org.jenkinsci.plugins.workflow.cps.CpsScript script) {
        this.projectName = projectName
        this.script = script
    }

    def createJenkinsUser(String service) {
        script.sh 'id -u > .jenkins_uid'
        script.sh 'id -g > .jenkins_gid'
        
        String uid = script.readFile('.jenkins_uid').trim()
        String gid = script.readFile('.jenkins_gid').trim()
        script.sh "getent group $gid | cut -d: -f1 > .jenkins_groupname"
        String group = script.readFile('.jenkins_groupname').trim()

        script.sh 'rm .jenkins_uid'
        script.sh 'rm .jenkins_gid'
        script.sh 'rm .jenkins_groupname'

        exec(service, "addgroup --gid $gid $group")
        exec(service, "adduser  --no-create-home --disabled-password --gecos '' `whoami` --uid $uid --gid $gid")
    }

    def exec(String service, String cmd) {
        script.sh """
            docker-compose -p $projectName exec -T $service bash -c "
                $cmd
            "
        """
    }

    def exec(String service, String user, String cmd) {
        script.sh """
            docker-compose -p $projectName exec --user $user -T $service bash -c "
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