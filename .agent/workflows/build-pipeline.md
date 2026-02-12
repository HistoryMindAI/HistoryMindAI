---
description: Build FAISS index và pipeline dữ liệu từ HuggingFace dataset
---

# /build-pipeline - Build FAISS Index từ HuggingFace

// turbo-all

## Thông tin Pipeline

- **File chính**: `ai-service/scripts/build_from_huggingface.py`
- **Dataset**: `minhxthanh/Vietnam-History-1M-Vi` (HuggingFace)
- **MAX_SAMPLES**: 500,000 (có thể override qua env var)
- **Dependencies**: `ai-service/scripts/entity_registry.py`

## Luồng xử lý

```
HuggingFace Dataset (streaming)
    → Lọc junk/short text
    → Extract: year, persons, places, keywords, tone, nature, dynasty
    → Dedup per-year (Jaccard fingerprint)
    → Humanize text (natural Vietnamese prose)
    → Build FAISS index (vietnamese-sbert)
    → Output: faiss_index/index.bin + faiss_index/meta.json
```

## Các bước chạy

1. Di chuyển vào thư mục `ai-service`:
```bash
cd d:\HistoryMindAI\vietnam_history_dataset\ai-service
```

2. Chạy pipeline build:
```bash
python scripts/build_from_huggingface.py
```

## Cấu hình (Environment Variables)

| Biến | Mặc định | Mô tả |
|---|---|---|
| `MAX_SAMPLES` | 500000 | Số lượng samples tối đa từ HuggingFace |
| `DEDUP_THRESHOLD` | 0.85 | Ngưỡng Jaccard để lọc trùng |
| `MIN_ANSWER_LENGTH` | 30 | Độ dài tối thiểu của câu trả lời |

## Output

- `ai-service/faiss_index/index.bin` — FAISS vector index
- `ai-service/faiss_index/history.index` — FAISS index (backup name)
- `ai-service/faiss_index/meta.json` — Metadata + documents

## Lưu ý

- Pipeline **tải trực tiếp từ HuggingFace** (streaming), không cần file local
- Thời gian chạy: ~15-30 phút tùy mạng và máy
- Cần cài: `datasets`, `sentence-transformers`, `faiss-cpu`, `numpy`
