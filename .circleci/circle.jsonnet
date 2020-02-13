local circle = import 'circle.libsonnet';

circle.ServiceConfig('triton-base') {
  jobs+: {
    build+: {
      steps_+:: [
        circle.BuildDockerImageStep('jaredallard/triton-base:ubuntu'),
        circle.PublishDockerImageStep('jaredallard/triton-base:ubuntu')
      ],
    },
  },
}