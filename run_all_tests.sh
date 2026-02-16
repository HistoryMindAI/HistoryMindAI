#!/bin/bash

# Test Execution Script for HistoryMindAI
# Runs all unit tests across AI Service, Frontend, and Backend

set -e  # Exit on error

echo "=========================================="
echo "HistoryMindAI - Unit Test Execution"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track test results
AI_SERVICE_PASSED=0
FRONTEND_PASSED=0
BACKEND_PASSED=0

# ==========================================
# 1. AI Service Python Tests
# ==========================================
echo -e "${YELLOW}[1/3] Running AI Service Python Tests...${NC}"
echo ""

cd vietnam_history_dataset || exit 1

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo -e "${RED}Error: Virtual environment not found${NC}"
    echo "Please run: python -m venv .venv"
    exit 1
fi

# Activate virtual environment
source .venv/Scripts/activate 2>/dev/null || source .venv/bin/activate 2>/dev/null

# Install test dependencies if needed
pip install -q pytest pytest-mock pytest-cov 2>/dev/null

echo "Running Bug Fix Tests..."
if pytest tests/test_bug_fixes.py -v --tb=short; then
    echo -e "${GREEN}✓ Bug Fix Tests Passed${NC}"
else
    echo -e "${RED}✗ Bug Fix Tests Failed${NC}"
fi

echo ""
echo "Running Edge Case Tests..."
if pytest tests/test_edge_cases.py -v --tb=short; then
    echo -e "${GREEN}✓ Edge Case Tests Passed${NC}"
    AI_SERVICE_PASSED=1
else
    echo -e "${RED}✗ Edge Case Tests Failed${NC}"
fi

# Generate coverage report
echo ""
echo "Generating coverage report..."
pytest tests/test_bug_fixes.py tests/test_edge_cases.py \
    --cov=ai-service/app/services \
    --cov=ai-service/app/utils \
    --cov-report=html:htmlcov \
    --cov-report=term-missing \
    --quiet || true

echo ""
echo -e "${GREEN}Coverage report saved to: vietnam_history_dataset/htmlcov/index.html${NC}"

cd ..

# ==========================================
# 2. Frontend TypeScript Tests
# ==========================================
echo ""
echo -e "${YELLOW}[2/3] Running Frontend TypeScript Tests...${NC}"
echo ""

cd FE_HistoryMind_AI || exit 1

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${RED}Error: node_modules not found${NC}"
    echo "Please run: npm install"
    exit 1
fi

echo "Running Format Response Edge Cases Tests..."
if npm test -- format-response-edge-cases --run; then
    echo -e "${GREEN}✓ Format Response Tests Passed${NC}"
else
    echo -e "${RED}✗ Format Response Tests Failed${NC}"
fi

echo ""
echo "Running useChatStream Race Condition Tests..."
if npm test -- useChatStream-race-conditions --run; then
    echo -e "${GREEN}✓ useChatStream Tests Passed${NC}"
    FRONTEND_PASSED=1
else
    echo -e "${RED}✗ useChatStream Tests Failed${NC}"
fi

# Generate coverage report
echo ""
echo "Generating coverage report..."
npm test -- --coverage --run || true

cd ..

# ==========================================
# 3. Backend Java Tests
# ==========================================
echo ""
echo -e "${YELLOW}[3/3] Running Backend Java Tests...${NC}"
echo ""

cd BE_HistoryMind_AI || exit 1

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}Error: Maven not found${NC}"
    echo "Please install Maven to run backend tests"
    exit 1
fi

echo "Running ChatService Error Handling Tests..."
if mvn test -Dtest=ChatServiceErrorHandlingTest -q; then
    echo -e "${GREEN}✓ Backend Tests Passed${NC}"
    BACKEND_PASSED=1
else
    echo -e "${RED}✗ Backend Tests Failed${NC}"
fi

# Generate coverage report
echo ""
echo "Generating coverage report..."
mvn test jacoco:report -q || true

cd ..

# ==========================================
# Summary
# ==========================================
echo ""
echo "=========================================="
echo "Test Execution Summary"
echo "=========================================="
echo ""

if [ $AI_SERVICE_PASSED -eq 1 ]; then
    echo -e "${GREEN}✓ AI Service Tests: PASSED${NC}"
else
    echo -e "${RED}✗ AI Service Tests: FAILED${NC}"
fi

if [ $FRONTEND_PASSED -eq 1 ]; then
    echo -e "${GREEN}✓ Frontend Tests: PASSED${NC}"
else
    echo -e "${RED}✗ Frontend Tests: FAILED${NC}"
fi

if [ $BACKEND_PASSED -eq 1 ]; then
    echo -e "${GREEN}✓ Backend Tests: PASSED${NC}"
else
    echo -e "${RED}✗ Backend Tests: FAILED${NC}"
fi

echo ""
echo "Coverage Reports:"
echo "  - AI Service: vietnam_history_dataset/htmlcov/index.html"
echo "  - Frontend: FE_HistoryMind_AI/coverage/index.html"
echo "  - Backend: BE_HistoryMind_AI/target/site/jacoco/index.html"
echo ""

# Exit with error if any tests failed
if [ $AI_SERVICE_PASSED -eq 0 ] || [ $FRONTEND_PASSED -eq 0 ] || [ $BACKEND_PASSED -eq 0 ]; then
    echo -e "${RED}Some tests failed. Please review the output above.${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed successfully!${NC}"
    exit 0
fi
