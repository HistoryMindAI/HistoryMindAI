# HistoryMind Data Contract

## Common Rules

- query: string, max 500 characters
- time: ISO-8601 UTC
- encoding: UTF-8

## AI Output (Raw Intelligence)

- answer: string
- confidence: float (0–1)
- sources: list[string]

## Backend Responsibilities

- infer intent
- enrich events
- decide no_data
- map errors to errors.yaml
