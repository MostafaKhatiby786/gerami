#!/bin/bash

set -o errexit
set -o pipefail

if [ ! -z "$1" ] && [ "$1" == "--check" ]; then
echo "No additional keystone-server where fernet keys could be rsynced."
else
echo "No additional keystone-server where fernet keys could be rsynced."
fi
