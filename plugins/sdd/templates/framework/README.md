# Spec Driven Development (SDD) フレームワーク

仕様駆動開発のコアフレームワーク。ツール非依存のポータブルな設計。

## ディレクトリ構成

```
spec/
├── _meta/                       # SDDコアフレームワーク
│   ├── README.md                # このファイル
│   ├── workflow.md              # ワークフロー定義
│   ├── prompt.md                # Spec生成システムプロンプト
│   ├── steering/                # プロジェクト固有の規約（シンボリックリンク推奨）
│   └── templates/               # Blueprint/Specテンプレート
├── _archive/                    # 完了済みBlueprint/Specの保管場所
├── blueprints/                  # アクティブなBlueprint
└── specs/                       # アクティブなSpec
```

## 開発フロー

Blueprint (全体設計) → Scope (開発スコープ) → Requirements → Design → Tasks

各段階でユーザー承認を経てから次へ進む。

## ポータビリティ

SDDフレームワークは特定のAIツールに依存しない設計。

### 新規プロジェクトへの導入

`/sdd:init` を実行すると、プロジェクトのコードベースと既存ドキュメントを調査し、SDDに必要な構造を自動構築する。

手動で導入する場合:
1. `spec/_meta/` をコピー（`steering/` のシンボリックリンクは除く）
2. ディレクトリ構造を作成（`spec/blueprints`, `specs`, `_archive`）
3. ステアリングファイルを設定（`project.md`, `structure.md`, `tech.md`）

### 構成の役割分担

| 層 | 場所 | 役割 | ポータブル |
|---|---|---|---|
| フレームワーク | `spec/_meta/` | ワークフロー定義・テンプレート・ステアリングIF | ツール非依存 |
| 統合層 | SDD プラグイン | Claude Code 固有機能（レビュー、PlanMode） | Claude Code 専用 |
