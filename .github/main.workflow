workflow "Build Dockerfiles" {
  on = "push"
  resolves = ["push u2f-im-tomu.dockerfile", "push f3.dockerfile", "push armv6 blackbox_exporter", "push armv6 alertmanager", "push armv6 prometheus", "push arm rest-server-arm", "push lego-arm", "push arm minio-arm", "push perkeep-arm"]
}

action "login" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

## tomu u2f

action "push u2f-im-tomu.dockerfile" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["login"]
  args = ["build -t keyglitch/u2f-im-tomu -f im-tomu/u2f-im-tomu.dockerfile .", "push keyglitch/u2f-im-tomu"]
}

## f3

action "push f3.dockerfile" {
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

action "push armv6 blackbox_exporter" {
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

action "push armv6 alertmanager" {
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

action "push armv6 prometheus" {
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

action "push arm rest-server-arm" {
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

action "push arm minio-arm" {
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

action "push lego-arm" {
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

action "push perkeep-arm" {
  uses = "davidk/docker/cli-multi@cli-loop"
  needs = ["latest perkeep-arm"]
  args = ["build -t keyglitch/perkeep-arm:latest -f /github/workspace/perkeep-arm/Dockerfile .", "tag keyglitch/perkeep-arm:latest keyglitch/perkeep-arm:$(cat /github/workspace/perkeep-arm/VERSION)", "push keyglitch/perkeep-arm"]
}