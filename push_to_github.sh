#!/bin/bash
# ── Config ────────────────────────────────────────────────
GITHUB_TOKEN="YOUR_NEW_TOKEN_HERE"
GITHUB_USER="Udiation"
REPO_NAME="manufacturing-failure-prediction"
# ─────────────────────────────────────────────────────────

echo "Creating GitHub repo..."
curl -s -X POST https://api.github.com/user/repos \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"Containerized ML pipeline: XGBoost + MLflow + FastAPI + Docker Compose\",\"private\":false}"

echo ""
echo "Initializing git and pushing..."

git init
git add .
git commit -m "Initial commit: XGBoost + MLflow + FastAPI + Docker Compose pipeline"
git branch -M main
git remote add origin https://$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git
git push -u origin main

echo ""
echo "Done! Visit: https://github.com/$GITHUB_USER/$REPO_NAME"
