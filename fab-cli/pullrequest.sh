fab auth login --tenant <> -u <> -p <>

workspace_id=$(fab get wsfabcon.Workspace -q id)
tmp="${workspace_id#"${workspace_id%%[![:space:]]*}"}"
workspace_id="${tmp%"${tmp##*[![:space:]]}"}"
echo "fabric workspace: $workspace_id"


RESPONSE=$(fab api -X get "workspaces/${workspace_id}/git/status" 2>&1)
echo "Git status response: $RESPONSE"

remote_commit_hash=$(echo "$RESPONSE" | jq -r '.text.remoteCommitHash // empty' 2>/dev/null)
echo "Remote hash: $remote_commit_hash"

workspaceHead_hash=$(echo "$RESPONSE" | jq -r '.text.workspaceHead // empty' 2>/dev/null)
echo "workspace hash: $workspaceHead_hash"


if jq --arg remote_hash "$remote_commit_hash" '.remoteCommitHash = $remote_hash' ./updatepr.json > ./updatepr_temp.json; then
  mv ./updatepr_temp.json ./updatepr.json
  echo "Successfully updated updatepr.json with new remote hash: $remote_commit_hash"
else
  echo "Error updating updatepr.json"
  exit 1
fi

if jq --arg workspace_hash "$workspaceHead_hash" '.workspaceHead = $workspace_hash' ./updatepr.json > ./updatepr_temp.json; then
  mv ./updatepr_temp.json ./updatepr.json
  echo "Successfully updated updatepr.json with new workspace hash: $workspaceHead_hash"
else
  echo "Error updating updatepr.json"
  exit 1
fi

RESPONSE=$(fab api -X post "workspaces/${workspace_id}/git/updateFromGit" -i ./updatepr.json 2>&1)
echo "Update from git response: $RESPONSE"