folder('tools') {
    displayName('Tools')
    description('Folder for miscellaneous tools.')
}

job('tools/clone-repository') {
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
