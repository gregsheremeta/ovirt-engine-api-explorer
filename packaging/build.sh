#!/bin/bash -ex

# Name and version of the package:
tar_version="${tar_version:=0.0.0}"
tar_file="${tar_file:=ovirt-engine-api-explorer-${tar_version}.tar.gz}"
rpm_version="${rpm_version:=${tar_version}}"
rpm_suffix="${rpm_suffix:=.alpha0}"
rpm_dist="${rpm_dist:=$(rpm --eval '%dist')}"
rpm_release="${rpm_release:=0.0${rpm_suffix}${rpm_dist}}"

# Generate the .spec file from the template for the distribution where
# the build process is running:
spec_template="spec${rpm_dist}.in"
spec_file="ovirt-engine-api-explorer.spec"
sed \
  -e "s|@RPM_VERSION@|${rpm_version}|g" \
  -e "s|@RPM_RELEASE@|${rpm_release}|g" \
  -e "s|@TAR_FILE@|${tar_file}|g" \
  < "${spec_template}" \
  > "${spec_file}" \

# Download the sources:
spectool \
  --get-files \
  "${spec_file}"

# Build the source and binary .rpm files:
rpmbuild \
  -bb \
  --define="_sourcedir ${PWD}" \
  --define="_rpmdir ${PWD}" \
  "${spec_file}"
