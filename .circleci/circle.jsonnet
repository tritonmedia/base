local circle = import 'circle.libsonnet';

circle.ServiceConfig('base') {
  jobs+: {
    build+: {
      steps_+:: [
        circle.BuildDockerImageStep('tritonmedia/base:ubuntu', 'Dockerfile.ubuntu'),
        circle.PublishDockerImageStep('tritonmedia/base:ubuntu')
      ],
    },
  },
}