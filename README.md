# VK Share

Share GitHub repository information in VK.

## Syntax for Tag Sharing

```yml
name: "Share Tag"

on:
  push:
    tags:
      - '*'

jobs:
  post:
    runs-on: ubuntu-latest
    name: "Share"
    steps:
      - name: "Share GitHub repository tag to VK"
        uses: ghastore/vk@main
        with:
          type: "tag"
          gh_api: "https://api.github.com/repos/${{ github.repository }}"
          gh_token: "${{ secrets.GH_TOKEN }}"
          vk_token: "${{ secrets.VK_TOKEN }}"
          vk_owner: "-000000000"
          vk_cr: "https://example.com"
```

- `mode`  
  GitHub API mode.
  - `commit`
  - `tag`
- `gh_api`  
  GitHub API repository URL. Default: `https://api.github.com`.
- `gh_token`  
  VK API domain URL.
- `vk_api`  
  VK API domain URL. Default: `https://api.vk.com`.
- `vk_token`  
  VK app token. Get: 
  ```https://oauth.vk.com/authorize?client_id=APP_ID&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.131```, `APP_ID` - VK app ID.
- `vk_ver`  
  VK API version. Default: `5.131`.
- `vk_owner`  
  VK owner (page ID).
- `vk_group`  
  VK publish as group name. Default: `1`.
- `vk_cr`  
  VK post copyright.
- `vk_ads`  
  VK publish as ads. Default: `0`.
