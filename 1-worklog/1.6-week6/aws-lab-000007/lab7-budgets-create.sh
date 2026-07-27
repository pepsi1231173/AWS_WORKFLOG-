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

echo "=== LAB7 CREATE AWS BUDGETS account=${ACCOUNT_ID} region=${REGION} prefix=${PREFIX} ==="
for name in "${NAMES[@]}"; do
  aws budgets delete-budget --account-id "${ACCOUNT_ID}" --budget-name "${name}" --region "${REGION}" >/dev/null 2>&1 || true
done

cat > /tmp/lab7-template-cost.json <<JSON
{"BudgetName":"${PREFIX}-TemplateCost","BudgetLimit":{"Amount":"5","Unit":"USD"},"CostTypes":{"IncludeCredit":true,"IncludeDiscount":true,"IncludeOtherSubscription":true,"IncludeRecurring":true,"IncludeRefund":true,"IncludeSubscription":true,"IncludeSupport":true,"IncludeTax":true,"IncludeUpfront":true,"UseBlended":false},"TimeUnit":"MONTHLY","BudgetType":"COST"}
JSON
cat > /tmp/lab7-cost-monthly.json <<JSON
{"BudgetName":"${PREFIX}-CostMonthly","BudgetLimit":{"Amount":"10","Unit":"USD"},"CostTypes":{"IncludeCredit":true,"IncludeDiscount":true,"IncludeOtherSubscription":true,"IncludeRecurring":true,"IncludeRefund":true,"IncludeSubscription":true,"IncludeSupport":true,"IncludeTax":true,"IncludeUpfront":true,"UseBlended":false},"TimeUnit":"MONTHLY","BudgetType":"COST"}
JSON
cat > /tmp/lab7-usage-ec2.json <<JSON
{"BudgetName":"${PREFIX}-UsageEC2Hours","BudgetLimit":{"Amount":"10","Unit":"Hrs"},"CostFilters":{"UsageTypeGroup":["EC2: Running Hours"]},"TimeUnit":"MONTHLY","BudgetType":"USAGE"}
JSON
cat > /tmp/lab7-ri.json <<JSON
{"BudgetName":"${PREFIX}-RIUtilization","BudgetLimit":{"Amount":"100","Unit":"PERCENTAGE"},"CostFilters":{"Service":["Amazon Elastic Compute Cloud - Compute"]},"TimeUnit":"MONTHLY","BudgetType":"RI_UTILIZATION"}
JSON
cat > /tmp/lab7-sp.json <<JSON
{"BudgetName":"${PREFIX}-SPUtilization","BudgetLimit":{"Amount":"100","Unit":"PERCENTAGE"},"TimeUnit":"MONTHLY","BudgetType":"SAVINGS_PLANS_UTILIZATION"}
JSON

create_budget() {
  local label="$1"
  local file="$2"
  echo "--- Creating ${label} ---"
  if aws budgets create-budget --account-id "${ACCOUNT_ID}" --budget "file://${file}" --region "${REGION}"; then
    echo "CREATED ${label}"
  else
    echo "FAILED ${label}"
  fi
}

create_budget "${PREFIX}-TemplateCost" /tmp/lab7-template-cost.json
create_budget "${PREFIX}-CostMonthly" /tmp/lab7-cost-monthly.json
create_budget "${PREFIX}-UsageEC2Hours" /tmp/lab7-usage-ec2.json
create_budget "${PREFIX}-RIUtilization" /tmp/lab7-ri.json
create_budget "${PREFIX}-SPUtilization" /tmp/lab7-sp.json

echo "=== LAB7 CREATED BUDGETS ==="
aws budgets describe-budgets --account-id "${ACCOUNT_ID}" --region "${REGION}" --query "Budgets[?contains(BudgetName, '${PREFIX}')].[BudgetName,BudgetType,BudgetLimit.Amount,BudgetLimit.Unit,TimeUnit]" --output table
echo "LAB7_CREATE_DONE ${PREFIX}"
