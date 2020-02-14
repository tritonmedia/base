local circle = import 'circle.libsonnet';

circle.ServiceConfig('base') {
  jobs+: {
    build+: {
      steps_+:: [
        circle.BuildDockerImageStep('tritonmedia/base:ubuntu'),
        circle.PublishDockerImageStep('tritonmedia/base:ubuntu')
      ],
    },
  },
}