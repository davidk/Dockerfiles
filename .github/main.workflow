workflow "Build Dockerfiles" {
  resolves = ["buildpush f3.dockerfile", "buildpush armv6 blackbox_exporter", "buildpush armv6 alertmanager", "buildpush armv6 prometheus", "buildpush arm rest-server-arm", "buildpush lego-arm", "buildpush arm minio-arm", "buildpush perkeep-arm", "buildpush go-httpbin-arm"]
  on = "schedule(0 8 * * *)"
}

action "login" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_PASSWORD",
  ]
}

## f3

action "buildpush f3.dockerfile" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["login"]
  args = ["build -t keyglitch/f3 -f f3/f3.dockerfile .", "push keyglitch/f3"]
}

## blackbox_exporter

action "latest armv6 blackbox_exporter" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./blackbox_exporter-arm/getLatestBlackBoxExporter2Release.sh linux armv6 latest"]
}

action "buildpush armv6 blackbox_exporter" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest armv6 blackbox_exporter"]
  args = ["build -t keyglitch/blackbox_exporter:latest -f /github/workspace/blackbox_exporter/Dockerfile .", "tag keyglitch/blackbox_exporter:latest keyglitch/blackbox_exporter:$(cat /github/workspace/blackbox_exporter/VERSION)", "push keyglitch/blackbox_exporter"]
}

## alertmanager

action "latest armv6 alertmanager" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./alertmanager-arm/getLatestAlertManager.sh linux armv6 latest"]
}

action "buildpush armv6 alertmanager" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest armv6 alertmanager"]
  args = ["build -t keyglitch/alertmanager:latest -f /github/workspace/alertmanager/Dockerfile .", "tag keyglitch/alertmanager:latest keyglitch/alertmanager:$(cat /github/workspace/alertmanager/VERSION)", "push keyglitch/alertmanager"]
}

## prometheus

action "latest armv6 prometheus" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./prometheus-arm/getLatestPrometheus2Release.sh linux armv6 latest"]
}

action "buildpush armv6 prometheus" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest armv6 prometheus"]
  args = ["build -t keyglitch/prometheus:latest -f /github/workspace/prometheus/Dockerfile .", "tag keyglitch/prometheus:latest keyglitch/prometheus:$(cat /github/workspace/prometheus/VERSION)", "push keyglitch/prometheus"]
}

## rest-server-arm

action "latest rest-server-arm" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./rest-server-arm/getLatestRestServer2Release.sh linux arm latest", "cp -a ./rest-server-arm/docker $PWD"]
}

action "buildpush arm rest-server-arm" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest rest-server-arm"]
  args = ["build -t keyglitch/rest-server-arm:latest -f /github/workspace/rest-server-arm/Dockerfile .", "tag keyglitch/rest-server-arm:latest keyglitch/rest-server-arm:$(cat /github/workspace/rest-server-arm/VERSION)", "push keyglitch/rest-server-arm"]
}

## minio-arm

action "latest minio-arm" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./minio-arm/getLatestMinio2Release.sh latest"]
}

action "buildpush arm minio-arm" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest minio-arm"]
  args = ["build -t keyglitch/minio-arm:latest -f /github/workspace/minio-arm/Dockerfile .", "tag keyglitch/minio-arm:latest keyglitch/minio-arm:$(cat /github/workspace/minio-arm/VERSION)", "push keyglitch/minio-arm"]
}

## lego-arm

action "latest lego-arm" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./lego-arm/getLatestLego2Release.sh linux armv7 latest"]
}

action "buildpush lego-arm" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest lego-arm"]
  args = ["build -t keyglitch/lego-arm:latest -f /github/workspace/lego-arm/Dockerfile .", "tag keyglitch/lego-arm:latest keyglitch/lego-arm:$(cat /github/workspace/lego-arm/VERSION)", "push keyglitch/lego-arm"]
}

## perkeep-arm

action "latest perkeep-arm" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./perkeep-arm/getLatestPerkeepCommit.sh HEAD"]
}

action "buildpush perkeep-arm" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest perkeep-arm"]
  args = ["build -t keyglitch/perkeep-arm:latest -f /github/workspace/perkeep-arm/Dockerfile .", "tag keyglitch/perkeep-arm:latest keyglitch/perkeep-arm:$(cat /github/workspace/perkeep-arm/VERSION)", "push keyglitch/perkeep-arm"]
}

## push go-httpbin

action "latest go-httpbin-arm" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./go-httpbin-arm/getLatestGoHttpBin2Release.sh HEAD"]
}

action "buildpush go-httpbin-arm" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest go-httpbin-arm"]
  args = ["build -t keyglitch/go-httpbin-arm:latest -f /github/workspace/go-httpbin-arm/Dockerfile .", "tag keyglitch/go-httpbin-arm:latest keyglitch/go-httpbin-arm:$(cat /github/workspace/go-httpbin-arm/VERSION)", "push keyglitch/go-httpbin-arm"]
}
