#!/bin/bash
# Get the latest prometheus release and repack it into a Docker Dockerfile
# Used for distributions/arches that prometheus doesn't provide a Dockerfile for
#
# Utilites Required
# - jq
# - curl

set -fue
set -o pipefail

RELEASE_LIST_URL="https://api.github.com/repos/prometheus/prometheus/releases"
LATEST_RELEASE_URL="${RELEASE_LIST_URL}/latest"

if [[ $# -lt 3 ]]; then

  echo "usage: $0 [ windows | openbsd | netbsd | linux | freebsd | darwin | dragonfly ] [ armv5 | armv6 | armv7 ] [ latest | tag ]"
  echo
  echo "example (latest, for armv7): $0 linux armv7 latest"
  echo "example (tagged, version v0.7.0 for armv5): $0 linux armv5 v0.7.0"
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

DL_LINK=$(echo "${RELEASE_INFO}" | jq -r ".assets[] | .browser_download_url | select(test(\"prometheus-.+.${DIST}-${ARCH}.tar.gz\"))")

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

T_DIR="$(readlink -f .)/prometheus"
mkdir -p ${T_DIR}

echo "Writing Dockerfile: ${T_DIR}/Dockerfile"
echo

# Split the Dockerfile HEREDOC so that ${DL_LINK} can be re-written
cat << EOF > ${T_DIR}/Dockerfile

FROM --platform=linux/amd64 alpine:3.16.1

RUN apk update && apk add curl && curl -SL -\# ${DL_LINK} > /prometheus.tar.gz \\
EOF

cat <<"EOF" >>${T_DIR}/Dockerfile
&& TARGET=$(tar -xvf /prometheus.tar.gz) \
&& EXT_DIR=$(echo ${TARGET} | cut -d'/' -f1) \
&& cd ${EXT_DIR} \
&& cp prometheus /bin/ \
&& cp promtool /bin/ \
&& mkdir -p /etc/prometheus \
&& cp prometheus.yml /etc/prometheus/prometheus.yml \
&& cp -a console_libraries/ /etc/prometheus \
&& cp -a consoles/ /etc/prometheus \
&& mkdir -p /etc/prometheus \
&& rm -rf /${EXT_DIR} /prometheus.tar.gz
EOF

cat << EOF >> ${T_DIR}/Dockerfile

FROM --platform=linux/arm64 alpine:3.16.1
LABEL version="${TAG_REL}-${ARCH}"

EOF

cat << EOF >> ${T_DIR}/Dockerfile
COPY --from=0 /bin/prometheus /bin/
COPY --from=0 /bin/promtool /bin/
COPY --from=0 /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
COPY --from=0 /etc/prometheus/console_libraries/ /etc/prometheus/console_libraries/
COPY --from=0 /etc/prometheus/consoles/ /etc/prometheus/consoles/

EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.external-url=${HOSTNAME}", \
             "--web.console.libraries=/etc/prometheus/console_libraries", \
             "--web.console.templates=/etc/prometheus/consoles"]
EOF

echo "Writing version information to: ${T_DIR}/VERSION"
echo "${TAG_REL}-${ARCH}" > "${T_DIR}/VERSION"

echo "Finished writing Dockerfile. To build, run cd prometheus && docker build -t prometheus . "