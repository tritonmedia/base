local circle = import 'circle.libsonnet';

circle.ServiceConfig('base') {
  local docker = [ { image: 'circleci/buildpack-deps:curl' } ],
  jobs+: {
    ['build-ubuntu']: circle.Job() {
      steps_+:: [
        circle.BuildDockerImageStep('tritonmedia/base:ubuntu', 'Dockerfile.ubuntu'),
        circle.PublishDockerImageStep('tritonmedia/base:ubuntu'),
      ],
    },
    ['build-testbed']: circle.Job(){
      steps_:: [
        circle.BuildDockerImageStep('tritonmedia/testbed', 'Dockerfile.testbed'),
        circle.PublishDockerImageStep('tritonmedia/testbed'),
      ]
    },
    ['trigger-rebuilds']: circle.Job(){
      docker: [{image: 'circleci/buildpack-deps:curl'}],
      steps_:: [
        circle.RunStep('Trigger Dependency Rebuilds', '.circleci/trigger-builds.sh')
      ],
    },
  },
  workflows+: {
    ['build-push']: circle.Workflow(){
      jobs_:: [
        'build',
        {
          name:: 'build-ubuntu',
          requires: ['build'],
        },
        {
          name:: 'trigger-rebuilds',
          requires: ['build', 'build-ubuntu'],
        },
        'build-testbed'
      ],
    },
  },
}