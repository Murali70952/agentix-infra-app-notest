import groovy.json.JsonSlurper

pipeline {
    agent { node { label 'srajan-r9' } }

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['uat'],
            description: 'Select environment'
        )
        choice(
            name: 'COMPONENT',
            choices: ['agentix-ui', 'agentix-runtime', 'agentix-backend', 'agentix-auth'],
            description: 'Choose component'
        )
        string(
            name: 'HELM_BRANCH',
            defaultValue: 'main',
            description: 'Git branch to fetch helm charts from'
        )
        string(
            name: 'IMAGE_TAG',
            defaultValue: '0.0.0',
            description: 'Application image tag'
        )
    }

    environment {
        CHART_ROOT   = "helmcharts"
        VALUES_ROOT  = "values"
        CTX_FILE     = "mappings/contexts.json"
        NS_FILE      = "mappings/namespaces.json"
        FIXED_PATH   = "/usr/local/google-cloud-sdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
    }

    stages {

        stage('Checkout Helm Charts Branch') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "${params.HELM_BRANCH}"]],
                    userRemoteConfigs: scm.userRemoteConfigs
                ])
            }
        }

        stage('Load Environment Mappings') {
            steps {
                script {
                    def rawCtx = readFile(CTX_FILE)
                    def ctxMap = new JsonSlurper().parseText(rawCtx)

                    def resolvedCtx = ctxMap[params.ENVIRONMENT]
                    if (!resolvedCtx) {
                        error("ERROR: No kube context mapped for ${params.ENVIRONMENT}")
                    }

                    env.ACTUAL_CONTEXT = "${resolvedCtx}"
                    ctxMap = null

                    def rawNs = readFile(NS_FILE)
                    def nsMap = new JsonSlurper().parseText(rawNs)

                    def nsList = nsMap[params.ENVIRONMENT]
                    if (!nsList || nsList.isEmpty()) {
                        error("ERROR: No namespaces defined for ${params.ENVIRONMENT}")
                    }

                    env.NS_LIST = "${nsList.join(',')}"
                    nsMap = null
                }

                echo """
Environment:      ${params.ENVIRONMENT}
Kube Context:     ${env.ACTUAL_CONTEXT}
Available NS:     ${env.NS_LIST}
"""
            }
        }

        stage('Select Namespace') {
            steps {
                script {
                    def nsChoices = env.NS_LIST.split(',').toList()

                    def userChoice = input(
                        id: "namespaceChoice",
                        message: "Choose namespace for deployment",
                        parameters: [
                            choice(
                                name: 'TARGET_NS',
                                choices: nsChoices,
                                description: 'Select namespace'
                            )
                        ]
                    )

                    env.NAMESPACE = "${userChoice}"
                    echo "Deploying to Namespace: ${env.NAMESPACE}"
                }
            }
        }

        stage('Switch Kube Context') {
            steps {
                sh """
                    /usr/local/bin/kubectl config use-context ${env.ACTUAL_CONTEXT}
                    /usr/local/bin/kubectl config current-context
                """
            }
        }

        stage('Prepare Helm Params') {
            steps {
                script {
                    env.RELEASE_NAME = "${params.COMPONENT}-${params.ENVIRONMENT}"
                    env.CHART_PATH   = "${CHART_ROOT}"
                    env.VALUES_PATH  = "${VALUES_ROOT}/${params.ENVIRONMENT}/${params.COMPONENT}.yaml"
                    env.NS_ARG       = "--namespace ${env.NAMESPACE} --create-namespace"
                }

                echo """
Release Name: ${env.RELEASE_NAME}
Chart Path:   ${env.CHART_PATH}
Values Path:  ${env.VALUES_PATH}
Namespace:    ${env.NAMESPACE}
"""
            }
        }

        stage('Validate Paths') {
            steps {
                script {
                    if (!(params.IMAGE_TAG ==~ /^[A-Za-z0-9._-]+$/)) {
                        error("ERROR: Invalid IMAGE_TAG '${params.IMAGE_TAG}'")
                    }
                }
                sh '''
                [ -d "${CHART_PATH}" ]  || { echo "ERROR: Missing chart directory: ${CHART_PATH}"; exit 1; }
                [ -f "${VALUES_PATH}" ] || { echo "ERROR: Missing values file: ${VALUES_PATH}"; exit 1; }
                echo "Validation Successful"
                '''
            }
        }

        stage('Helm Dry Run') {
            steps {
                sh """
                bash -c 'export PATH=${FIXED_PATH}; helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} -f ${VALUES_PATH} ${NS_ARG} --set-string image.tag=${params.IMAGE_TAG} --dry-run'
                """
            }
        }

        stage('Deploy') {
            steps {
                sh """
                bash -c 'export PATH=${FIXED_PATH}; helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} -f ${VALUES_PATH} ${NS_ARG} --set-string image.tag=${params.IMAGE_TAG}'
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful: ${env.RELEASE_NAME} (${env.NAMESPACE})"
        }
        failure {
            echo "Deployment Failed: ${env.RELEASE_NAME}"
        }
    }
}
