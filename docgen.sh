#!/bin/bash
# This extracts the header of the Dockerfile for each project
# and puts it into a README.md in each project's folder
# for documentation up front
#
# TODO: Handle more than one Dockerfile in a directly

VERSION="0.01"
YEAH_MODE=""

filter_comments() {
  while read -r lines; do
    echo "$lines" | sed -e 's/^#//g' | sed -e 's/^ //g'
  done
}

write_to_readme() {
echo "Writing: $3"

cat > $3 <<-BERGUP
# ${1}

${2}

<sub>This README.md file was automatically generated by $(basename ${0}) v${VERSION}</sub>
BERGUP

}

if [[ "${YEAH_MODE}" == "yeeeeeah" ]]; then
  echo -e "﻿( •_•)>⌐■-■ (⌐■_■)"
fi

for df in $PWD/*/*.dockerfile; do
  let LN=0
  
  while read -r f; do
    
    if [[ $f =~ ^FROM[[:space:]] ]]; then
      
      echo
      echo "**** Dockerfile execution starts at line $LN ****"
      echo "**** Here's the documentation ****"
      echo

      BODY="$(tail -n +2 $df | head -n $(($LN-1)) | filter_comments)"
      HEADER="$(head -n1 $df | filter_comments)"
      TARGET="$(dirname $df)/README.md"

      echo "HEADER: $HEADER"
      echo "BODY: $BODY"
      echo "DIR: $TARGET"

      write_to_readme "$HEADER" "$BODY" "$TARGET"
    fi

    LN=$((LN + 1))

  done < "$df"

done

if [[ "${YEAH_MODE}" == "yeeeeeah" ]]; then
  echo -e "(⌐■_■) ( •_•)>⌐■-■"
fi
