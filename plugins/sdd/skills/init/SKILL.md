---
name: init
description: SDDフレームワークをプロジェクトに導入する初期セットアップ。プロジェクトのコードベースと既存ドキュメントを深く調査し、SDD に必要な構造とステアリングドキュメントを自動構築する。「SDD導入して」「SDDセットアップ」「sdd init」等のリクエストに対応。
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, Agent
---

# SDD Init — 初期セットアップスキル

## 概要

プロジェクトに SDD（Spec-Driven Development）フレームワークを導入するための初期セットアップを行う。
プロジェクトのコードベースと既存ドキュメントをサブエージェントで徹底調査し、SDD に必要な構造を構築する。

## 前提条件

- Git リポジトリであること
- プロジェクトのルートディレクトリで実行すること

## 実行フロー

### Phase 1: プロジェクト調査（並行実行）

2つのリサーチャーサブエージェントを**並行**で起動する。

#### 1a. コードベース調査（sdd-init-code-researcher）

コードベースの構造・技術スタック・アーキテクチャパターンを徹底調査する。

```
Agent を起動:
  name: code-researcher
  subagent_type: sdd-init-code-researcher（プラグインのエージェント定義を使用）
  prompt: |
    プロジェクトのコードベースを徹底調査してください。
    以下の観点で分析し、結果を .tmp/sdd-init/findings-code.md に出力してください。
    判断に迷う点や確認が必要な点は .tmp/sdd-init/questions-code.md に記録してください。
    
    調査観点:
    - ディレクトリ構造（深さ3-4階層）
    - 技術スタック（言語、フレームワーク、ライブラリ）
    - アーキテクチャパターン（DDD, MVC, Clean Architecture 等）
    - 命名規約（ファイル名、変数名、関数名の実態）
    - テスト構成（フレームワーク、配置パターン）
    - CI/CD 構成
    - パッケージマネージャーの種類
    - ビルドツール・リンター・フォーマッター
```

#### 1b. ドキュメント調査（sdd-init-doc-researcher）

既存ドキュメントを精読し、SDD steering 要件とのギャップを分析する。

```
Agent を起動:
  name: doc-researcher
  subagent_type: sdd-init-doc-researcher（プラグインのエージェント定義を使用）
  prompt: |
    プロジェクトの既存ドキュメントを精読し、SDD のステアリング要件とのギャップを分析してください。
    結果を .tmp/sdd-init/findings-docs.md に出力してください。
    判断に迷う点や確認が必要な点は .tmp/sdd-init/questions-docs.md に記録してください。
    
    SDD ステアリング要件（必須3ファイル）:
    - project.md: プロダクト概要・ビジョン・ターゲットユーザー・ビジネス目標
    - structure.md: ディレクトリ構造・命名規約・アーキテクチャルール・設計原則
    - tech.md: 技術スタック一覧・技術選定理由・制約事項・開発ツール
    
    分析観点:
    - 既存ドキュメントの一覧と各ドキュメントの要約
    - 各 steering 要件に対するカバレッジ（%）
    - 既存ドキュメントで十分にカバーされている場合のシンボリンクマッピング案
    - 不足している情報の具体的なリスト
    - ドキュメント内の矛盾・不整合の検出
```

### Phase 2: ドキュメント構成・推敲（sdd-init-composer）

Phase 1 の両方の findings を読み込み、ステアリングドキュメントのドラフトを構成する。

```
Agent を起動:
  name: composer
  subagent_type: sdd-init-composer（プラグインのエージェント定義を使用）
  prompt: |
    .tmp/sdd-init/findings-code.md と .tmp/sdd-init/findings-docs.md を読み込み、
    SDD ステアリングドキュメントのドラフトを構成してください。
    
    方針:
    - 既存ドキュメントで十分にカバーされている steering 要件
      → シンボリンク推奨として .tmp/sdd-init/symlink-plan.md に記録
    - 既存ドキュメントでカバーしきれない steering 要件
      → ドラフトを .tmp/sdd-init/drafts/ に生成
    - 判断に迷う点は .tmp/sdd-init/questions-composer.md に記録
    
    出力:
    - .tmp/sdd-init/symlink-plan.md（シンボリンクマッピング）
    - .tmp/sdd-init/drafts/project.md（必要な場合のみ）
    - .tmp/sdd-init/drafts/structure.md（必要な場合のみ）
    - .tmp/sdd-init/drafts/tech.md（必要な場合のみ）
    - .tmp/sdd-init/questions-composer.md
```

