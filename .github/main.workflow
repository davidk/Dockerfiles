workflow "Build Dockerfiles" {
  on = "push"
  #resolves = ["push u2f-im-tomu.dockerfile", "push f3.dockerfile", "push armv7 blackbox_exporter", "push armv6 blackbox_exporter", "push armv6 alertmanager", "push armv7 alertmanager"]
  resolves = ["push u2f-im-tomu.dockerfile", "push f3.dockerfile", "push armv7 blackbox_exporter", "push armv7 alertmanager"]
}

action "login" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

##

action "u2f-im-tomu.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["login"]
  args = "build -t keyglitch/u2f-im-tomu -f im-tomu/u2f-im-tomu.dockerfile ."
}

action "push u2f-im-tomu.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["u2f-im-tomu.dockerfile"]
  args = "push keyglitch/u2f-im-tomu"
}

##

action "f3.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["login"]
  args = "build -t keyglitch/f3 -f f3/f3.dockerfile ."
}

action "push f3.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["f3.dockerfile"]
  args = "push keyglitch/f3"
}

##

action "latest armv7 blackbox_exporter" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./blackbox_exporter/getLatestBlackBoxExporter2Release.sh linux armv7 latest"]
}

action "build armv7 blackbox_exporter.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["latest armv7 blackbox_exporter"]
  args = "build -t keyglitch/blackbox_exporter:armv7 -f /github/workspace/Dockerfile ."
}

action "push armv7 blackbox_exporter" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["build armv7 blackbox_exporter.dockerfile"]
  args = "push keyglitch/blackbox_exporter"
}

##

action "latest armv7 alertmanager" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./alertmanager/getLatestAlertManager.sh linux armv7 latest"]
}

action "build armv7 alertmanager.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["latest armv7 alertmanager"]
  args = "build -t keyglitch/alertmanager:armv7 -f /github/workspace/Dockerfile ."
}

action "push armv7 alertmanager" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["build armv7 alertmanager.dockerfile"]
  args = "push keyglitch/alertmanager"
}
