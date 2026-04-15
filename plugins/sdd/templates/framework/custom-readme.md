# spec/_custom/ — プロジェクト固有設定

このディレクトリは SDD フレームワークのプロジェクト固有設定を管理します。

## steering/ — ステアリングファイル

`steering/` にはプロジェクト固有の情報を定義するファイルを配置します（`/sdd:init` で自動生成）。

| ファイル | 内容 |
|---|---|
| `project.md` | プロダクト概要・ビジョン・ターゲットユーザー・ビジネス目標 |
| `structure.md` | ディレクトリ構造・命名規約・アーキテクチャルール |
| `tech.md` | テックスタック・技術選定理由・制約事項 |

既存ドキュメントがある場合はシンボリックリンクを推奨します。

## テンプレートのカスタマイズ

SDD プラグインにはデフォルトのテンプレートが同梱されています（`.claude/plugins/sdd/templates/`）。
プロジェクト固有の調整が必要な場合、以下の手順でオーバーライドできます:

1. デフォルトテンプレートをこのディレクトリにコピー
2. コピーしたファイルを編集
3. 以降、SDD はこのディレクトリのファイルを優先的に参照

### オーバーライド可能なファイル

**フレームワークドキュメント**（このディレクトリ直下に配置）:

| ファイル | 用途 | デフォルトの場所 |
|---|---|---|
| `workflow.md` | ワークフロー定義 | `.claude/plugins/sdd/templates/framework/workflow.md` |
| `prompt.md` | Spec生成システムプロンプト | `.claude/plugins/sdd/templates/framework/prompt.md` |

**テンプレート**（`templates/` サブディレクトリに配置）:

| ファイル | 用途 | デフォルトの場所 |
|---|---|---|
| `spec-requirements-template.md` | 要件定義テンプレート | `.claude/plugins/sdd/templates/` |
| `spec-design-template.md` | 設計書テンプレート | `.claude/plugins/sdd/templates/` |
| `spec-tasks-template.md` | タスクリストテンプレート | `.claude/plugins/sdd/templates/` |
| `blueprint-overview.md` | BP概要テンプレート | `.claude/plugins/sdd/templates/` |
| `blueprint-architecture.md` | BPアーキテクチャテンプレート | `.claude/plugins/sdd/templates/` |
| `blueprint-scope-template.md` | BPスコープテンプレート | `.claude/plugins/sdd/templates/` |

### 例: tasks テンプレートをカスタマイズする場合

```bash
mkdir -p spec/_custom/templates
cp .claude/plugins/sdd/templates/spec-tasks-template.md spec/_custom/templates/
# spec/_custom/templates/spec-tasks-template.md を編集
```
