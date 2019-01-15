workflow "Build Dockerfiles" {
  on = "push"
  resolves = ["push u2f-im-tomu.dockerfile", "push f3.dockerfile", "push armv7 blackbox_exporter", "push armv6 blackbox_exporter"]
}

action "login" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

##

action "u2f-im-tomu.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["login"]
  args = "build -t u2f-im-tomu -f im-tomu/u2f-im-tomu.dockerfile ."
}

action "tag u2f-im-tomu.dockerfile" {
  uses = "actions/docker/tag@master"
  needs = ["u2f-im-tomu.dockerfile"]
  args = "-l -s u2f-im-tomu keyglitch/u2f-im-tomu"
}

action "push u2f-im-tomu.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag u2f-im-tomu.dockerfile"]
  args = "push keyglitch/u2f-im-tomu"
}

##

action "f3.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["login"]
  args = "build -t f3 -f f3/f3.dockerfile ."
}

action "tag f3.dockerfile" {
  uses = "actions/docker/tag@master"
  needs = ["f3.dockerfile"]
  args = "-l -s f3 keyglitch/f3"
}

action "push f3.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag f3.dockerfile"]
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
  args = "build -t blackbox_exporter_armv7 -f /github/workspace/Dockerfile ."
}

action "autotag armv7 blackbox_exporter" {
  uses = "actions/docker/tag@master"
  args = "-e blackbox_exporter_armv7 keyglitch/blackbox_exporter"
  needs = ["build armv7 blackbox_exporter.dockerfile"]
}

action "tag armv7 blackbox_exporter" {
  uses = "actions/docker/cli@master"
  needs = ["autotag armv7 blackbox_exporter"]
  args = "tag blackbox_exporter_armv7 keyglitch/blackbox_exporter:armv7"
}

action "push armv7 blackbox_exporter" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag armv7 blackbox_exporter"]
  args = "push keyglitch/blackbox_exporter"
}

##

action "latest armv6 blackbox_exporter" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./blackbox_exporter/getLatestBlackBoxExporter2Release.sh linux armv6 latest"]
}

action "build armv6 blackbox_exporter.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["latest armv6 blackbox_exporter"]
  args = "build -t blackbox_exporter_armv6 -f /github/workspace/Dockerfile ."
}

action "autotag armv6 blackbox_exporter" {
  uses = "actions/docker/tag@master"
  args = "-e blackbox_exporter_armv6 keyglitch/blackbox_exporter"
  needs = ["build armv6 blackbox_exporter.dockerfile"]
}

action "tag armv6 blackbox_exporter" {
  #uses = "actions/docker/cli@master"
  #uses = "actions/bin/sh@master"
  uses = "actions/docker/cli@master"
  needs = ["autotag armv6 blackbox_exporter"]
  args = "tag blackbox_exporter_armv6 keyglitch/blackbox_exporter:armv6"
}

action "push armv6 blackbox_exporter" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag armv6 blackbox_exporter"]
  args = "push keyglitch/blackbox_exporter"
}

##

action "latest armv6 alertmanager" {
  uses = "actions/bin/sh@master"
  needs = ["login"]
  args = ["apt-get update", "apt-get -y install curl jq", "./alertmanager/getLatestAlertManager.sh linux armv6 latest"]
}

action "build armv6 alertmanager.dockerfile" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["latest armv6 alertmanager"]
  args = "build -t alertmanager_armv6 -f /github/workspace/Dockerfile ."
}

action "autotag armv6 alertmanager" {
  uses = "actions/docker/tag@master"
  args = "-e alertmanager_armv6 keyglitch/alertmanager"
  needs = ["build armv6 alertmanager.dockerfile"]
}

action "tag armv6 alertmanager" {
  #uses = "actions/docker/cli@master"
  #uses = "actions/bin/sh@master"
  uses = "actions/docker/cli@master"
  needs = ["autotag armv6 alertmanager"]
  args = "tag alertmanager_armv6 keyglitch/alertmanager:armv6"
}

action "push armv6 alertmanager" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag armv6 alertmanager"]
  args = "push keyglitch/alertmanager"
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
  args = "build -t alertmanager_armv7 -f /github/workspace/Dockerfile ."
}

action "autotag armv7 alertmanager" {
  uses = "actions/docker/tag@master"
  args = "-e alertmanager_armv7 keyglitch/alertmanager"
  needs = ["build armv7 alertmanager.dockerfile"]
}

action "tag armv7 alertmanager" {
  #uses = "actions/docker/cli@master"
  #uses = "actions/bin/sh@master"
  uses = "actions/docker/cli@master"
  needs = ["autotag armv7 alertmanager"]
  args = "tag alertmanager_armv7 keyglitch/alertmanager:armv7"
}

action "push armv7 alertmanager" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag armv7 alertmanager"]
  args = "push keyglitch/alertmanager"
}
