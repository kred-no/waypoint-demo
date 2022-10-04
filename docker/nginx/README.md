# waypoint-demo

HashiCorp Waypoint nginx example

## Build

Builds a container image from dockerfile on a remote runner,
using kaniko dockerless builds. Finished image gets pushed to
a remote container registry (e.g. DockerHub).

```bash
waypoint build -local=false
waypoint artifact list
```

## Deploy

Deploy latest build-artifact to target environment.

```bash
waypoint deployment list
waypoint deploy -release=false
waypoint deployment list
```

## Release

Perform release for the last successful deployment.

```bash
waypoint release list
waypoint release -prune-retain=0
waypoint release list
```

## Cleanup

Remove deployments & releases

```bash
waypoint status
waypoint deployment list
waypoint release list
waypoint deployment destroy
```
