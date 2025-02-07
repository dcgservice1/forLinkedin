#! /bin/bash

# Debugging easier
set -x

# Stop apt-get call from trying to bring up UI
export DEBIAN_FRONTEND=noninteractive

# Installed packages are up to date with security patches
apt-get -yq update
apg-get -yq upgrade

# Install GCP logging agent
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
bash install-logging-agent.sh

# Install and run stress tool to max the CPU load for a while
apt-get -yq install stress
stress -c 8 -t 120

# Metadata should be set in the "gs://bucketname/" format
log_bucket_metadata_name=lab-logs-bucket
log_bucket_metadata_url="http://metadata.google.internal/computeMetadata/v1/instance/attributes/${log_bucket_metadata_name}"
worker_log_bucket=$(curl -H "Metadata-Flavor: Google" "${log_bucket_metadata_url}")

# We write a file named after this machine
worker_log_file="machine-$(hostname)-finished.txt"
echo "Work completed at $(date)" >"${worker_log_file}"

# And we copy that file to the bucket specified in the metadata.
echo "Copying the log file to the bucket..."
gsutil cp "${worker_log_file}" "${worker_log_bucket}"
