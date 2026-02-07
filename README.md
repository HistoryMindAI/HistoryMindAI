# HistoryMindAI

AI-powered history assistant.

## Structure

- ai/ : AI pipeline (Python)
- BE_HistoryMindAI/ : Backend API (Spring Boot)
- FE_HistoryMindAI/ : Frontend (Web)

## Contracts

- contracts/api.yaml : FE ↔ BE contract
- contracts/errors.yaml: Error codes

## Architecture

- architecture/README_ARCHITECTURE.md
- architecture/responsibility.md
- architecture/data-contract.md

## Rules

- FE must follow api.yaml
- BE must follow errors.yaml
- AI must not contain business logic
