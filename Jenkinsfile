setDockerImageName()

node('docker') {
    withCleanup {
        stage name: 'prepare shared volume', concurrency: 1
        setupDockerVolume("gems-${env.EXECUTOR_NUMBER}-ruby-2.3")

        withTimestamps {
            stage 'checkout'
            checkout(scm)

            stage 'docker up'
            withDockerCompose { compose ->
                stage 'bundle'
                compose.exec('web', "bundle install --quiet --frozen")

                stage 'setup tables'
                compose.exec('web', "bundle exec rake setup[db,'']")

                stage 'test'
                compose.exec('web', "bundle exec rake test[db,'']")


                stage 'docker down'
            }
        }
    }
}

def setDockerImageName() {
    env.DOCKER_IMAGE_NAME = replaceForbiddenCharacters(env.JOB_NAME)
}

def replaceForbiddenCharacters(String string) {
  string.replaceAll('%2F', '/').replaceAll(/[^a-z0-9-_.]/, '.')
}
