# HistoryMindAI Architecture

## Components

- ai
  - embedding
  - semantic search
  - storyteller
- BE_HistoryMindAI
  - REST API
  - auth
  - orchestration
- FE_HistoryMindAI
  - UI
  - call BE only

## Communication

- FE → BE: REST
- BE → AI: internal API / function call

## Rules

- FE KHÔNG gọi AI trực tiếp
- AI KHÔNG truy cập DB
- AI KHÔNG chứa business logic
