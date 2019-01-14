workflow "Build Dockerfiles" {
  on = "push"
  #resolves = ["push CircuitPython_RGB_Display", "push f3.dockerfile"]
  resolves = ["push u2f-im-tomu.dockerfile", "push f3.dockerfile"]
}

action "login" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

#action "CircuitPython_RGB_Display.dockerfile" {
#  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
#  needs = ["login"]
#  args = "build -t circuitpython_rgb_display -f adafruit/CircuitPython_RGB_Display.dockerfile ."
#}

#action "tag CircuitPython_RGB_Display.dockerfile" {
#  uses = "actions/docker/tag@master"
#  needs = ["CircuitPython_RGB_Display.dockerfile"]
#  args = "-l -s circuitpython_rgb_display keyglitch/circuitpython_rgb_display"
#}

#action "push CircuitPython_RGB_Display" {
#  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
#  needs = ["tag CircuitPython_RGB_Display.dockerfile"]
#  args = "push keyglitch/circuitpython_rgb_display"
#}

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


