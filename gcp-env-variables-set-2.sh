#!/bin/bash

# Source environment variables (ideally, *all* environment-specific variables here)
source ~/env-variable-test.sh

# --- Validate environment variables

function validate_variable() {
  if [ -z "$1" ]; then
    echo "ERROR: $2 is required."
    return 1  # Indicate failure
  else
    echo "OK: $2"
    return 0  # Indicate success
  fi
}

# Example of more robust validation (requires `grep` and `gcloud` to be installed)
function validate_project_id() {
  if ! echo "$1" | grep -q "^[a-z][a-z0-9-]*[a-z0-9]$"; then # Basic project ID format check
      echo "ERROR: Invalid PROJECT_ID format. Must match ^[a-z][a-z0-9-]*[a-z0-9]$."
      return 1
  elif ! gcloud projects describe "$1" > /dev/null 2>&1; then # Check if project exists
      echo "ERROR: Project $1 not found."
      return 1
  else
      echo "OK: PROJECT_ID"
      return 0
  fi
}


# Call validation functions and exit if any fail
if ! validate_variable "$PROJECT_ID" "PROJECT_ID" || ! validate_project_id "$PROJECT_ID" || \
   ! validate_variable "$ORG" "ORG" || ! validate_variable "$ENV" "ENV" || \
   ! validate_variable "$ENV_GROUP" "ENV_GROUP" || ! validate_variable "$INGRESS_DN" "INGRESS_DN" || \
   ! validate_variable "$GCP_REGION" "GCP_REGION" || ! validate_variable "$GCP_ZONE" "GCP_ZONE"; then
  exit 1
fi

# --- Configure GCP (Idempotent)

CURRENT_REGION=$(gcloud config get-value compute/region 2>/dev/null)
CURRENT_ZONE=$(gcloud config get-value compute/zone 2>/dev/null)

if [ "$GCP_REGION" != "$CURRENT_REGION" ]; then
  echo "Setting compute region to $GCP_REGION"
  gcloud config set compute/region "$GCP_REGION"
fi

if [ "$GCP_ZONE" != "$CURRENT_ZONE" ]; then
  echo "Setting compute zone to $GCP_ZONE"
  gcloud config set compute/zone "$GCP_ZONE"
fi

echo "GCP configuration complete."
