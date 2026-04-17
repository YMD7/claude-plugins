#!/bin/bash
# terse-mode: SessionStart フックでスキル定義 + プロジェクト固有ルールを自動注入
# PlanMode承認時のコンテキストリセット（source: clear）でも再発火する
#
# ${CLAUDE_PLUGIN_ROOT} は SessionStart で未設定の既知バグがあるため
# $0 から PLUGIN_ROOT を自己解決する

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CORE_SKILL="$PLUGIN_ROOT/skills/terse-mode/SKILL.md"
CUSTOM="$CLAUDE_PROJECT_DIR/.claude/terse-mode/custom.md"

if [ -f "$CORE_SKILL" ]; then
  cat "$CORE_SKILL"
fi

if [ -f "$CUSTOM" ]; then
  echo ""
  echo "# --- Project custom overrides ---"
  cat "$CUSTOM"
fi
