#!/bin/bash
# Get the latest minio-arm release and repack it into a Dockerfile
# Used for distributions/arches that Minio doesn't provide a Dockerfile for
#
# Utilites Required
# - jq
# - curl

set -fue
set -o pipefail

RELEASE_LIST_URL="https://api.github.com/repos/minio/minio/releases"
LATEST_RELEASE_URL="${RELEASE_LIST_URL}/latest"

if [[ $# -lt 1 ]]; then

  echo "usage: $0 [ latest | tag ]"
  echo
  echo "example (latest): $0 latest"
  echo "example (tagged, version RELEASE.2019-01-16T21-44-08Z): $0 RELEASE.2019-01-16T21-44-08"
  exit 1

fi

RELEASE=$1

if [[ "${RELEASE}" == "latest" ]]; then
  RELEASE_INFO=$(curl -SsL ${LATEST_RELEASE_URL})
else
  RELEASE_INFO=$(curl -SsL ${RELEASE_LIST_URL}/tags/${RELEASE})
fi

echo "Building Dockerfile for ver ${RELEASE} .."

DL_LINK=$(echo "${RELEASE_INFO}" | jq -r ".tarball_url")
TAG_REL=$(echo "${RELEASE_INFO}" | jq -r ".tag_name")

if [[ -z "${TAG_REL}" || -z "${DL_LINK}" || "${TAG_REL}" == "null" || "${DL_LINK}" == "null" ]]; then
  echo "Unable to get download link or tag version. Will not continue."
  echo
  echo "Tag output: ${TAG_REL}"
  echo "Download link output: ${DL_LINK}"
  echo
  echo "Exiting."
  exit 1
fi

echo "Tag version: ${TAG_REL}"
echo "Fetching from: ${DL_LINK}"

T_DIR="$(readlink -f .)/minio-arm"
mkdir -p ${T_DIR}

echo "Writing Dockerfile: ${T_DIR}/Dockerfile"
echo

# Split the Dockerfile HEREDOC so that ${DL_LINK} can be re-written
cat << EOF > ${T_DIR}/Dockerfile
FROM golang:alpine

ENV GOARCH arm
ENV CGO_ENABLED 0
ENV GO111MODULE on

RUN apk add --no-cache git

RUN wget ${DL_LINK} && \
mkdir -p /go/src/github.com/minio/ && \
tar -xvf ${TAG_REL} && \
mv ./minio-minio*/ /go/src/github.com/minio/minio && \
/usr/local/go/bin/go install github.com/minio/minio

EOF

cat << EOF >> ${T_DIR}/Dockerfile

FROM resin/armhf-alpine:3.4
LABEL version="${TAG_REL}"

EOF

cat << EOF >> ${T_DIR}/Dockerfile

COPY --from=0 /go/bin/linux_arm/minio /usr/bin/
ENTRYPOINT [ "/usr/bin/minio" ]

EOF

echo "Writing version information to: ${T_DIR}/VERSION"
echo "${TAG_REL}" > "${T_DIR}/VERSION"

echo "Finished writing Dockerfile. To build, run: cd minio-arm && docker build -t minio . "