### Phase 3: レビュー（sdd-init-reviewer）

ドラフトの正確性・網羅性・コード実態との整合性をレビューする。

```
Agent を起動:
  name: reviewer
  subagent_type: sdd-init-reviewer（プラグインのエージェント定義を使用）
  prompt: |
    以下のファイルを読み込み、SDD ステアリングドキュメントのドラフトをレビューしてください。
    
    入力:
    - .tmp/sdd-init/findings-code.md（コード調査結果）
    - .tmp/sdd-init/findings-docs.md（ドキュメント調査結果）
    - .tmp/sdd-init/symlink-plan.md（シンボリンクマッピング）
    - .tmp/sdd-init/drafts/（ドラフト群）
    
    レビュー観点:
    - ドラフト内容とコード実態の整合性
    - 用語・命名の正確性
    - 情報の網羅性（steering 要件に対して）
    - 矛盾・重複の検出
    - シンボリンク候補の妥当性
    
    出力:
    - .tmp/sdd-init/review.md（レビュー結果）
    - .tmp/sdd-init/questions-reviewer.md（確認事項）
```

### Phase 4: 横断チェック + ユーザー対話（メインエージェント）

メインエージェントが以下を実行する:

1. **全 questions ファイルの統合**:
   - `.tmp/sdd-init/questions-code.md`
   - `.tmp/sdd-init/questions-docs.md`
   - `.tmp/sdd-init/questions-composer.md`
   - `.tmp/sdd-init/questions-reviewer.md`

2. **スコープ横断の矛盾検出**:
   - findings-code.md と findings-docs.md の間の不整合を特定
   - 例: ドキュメントでは「DDD」と記載しているがコードはそうなっていない
   - 例: 技術スタックの記載が古い

3. **ユーザーへの確認**:
   - 統合した質問を優先度順に提示
   - 横断矛盾を提示して判断を仰ぐ
   - 一つずつ確認を取る

4. **ドラフトの最終化**:
   - ユーザー回答を反映してドラフトを更新
   - シンボリンクマッピングを確定

### Phase 5: ファイル配置

ユーザー承認後、以下を実行する:

1. **ディレクトリ構造の作成**:
   ```bash
   mkdir -p spec/_meta/steering
   mkdir -p spec/_meta/templates
   mkdir -p spec/blueprints
   mkdir -p spec/specs
   mkdir -p spec/_archive/blueprints
   mkdir -p spec/_archive/specs
   ```

2. **フレームワークファイルの配置**:
   - プラグインの `templates/framework/` から `workflow.md`, `prompt.md`, `README.md` を `spec/_meta/` にコピー
   - プラグインの `templates/` から Blueprint/Spec テンプレートを `spec/_meta/templates/` にコピー

3. **ステアリングファイルの配置**:
   - 既存ドキュメントへのシンボリンクを `spec/_meta/steering/` に作成
   - 新規生成したドキュメントはプロジェクトの `docs/` 配下に配置し、シンボリンクを作成

4. **一時ファイルのクリーンアップ**:
   ```bash
   rm -rf .tmp/sdd-init/
   ```

## 出力構造

init 完了後、プロジェクトに以下の構造が追加される:

```
{project-root}/
├── spec/
│   ├── _meta/
│   │   ├── README.md
│   │   ├── workflow.md
│   │   ├── prompt.md
│   │   ├── steering/
│   │   │   ├── project.md  → ../../docs/xxx.md（シンボリンク）
│   │   │   ├── structure.md → ../../docs/xxx.md（シンボリンク）
│   │   │   └── tech.md     → ../../docs/xxx.md（シンボリンク）
│   │   └── templates/
│   │       ├── blueprint-overview.md
│   │       ├── blueprint-architecture.md
│   │       ├── blueprint-scope-template.md
│   │       ├── spec-requirements-template.md
│   │       ├── spec-design-template.md
│   │       └── spec-tasks-template.md
│   ├── blueprints/
│   ├── specs/
│   └── _archive/
│       ├── blueprints/
│       └── specs/
└── docs/
    └── (新規生成されたドキュメントがあればここに配置)
```

## 注意事項

- サブエージェントはすべてファイル経由で情報を受け渡す（メインエージェントのコンテキストを節約）
- 各サブエージェントは `questions-*.md` に確認事項を必ず出力する義務がある
- メインエージェントは Phase 4 でスコープ横断の矛盾検出を行う（サブエージェントには見えない情報）
- ユーザーとの対話はメインエージェントのみが行う
