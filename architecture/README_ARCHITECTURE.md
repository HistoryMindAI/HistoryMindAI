# Architecture Overview

## Flow

FE → BE → AI → BE → FE

## Backend (BE)

- validates input
- authorizes request
- calls AI
- enriches response
- applies business rules

## AI Service

- semantic search
- reasoning
- text generation
- NO database access
- NO business decisions
