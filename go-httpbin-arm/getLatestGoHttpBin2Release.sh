#!/bin/bash
# Get the latest go-httpbin commit and write it to a file so we can tag a Docker build
# with the approximate commit.
#
# Utilites Required
# - jq
# - curl

set -fue
set -o pipefail

COMMITS_URL="https://api.github.com/repos/mccutchen/go-httpbin/commits"
HEAD_URL="${COMMITS_URL}/HEAD"

if [[ $# -lt 1 ]]; then

  echo "usage: $0 [ commit ]"
  echo
  echo "example (head): $0 HEAD"
  echo "example (commit): $0 c5cb2f4802fac63859778c72989fe88dce35fe35"
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

T_DIR="$(readlink -f .)/go-httpbin-arm"
mkdir -p ${T_DIR}

echo "Writing Dockerfile: ${T_DIR}/Dockerfile"
echo

cat << EOF > ${T_DIR}/Dockerfile
FROM golang:alpine

ENV CGO_ENABLED 0

WORKDIR /go/src/github.com/mccutchen/

RUN apk add --no-cache git build-base && \
git clone https://github.com/mccutchen/go-httpbin && \
cd go-httpbin && \
ls && \
GOARCH=arm make
EOF

cat << EOF >> ${T_DIR}/Dockerfile

FROM --platform=linux/arm64 alpine:3.16.1
LABEL version="${COMMIT_HASH}"

EOF

cat << EOF >> ${T_DIR}/Dockerfile

COPY --from=0 /go/src/github.com/mccutchen/go-httpbin/dist/go-httpbin /usr/local/bin/

EXPOSE 8080
CMD [ "/usr/local/bin/go-httpbin" ]

EOF

echo "Writing version information to: ${T_DIR}/VERSION"
echo "${COMMIT_HASH}" > "${T_DIR}/VERSION"

echo "Finished writing Dockerfile. To build, run: cd go-httpbin-arm && docker build -t go-httpbin-arm . "
