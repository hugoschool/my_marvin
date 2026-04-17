folder('Tools') {
    displayName('Tools')
    description('Folder for miscellaneous tools.')
}

job('Tools/clone-repository') {
    wrappers {
        preBuildCleanup {
            deleteDirectories()
            cleanupParameter('CLEANUP')
        }
    }
    parameters {
        stringParam('GIT_REPOSITORY_URL', '', 'Git URL of the repository to clone')
    }
    steps {
        shell('git clone $GIT_REPOSITORY_URL')
    }
}

job('Tools/SEED') {
    displayName('SEED')
    parameters {
        stringParam('GITHUB_NAME', '', 'GitHub repository owner/repo_name (e.g.: "EpitechIT31000/chocolatine")')
        stringParam('DISPLAY_NAME', '', 'Display name for the job')
        stringParam('MIRROR_URL', '', 'Git SSH URL to mirror to')
        stringParam('PRIVATE_SSH_KEY', '', 'Base64 encoded SSH key used for mirroring')
    }
    steps {
        dsl('''
            job("$DISPLAY_NAME") {
                wrappers {
                    preBuildCleanup {
                        deleteDirectories()
                        cleanupParameter('CLEANUP')
                    }
                }
                scm {
                    github("$GITHUB_NAME")
                }
                triggers {
                    scm('* * * * *')
                }
                steps {
                    shell('cs2 --ci=github')
                    shell('make fclean')
                    shell('make')
                    shell('make tests_run')
                    shell('make clean')
                    shell("/usr/share/mirror.sh \\\"$PRIVATE_SSH_KEY\\\" \\\"$MIRROR_URL\\\"")
                }
            }
        ''')
    }
}

job('Tools/SEED-DOCKER') {
    displayName('SEED-DOCKER')
    parameters {
        stringParam('GITHUB_NAME', '', 'GitHub repository owner/repo_name (e.g.: "EpitechIT31000/chocolatine")')
        stringParam('DISPLAY_NAME', '', 'Display name for the job')
        stringParam('IMAGE_NAME', '', 'Docker image name')
        stringParam('DOCKER_OPTIONS', '', 'Options to be ran onto the repo')
        stringParam('SSH_HOST', '', 'SSH Host to deploy to')
        stringParam('PRIVATE_SSH_KEY', '', 'Base64 encoded SSH key')
    }
    steps {
        dsl('''
            job("$DISPLAY_NAME") {
                wrappers {
                    preBuildCleanup {
                        deleteDirectories()
                        cleanupParameter('CLEANUP')
                    }
                }
                scm {
                    github("$GITHUB_NAME")
                }
                triggers {
                    scm('* * * * *')
                }
                steps {
                    shell("/usr/share/docker-deploy.sh \\\"$IMAGE_NAME\\\" \\\"$SSH_HOST\\\" \\\"$DOCKER_OPTIONS\\\" \\\"$PRIVATE_SSH_KEY\\\"")
                }
            }
        ''')
    }
}
