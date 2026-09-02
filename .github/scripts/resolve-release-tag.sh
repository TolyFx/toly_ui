#!/usr/bin/env bash
# 本脚本只负责将单包或批量发布标签解析为“包名<TAB>版本”清单，不读取或修改项目文件。

set -euo pipefail

release_tag="${1:-}"

if [[ "$release_tag" =~ ^(toly[a-z0-9_]*)-v(.+)$ ]]; then
  printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
  exit 0
fi

if [[ "$release_tag" != publish/* ]]; then
  echo "标签必须符合 toly_package-v1.2.3 或 publish/toly_package@1.2.3/toly_other@2.0.0 格式。" >&2
  exit 1
fi

release_items="${release_tag#publish/}"
if [[ -z "$release_items" ]]; then
  echo "批量发布标签中至少需要包含一个包。" >&2
  exit 1
fi

IFS='/' read -r -a entries <<< "$release_items"
package_names=()

for entry in "${entries[@]}"; do
  if [[ ! "$entry" =~ ^(toly[a-z0-9_]*)@(.+)$ ]]; then
    echo "无效的批量发布项：$entry，应使用 toly_package@1.2.3 格式。" >&2
    exit 1
  fi

  package_name="${BASH_REMATCH[1]}"
  package_version="${BASH_REMATCH[2]}"
  for existing_name in "${package_names[@]:-}"; do
    if [[ "$existing_name" == "$package_name" ]]; then
      echo "批量发布标签中存在重复包：$package_name" >&2
      exit 1
    fi
  done

  package_names+=("$package_name")
  printf '%s\t%s\n' "$package_name" "$package_version"
done
