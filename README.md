# Dockerfiles

A collection of Dockerfiles for building various projects, with an ARM twist (sometimes). These are manually tested at release, but things might change between then and when they're pulled down for use. 

I'll try to keep things working as time allows, but please file issues/pull requests if things break, so that we can figure it out together.

### Structure

The arrangement is a combination of: `github_username/project`.

ARM specific Dockerfiles are typically marked with an `-arm` postfix.

### docgen instructions

There is a simple script in the root of this repository to extract the instructions from each Dockerfile's headers. The headers are stripped of leading \#'s
and dropped into a `README.md`. To update every README, run `docgen.sh` in the root of this repository (you may want to inspect it first, to see what it does).

The docgen script makes the following assumptions:

* Each Dockerfile that gets instructions has a `.dockerfile` postfix

* The first line is the header of the README, and gets a leading \# added to make it a title

* The rest of the Dockerfile (up to the `FROM <distribution>` line) ends up as the body of the README

* Markdown formatting applies to all of it, ex: line spacing and backticks (for \`shell commands, maybe\`)
