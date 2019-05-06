#!/bin/bash
# Get the latest perkeep commit and write it to a file so we can tag a Docker build
# with the approximate commit.
#
# Utilites Required
# - jq
# - curl

set -fue
set -o pipefail

COMMITS_URL="https://api.github.com/repos/perkeep/perkeep/commits"
HEAD_URL="${COMMITS_URL}/HEAD"

if [[ $# -lt 1 ]]; then

  echo "usage: $0 [ commit ]"
  echo
  echo "example (head): $0 HEAD"
  echo "example (commit): $0 acb8676d2d10776eef862d64b842b4dfb53446b9"
  echo
  exit 1

fi

RELEASE=$1

if [[ "${RELEASE}" == "HEAD" ]]; then
  RELEASE_INFO=$(curl -SsL ${HEAD_URL})
else
  RELEASE_INFO=$(curl -SsL ${COMMITS_URL}/${RELEASE})
fi

echo "Generating Dockerfile for commit at ${RELEASE} .."

COMMIT_HASH=$(echo "${RELEASE_INFO}" | jq -r ".sha")

T_DIR="$(readlink -f .)/perkeep-arm"
mkdir -p ${T_DIR}

echo "Writing Dockerfile: ${T_DIR}/Dockerfile"
echo

cat << EOF > ${T_DIR}/Dockerfile
FROM golang:1.12-alpine

ENV CGO_ENABLED 0

RUN apk update && \
apk add --no-cache git && \
cd /go/src/ && \
git clone https://github.com/perkeep/perkeep ./perkeep.org && \
cd /go/src/perkeep.org && \
git checkout ${COMMIT_HASH} && \
go run make.go -arch arm
EOF

cat << EOF >> ${T_DIR}/Dockerfile

FROM resin/armhf-alpine:3.4
LABEL version="${COMMIT_HASH}"

EOF

cat << EOF >> ${T_DIR}/Dockerfile

COPY --from=0 /go/bin/ /usr/local/bin/

EXPOSE 80 443 3179 8080
ENTRYPOINT [ "/usr/local/bin/linux_arm/perkeepd" ]

EOF

echo "Writing version information to: ${T_DIR}/VERSION"
echo "${COMMIT_HASH}" > "${T_DIR}/VERSION"

echo "Finished writing Dockerfile. To build, run: cd perkeep-arm && docker build -t perkeep-arm . "
