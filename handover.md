# google-api-client-cr 引き継ぎ資料

## プロジェクト概要

google-api-ruby-client の YouTube Data API v3 を Crystal に移植したライブラリ。
リポジトリ: https://github.com/masak1yu/google-api-client-cr

## 技術スタック

- Crystal >= 1.19.0 (`.tool-versions`: crystal 1.19.1)
- 外部 shard 依存なし（標準ライブラリのみ）
- CI: GitHub Actions (spec + format check + build)

## 現在のバージョン: v0.1.1

### リリース履歴

| バージョン | PR | 内容 |
|-----------|-----|------|
| v0.1.0 | [#1](https://github.com/masak1yu/google-api-client-cr/pull/1) | YouTube Data API v3 全83メソッド・127モデル移植 |
| v0.1.1 | [#2](https://github.com/masak1yu/google-api-client-cr/pull/2) | 基盤機能（retry, pagination, batch, resumable upload, service account, token persistence, tests, CI） |

## ファイル構成

```
src/
├── google-api-client-cr.cr              # エントリポイント (VERSION = "0.1.1")
├── google/
│   ├── apis/
│   │   ├── errors.cr                    # Error / ClientError / RateLimitError / ServerError / AuthorizationError
│   │   ├── options.cr                   # ClientOptions / RequestOptions
│   │   ├── core/
│   │   │   ├── base_service.cr          # HTTP基盤 (GET/POST/PUT/DELETE, retry, upload, download)
│   │   │   ├── api_command.cr           # ApiCommand (定数定義)
│   │   │   ├── http_command.cr          # HttpCommand (プロパティ定義)
│   │   │   ├── pagination.cr            # Paginated module + PageIterator
│   │   │   ├── resumable_upload.cr      # ResumableUpload (チャンクアップロード)
│   │   │   └── batch_request.cr         # BatchRequest (最大50リクエスト一括)
│   │   └── youtube_v3/
│   │       ├── classes.cr               # 127 データモデル (JSON::Serializable)
│   │       └── service.cr               # 83 APIメソッド (YouTubeService)
│   └── auth/
│       ├── oauth2.cr                    # OAuth2Client (認可URL, コード交換, リフレッシュ)
│       ├── token_store.cr               # TokenStore (トークン保存・復元)
│       └── service_account.cr           # ServiceAccountCredentials (JWT認証)

spec/
├── spec_helper.cr
├── google-api-client-cr_spec.cr         # VERSION テスト
├── fixtures/
│   ├── search_response.json
│   └── video_response.json
└── google/
    ├── apis/
    │   ├── core/
    │   │   ├── base_service_spec.cr     # BaseService, エラー階層
    │   │   └── pagination_spec.cr       # PageIterator
    │   └── youtube_v3/
    │       └── classes_spec.cr          # モデル serialize/deserialize
    └── auth/
        ├── oauth2_spec.cr               # OAuth2Client
        └── token_store_spec.cr          # TokenStore save/load

.github/workflows/ci.yml                # GitHub Actions CI
```

## 実装済み機能

### API メソッド (83/83 = 100%)

全27リソースをカバー:
Search, Videos, Channels, Playlists, PlaylistItems, PlaylistImages, Comments, CommentThreads, Subscriptions, Captions, ChannelSections, Activities, LiveBroadcasts, LiveStreams, LiveChatMessages, LiveChatModerators, LiveChatBans, Watermarks, Thumbnails, Members, MembershipsLevels, SuperChatEvents, VideoCategories, VideoAbuseReportReasons, ThirdPartyLinks, AbuseReports, I18n (Languages/Regions), Test

### 認証

| 方式 | 実装 | ファイル |
|------|------|---------|
| API Key | `ENV["API_KEY"]` 自動読み込み or `service.key =` | `base_service.cr` |
| OAuth2 | 認可URL生成, コード交換, トークンリフレッシュ | `oauth2.cr` |
| Service Account (JWT) | JSON鍵ファイルから自動認証 | `service_account.cr` |
| Token Persistence | JSON保存・復元 | `token_store.cr` |

### 基盤機能

| 機能 | 説明 | ファイル |
|------|------|---------|
| Retry / Backoff | 429/5xx 自動リトライ, Retry-After対応, max_retries設定可 | `base_service.cr` |
| Pagination | `PageIterator` + `Paginated` module (16リストレスポンスに適用) | `pagination.cr`, `classes.cr` |
| Batch Requests | 最大50リクエストを1回のHTTPで実行 | `batch_request.cr` |
| Multipart Upload | JSON metadata + ファイル本体 | `base_service.cr` |
| Resumable Upload | チャンク分割, リトライ/レジューム対応 | `resumable_upload.cr` |
| File Download | キャプション等のファイルダウンロード | `base_service.cr` |

### テスト

- 34 examples, 0 failures
- モデル serialize/deserialize, OAuth2, TokenStore, Pagination, エラー階層
- `crystal spec` で実行

## API Key

YouTube Data API v3 の API Key:
```
REDACTED
```
※ Google Cloud Console で発行済み。必要に応じて制限・再生成すること。

## 既知の制限事項・今後の拡張候補

### やっていないこと

1. **Application Default Credentials (ADC)** - GCP環境での自動認証。意図的に除外。
2. **Doc Comments 全網羅** - 主要クラスのみ。83メソッド全てには未付与。
3. **テスト拡充** - HTTP通信のモックテスト（webmock shard等）、サービスメソッド単体テスト。
4. **YouTube 以外の Google API** - Drive, Calendar 等は未実装。コア基盤は汎用設計。

### アーキテクチャメモ

- `BaseService` は単一の `HTTP::Client` インスタンスを保持（`www.googleapis.com` 固定）
- Resumable Upload はセッションURIが別ホストになる可能性があり、内部で別の `HTTP::Client` を生成する
- Batch リクエストも同様に別 `HTTP::Client` を生成
- `JSON::Serializable` の `@[JSON::Field(key: "camelCase")]` でRuby側の snake_case ↔ API の camelCase を変換
- エラークラス階層: `Error` > `ClientError` > `RateLimitError`, `Error` > `ServerError`, `Error` > `AuthorizationError`

## コマンドリファレンス

```bash
# ビルドチェック（型チェックのみ）
crystal build src/google-api-client-cr.cr --no-codegen

# テスト実行
crystal spec

# フォーマットチェック
crystal tool format --check

# フォーマット自動修正
crystal tool format

# ドキュメント生成
crystal doc
```
