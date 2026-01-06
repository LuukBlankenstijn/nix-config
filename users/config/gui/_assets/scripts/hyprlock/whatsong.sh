#!/bin/sh

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    echo "Error: playerctl is not installed. Please install it and try again."
    exit 1
fi

# Get the currently playing media
media_info=$(playerctl metadata --format "{{title}} - {{artist}}" 2>/dev/null)

# Check if media is playing
if [ -z "$media_info" ]; then
    echo ""
else
    echo "$media_info"
fi

