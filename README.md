# HistoryMindAI

HistoryMindAI is a modular, AI-powered historical assistant.

## Repository Type

This repository is a **monorepo orchestrator**, using **git submodules** to manage independent components.

## Structure

- BE_HistoryMind_AI/  
  Backend service (Spring Boot).  
  Acts as the **orchestrator** and contains all business decisions.

- FE_HistoryMind_AI/  
  Frontend application.  
  UI only, no business logic.

- vietnam_history_dataset/  
  Public historical dataset used as **knowledge source** for AI reasoning.  
  This is **data only**, not executable logic.

- contracts/  
  API and data contracts.  
  **Single source of truth** for FE ↔ BE ↔ AI communication.

- architecture/  
  System design, responsibility split, and architectural rules.

## AI Service (Important Note)

The **AI service itself (models, pipelines, FastAPI app)** is **NOT included** in this repository.

- It is deployed separately
- It consumes:
  - `vietnam_history_dataset`
  - contracts defined in `contracts/`
- It contains **NO business logic**

## Communication Rules

- FE → BE only
- BE → AI only
- FE MUST NOT call AI directly
- AI MUST NOT access database or apply business rules
- Contracts are authoritative
