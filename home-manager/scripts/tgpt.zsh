#!/usr/bin/env bash
# tgpt-shell: an interactive wrapper for tgpt

combined_string="$*"
escaped_string=$(echo "$combined_string" | sed 's/["'"'"'&?=#\[]/\\&/g')

tgpt --provider ollama --model gemma3:4b "\"$combined_string\""

