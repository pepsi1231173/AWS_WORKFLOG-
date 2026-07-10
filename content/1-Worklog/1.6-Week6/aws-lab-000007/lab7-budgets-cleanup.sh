#!/usr/bin/env bash
set -u
AWS_PAGER=""
REGION="us-east-1"
PREFIX="LAB7-0704"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
NAMES=(
  "${PREFIX}-TemplateCost"
  "${PREFIX}-CostMonthly"
  "${PREFIX}-UsageEC2Hours"
  "${PREFIX}-RIUtilization"
  "${PREFIX}-SPUtilization"
)

echo "=== LAB7 CLEANUP AWS BUDGETS account=${ACCOUNT_ID} region=${REGION} prefix=${PREFIX} ==="
for name in "${NAMES[@]}"; do
  echo "Deleting ${name}"
  aws budgets delete-budget --account-id "${ACCOUNT_ID}" --budget-name "${name}" --region "${REGION}" >/dev/null 2>&1 || true
done

echo "=== LAB7 CLEANUP VERIFY ==="
aws budgets describe-budgets --account-id "${ACCOUNT_ID}" --region "${REGION}" --query "Budgets[?contains(BudgetName, '${PREFIX}')].[BudgetName,BudgetType]" --output table
echo "LAB7_CLEANUP_DONE ${PREFIX}"
