setDockerImageName()
discardOldBuilds()

node {
    withCleanup {
        stage 'Checkout'
        checkout(scm)
        stash name: 'source'
    }
}

node('docker') {
    unstash 'source'
    stage 'Docker lint'
    sh "docker run --rm -v '${pwd()}/Dockerfile':/Dockerfile:ro redcoolbeans/dockerlint"
}

node('docker') {
    withCleanup {
        unstash 'source'
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
