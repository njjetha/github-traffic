#!/bin/bash

# URL of the API endpoint

per_page=30
orgs=("quic" "audioreach" "qualcomm" "qualcomm-AI-research" "qualcomm-linux" "quic-qrb-ros" "SnapdragonStudios")
full_names=""

for org in "${orgs[@]}"; do
  page=1
  while true; do
    url="https://api.github.com/orgs/$org/repos?type=public&per_page=$per_page&page=$page"
    response=$(curl -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer <TOKEN>" \
    -H "X-GitHub-Api-Version: 2022-11-28" -s $url)
    
    # # Print the raw JSON response for debugging
    # echo "Raw JSON response for $org, page $page:"
    echo "$response"
    
    repo_names=$(echo "$response" | jq -r '.[].full_name')
    if [[ -z "$repo_names" ]]; then
      break
    fi
    full_names+="$repo_names"$'\n'
    page=$((page+1))
  done
done

full_names_json=$(echo "$full_names" | jq -R -s -c 'split("\n") | map(select(length > 0))')
# Print the full_name value
echo "$full_names_json"