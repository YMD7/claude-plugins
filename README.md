# claude-plugins

Claude Code プラグインのモノレポ。

## Plugins

| Plugin | Description |
|--------|-------------|
| [sdd](./plugins/sdd/) | Spec-Driven Development framework |
| [terse-mode](./plugins/terse-mode/) | Output token reduction mode for Claude Code workflows |

## Usage

### 一時的に使う（セッション単位）

```bash
claude --plugin-dir ./plugins/sdd
```

### プロジェクトに導入する（永続）

1. 導入先プロジェクトの `.claude/plugins/` にプラグインを配置する（コピーまたはシンボリックリンク）

2. `.claude/plugins/.claude-plugin/marketplace.json` を作成する

```json
{
  "name": "<marketplace-name>",
  "description": "Project-local plugins",
  "owner": { "name": "<owner>" },
  "plugins": [
    {
      "name": "sdd",
      "description": "Spec-Driven Development framework for Claude Code",
      "source": "./sdd",
      "category": "development"
    }
  ]
}
```

3. ローカルマーケットプレイスを登録し、プラグインをインストールする

```bash
claude plugin marketplace add /absolute/path/to/.claude/plugins --scope project
claude plugin install sdd@<marketplace-name> --scope project
```

インストール後はセッションを跨いでも自動的に読み込まれる。
