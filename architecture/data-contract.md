## Common Data Rules

- user_id: UUID v4
- query: string (<= 500 chars)
- embedding_dim: 768
- time: ISO-8601 UTC

## AI Output

- answer: string
- confidence: float (0–1)
- sources: list[string]
