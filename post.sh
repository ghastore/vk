#!/bin/bash -e

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

# Vars.
GH_API="${1}"
GH_TOKEN="${2}"
VK_API="${3}"
VK_TOKEN="${4}"
VK_VER="${5}"
VK_OWNER="${6}"
VK_GROUP="${7}"
VK_CR="${8}"
VK_ADS="${9}"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"

# Apps.
date="$( command -v date )"
curl="$( command -v curl )"

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  vk_wall_post
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

gh_repo() {
  local repo_api; repo_api=$( gh_api "${GH_API}" )
  local repo_name; repo_name=$( jq -r '.full_name' <<< "${repo_api}" )
  local repo_url; repo_url=$( jq -r '.html_url' <<< "${repo_api}" )
  local repo_desc; repo_desc=$( jq -r '.description' <<< "${repo_api}" )
  local repo_tags; repo_tags=$( jq -r '.tags_url' <<< "${repo_api}" )

  local tags_api; tags_api=$( gh_api "${repo_tags}?per_page=1" )
  local tag_name; tag_name=$( jq -r '.[0].name' <<< "${tags_api}" )
  local tag_zip_url; tag_zip_url=$( jq -r '.[0].zipball_url' <<< "${tags_api}" )
  local tag_tar_url; tag_tar_url=$( jq -r '.[0].tarball_url' <<< "${tags_api}" )
  local tag_sha; tag_sha=$( jq -r '.[0].commit.sha' <<< "${tags_api}" )

  echo "🎉 New tag released! 🎉";
  [[ "${tag_name}" != "null" ]] && echo "🏷️ Tag: ${tag_name}"
  [[ "${repo_name}" != "null" ]] && echo "📦 Repository: ${repo_name}"
  [[ "${repo_desc}" != "null" ]] && echo "📜 Description: ${repo_desc}"
  [[ "${repo_url}" != "null" ]] && echo "🌎 Repository URL: ${repo_url}"
  [[ "${tag_zip_url}" != "null" ]] && echo "💾 Download (ZIP): ${tag_zip_url}"
  [[ "${tag_tar_url}" != "null" ]] && echo "💾 Download (TAR): ${tag_tar_url}"
  [[ "${tag_sha}" != "null" ]] && echo "🧬 SHA: ${tag_sha}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB REPOSITORY TOPICS.
# -------------------------------------------------------------------------------------------------------------------- #

gh_topics() {
  local topics_api; topics_api=$( gh_api "${GH_API}/topics" )
  local names; names=$( ( jq -r '.names | @sh' <<< "${topics_api}" ) | tr -d \' )

  for name in ${names}; do
    echo -n "#${name} "
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# VK MESSAGE CONSTRUCTOR.
# -------------------------------------------------------------------------------------------------------------------- #

vk_message() {
  gh_repo
  echo ""
  gh_topics
}

# -------------------------------------------------------------------------------------------------------------------- #
# VK WALL POST.
# -------------------------------------------------------------------------------------------------------------------- #

vk_wall_post() {
  local message; message="$( vk_message )"

  ${curl} -s \
    "${VK_API}/method/wall.post?owner_id=${VK_OWNER}" \
    -F "from_group=${VK_GROUP}" \
    -F "message=${message}" \
    -F "copyright=${VK_CR}" \
    -F "mark_as_ads=${VK_ADS}" \
    -F "access_token=${VK_TOKEN}" \
    -F "v=${VK_VER}" \
    -A "${USER_AGENT}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

# GitHub API.
gh_api() {
  ${curl} -s \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -A "${USER_AGENT}" \
  "${1}"
}

# Pushd.
_pushd() {
  command pushd "$@" > /dev/null || exit 1
}

# Popd.
_popd() {
  command popd > /dev/null || exit 1
}

# Timestamp.
_timestamp() {
  ${date} -u '+%Y-%m-%d %T'
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
