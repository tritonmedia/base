local circle = import 'circle.libsonnet';

circle.ServiceConfig('base') {
  jobs+: {
    build+: {
      docker: [ { image: 'circleci/buildpack-deps:curl' } ],
      steps_+:: [
        circle.BuildDockerImageStep('tritonmedia/base:ubuntu', 'Dockerfile.ubuntu'),
        circle.PublishDockerImageStep('tritonmedia/base:ubuntu'),
        circle.RunStep('Trigger Dependency Rebuilds', '.circleci/trigger-builds.sh')
      ],
    },
  },
}