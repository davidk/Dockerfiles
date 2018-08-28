# Dockerfiles

A collection of Dockerfiles for building various projects (usually my own shaved yaks). These are manually tested at release, but things might change between then and when they're pulled down for use. So definitely file pull requests if that happens.

### Structure

This is loosely enforced, but the arrangement is usually a combination of: `github_username/project`. If it builds a project within a project, the naming can be a bit more creative to indicate what it is.

### Instructions

There is a script to extract the instructions from each Dockerfile's headers. The headers are stripped of leading \#'s
and dropped into a `README.md`. To update every README, run `docgen.sh` in th root of this repository (you may want
to inspect it first, to see what it does).

### docgen format

* The first line is the header of the README, and gets a leading \#

* The rest of the Dockerfile (up to the `FROM <distribution>` line) ends up as the body of the README

* Anything that is a system path or command ends up nicely formatted if its enclosed by backticks: \`\`