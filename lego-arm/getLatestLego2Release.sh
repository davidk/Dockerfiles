#!/bin/bash
# Get the latest lego release and repack it into a Dockerfile
# Used for distributions/arches that lego doesn't provide an ARM image for
#
# Utilites Required
# - jq
# - curl

set -fue
set -o pipefail

RELEASE_LIST_URL="https://api.github.com/repos/xenolf/lego/releases"
LATEST_RELEASE_URL="${RELEASE_LIST_URL}/latest"

if [[ $# -lt 3 ]]; then

  echo "usage: $0 [ linux ] [ armv7 | arm64 ] [ latest | tag ]"
  echo
  echo "example (latest, for arm): $0 linux armv7 latest"
  echo "example (tagged, version v?.?.? for arm): $0 linux armv7 v?.?.?"
  exit 1

fi

DIST=$1
ARCH=$2
RELEASE=$3

if [[ "${RELEASE}" == "latest" ]]; then
  RELEASE_INFO=$(curl -SsL ${LATEST_RELEASE_URL})
else
  RELEASE_INFO=$(curl -SsL ${RELEASE_LIST_URL}/tags/${RELEASE})
fi

echo "Building Docker image for ${DIST} (ver ${RELEASE} on arch ${ARCH}).."

DL_LINK=$(echo "${RELEASE_INFO}" | jq -r ".assets[] | .browser_download_url | select(test(\"lego_.+.${DIST}_${ARCH}.tar.gz\"))")
TAG_REL=$(echo "${RELEASE_INFO}" | jq -r ".tag_name | select(test(\"^v[0-9].*[0-9]$\"))")

if [[ -z "${TAG_REL}" || -z "${DL_LINK}" ]]; then
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

T_DIR="$(readlink -f .)/lego-arm"
mkdir -p ${T_DIR}

echo "Writing Dockerfile: ${T_DIR}/Dockerfile"
echo

# Split the Dockerfile HEREDOC so that ${DL_LINK} can be re-written
cat << EOF > ${T_DIR}/Dockerfile

FROM --platform=linux/amd64 alpine:3.16.1

RUN apk update \
&& apk add curl \
&& curl -SL -\# ${DL_LINK} > lego-arm.tar.gz \
&& tar -xvf lego-arm.tar.gz \
&& chmod +x lego
EOF

cat << EOF >> ${T_DIR}/Dockerfile

FROM --platform=linux/arm64 alpine:3.16.1
LABEL version="${TAG_REL}-${ARCH}"

COPY --from=0 lego /usr/bin/lego

ENTRYPOINT ["/usr/bin/lego"]

EOF

cat << EOF >> ${T_DIR}/Dockerfile


EOF

echo "Writing version information to: ${T_DIR}/VERSION"
echo "${TAG_REL}-${ARCH}" > "${T_DIR}/VERSION"

echo "Finished writing Dockerfile. To build, run cd lego-arm && docker build -t lego-arm . "
