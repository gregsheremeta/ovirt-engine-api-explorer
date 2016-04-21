#!/bin/sh -ex

# Clean and then create the artifacts directory:
rm -rf exported-artifacts
mkdir -p exported-artifacts

# Calculate the version number:
version="$(automation/version.py)"
date="$(date --utc +%Y%m%d)"
commit="$(git log -1 --pretty=format:%h)"
suffix=".${date}git${commit}"

# Build the tar file:
tar_name="ovirt-engine-api-explorer"
tar_prefix="${tar_name}-${version}/"
tar_file="${tar_name}-${version}${suffix}.tar.gz"
git archive --prefix="${tar_prefix}" --output="${tar_file}" HEAD

# Build the RPM:
mv "${tar_file}" packaging/
pushd packaging
  export tar_version="${version}"
  export tar_file
  export rpm_suffix="${suffix}"
  ./build.sh
popd

# Copy the .tar.gz and .rpm files to the exported artifacts directory:
for file in $(find . -type f -regex '.*\.\(tar.gz\|rpm\)'); do
  echo "Archiving file \"$file\"."
  mv "$file" exported-artifacts/
done
