#!/usr/bin/env bash
set -euo pipefail

REGION="$1"
TG_ARN="$2"
MYSQL_ID="$3"
WEB_IDS="$4"
ANSIBLE_DIR="$5"

ALL_INSTANCES="$MYSQL_ID $WEB_IDS"

echo "==> Waiting for EC2 instances to be RUNNING..."
for id in $ALL_INSTANCES; do
  echo " - $id"
  aws ec2 wait instance-running \
    --region "$REGION" \
    --instance-ids "$id"
done
echo "✓ All instances are running"

echo "==> Waiting for SSM to be ONLINE..."
for id in $ALL_INSTANCES; do
  echo " - $id"
  for i in $(seq 1 90); do
    STATUS=$(aws ssm describe-instance-information \
      --region "$REGION" \
      --filters Key=InstanceIds,Values="$id" \
      --query "InstanceInformationList[0].PingStatus" \
      --output text 2>/dev/null || true)

    if [[ "$STATUS" == "Online" ]]; then
      echo "   ✓ $id Online"
      break
    fi

    sleep 10
    if [[ "$i" == "90" ]]; then
      echo "❌ ERROR: $id never became Online in SSM"
      exit 2
    fi
  done
done
echo "✓ All instances Online in SSM"

echo "==> Running Ansible..."
cd "$ANSIBLE_DIR"
ansible-playbook -i inventory.ini wordpress.yml

echo "==> Waiting for Target Group to become healthy..."
for i in $(seq 1 60); do
  STATES=$(aws elbv2 describe-target-health \
    --region "$REGION" \
    --target-group-arn "$TG_ARN" \
    --query "TargetHealthDescriptions[].TargetHealth.State" \
    --output text || true)

  if [[ -n "$STATES" ]] && ! echo "$STATES" | grep -vq healthy; then
    echo "✓ Target Group healthy: $STATES"
    exit 0
  fi

  echo "   ... TG states: ${STATES:-none}"
  sleep 10
done

echo "❌ Target Group not healthy after Ansible"
aws elbv2 describe-target-health \
  --region "$REGION" \
  --target-group-arn "$TG_ARN" \
  --output table
exit 3
