fab auth login --tenant <> -u <> -p E<>

fab create .capacities/fabconeur2025.Capacity -P sku=F2,admin=ab77a444-55bf-4bf2-aa51-3fceaaf3aa98,location=eastus2,resourcegroup=test-rg,subscriptionid=88c3aa4a-3792-4816-8eda-300a20feb190

RESPONSE=$(fab api -X post connections -i connection.json 2>&1)
connection_id=$(echo "$RESPONSE" | jq -r '.text.id // empty' 2>/dev/null)

if jq --arg new_id "$connection_id" '.myGitCredentials.connectionId = $new_id' ./git.json > ./git_temp.json; then
  mv ./git_temp.json ./git.json
  echo "Successfully updated git.json with new connectionId: $connection_id"
else
  echo "Error updating git.json"
  exit 1
fi
fab create wsfabcon.Workspace -P capacityname=fabconeur2025

workspace_id=$(fab get wsfabcon.Workspace -q id)
tmp="${workspace_id#"${workspace_id%%[![:space:]]*}"}"
workspace_id="${tmp%"${tmp##*[![:space:]]}"}"
echo "New fabric workspace: $workspace_id"

RESPONSE=$(fab api -X post "workspaces/${workspace_id}/git/connect" -i ./git.json 2>&1)
echo "Git connect response: $RESPONSE"

RESPONSE=$(fab api -X post "workspaces/${workspace_id}/git/initializeConnection" -i ./init.json 2>&1)
echo "Git initialize response: $RESPONSE"

remote_commit_hash=$(echo "$RESPONSE" | jq -r '.text.remoteCommitHash // empty' 2>/dev/null)
echo "Remote hash: $remote_commit_hash"

if jq --arg remote_hash "$remote_commit_hash" '.remoteCommitHash = $remote_hash' ./update.json > ./update_temp.json; then
  mv ./update_temp.json ./update.json
  echo "Successfully updated update.json with new remote hash: $remote_commit_hash"
else
  echo "Error updating update.json"
  exit 1
fi

RESPONSE=$(fab api -X post "workspaces/${workspace_id}/git/updateFromGit" -i ./update.json 2>&1)
echo "Update from git response: $RESPONSE"

fab acl set wsfabcon.Workspace -I f283498b-d15f-478c-af99-83272f7671ee  -R contributor -f

