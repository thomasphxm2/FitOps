#!/usr/bin/env bash
# scripts/teardown.sh
set -euo pipefail
source "$(dirname "$0")/env.sh"

# Online endpoints bill per VM-hour while they exist
for ep in $(az ml online-endpoint list --query "[].name" -o tsv); do
  az ml online-endpoint delete -n "$ep" --yes --no-wait
done

# End of sprint only: uncomment to remove everything
# az group delete -n $RG --yes --no-wait