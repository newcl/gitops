#!/bin/bash
set -e

echo "Finding Longhorn-related device units..."

# Find all loaded device units that have 'longhorn' in their unit name or path
units=$(systemctl list-units --all --type=device --no-legend | awk '{print $1}' | grep -E 'longhorn|dev-disk-by\\x2did-scsi')

if [ -z "$units" ]; then
  echo "No Longhorn-related device units found to mask."
  exit 0
fi

echo "Found units:"
echo "$units"
echo

echo "Masking Longhorn-related device units to reduce systemd resource usage..."

for unit in $units; do
  echo "Masking $unit"
  systemctl mask "$unit"
done

echo "Reloading systemd daemon..."
systemctl daemon-reload

echo "Done. You may want to reboot or restart systemd for changes to fully take effect."

