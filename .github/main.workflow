workflow "Build Dockerfiles" {
  on = "push"
  resolves = ["push u2f-im-tomu.dockerfile", "push f3.dockerfile", "push armv6 blackbox_exporter", "push armv6 alertmanager", "push armv6 prometheus"]
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
  args = ["build -t keyglitch/blackbox_exporter:latest -f /github/workspace/Dockerfile .", "tag keyglitch/blackbox_exporter:latest keyglitch/blackbox_exporter:$(cat /github/workspace/VERSION)", "push keyglitch/blackbox_exporter"]
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
  args = ["build -t keyglitch/alertmanager:latest -f /github/workspace/Dockerfile .", "tag keyglitch/alertmanager:latest keyglitch/alertmanager:$(cat /github/workspace/ALERTMANAGER_VERSION)", "push keyglitch/alertmanager"]
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
  args = ["build -t keyglitch/prometheus-arm:latest -f /github/workspace/Dockerfile .", "tag keyglitch/prometheus-arm:latest keyglitch/prometheus:$(cat /github/workspace/ALERTMANAGER_VERSION)", "push keyglitch/prometheus"]
}
