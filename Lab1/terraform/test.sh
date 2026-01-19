#!/bin/bash

set +e

PASS=0
FAIL=0

check() {
  name="$1"
  cmd="$2"
  echo -n "- $name: "
  eval "$cmd" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "PASS"
    PASS=$((PASS+1))
  else
    echo "FAIL"
    FAIL=$((FAIL+1))
  fi
}

if [ ! -d .terraform ]; then
  terraform init >/dev/null
fi

echo "=== Terraform outputs ==="
VPC_ID=$(terraform output -raw vpc_id)
PUBLIC_SUBNET_ID=$(terraform output -raw public_subnet_id)
PRIVATE_SUBNET_ID=$(terraform output -raw private_subnet_id)
IGW_ID=$(terraform output -raw internet_gateway_id)
NAT_GW_ID=$(terraform output -raw nat_gateway_id)
PUBLIC_SG_ID=$(terraform output -raw public_security_group_id)
PRIVATE_SG_ID=$(terraform output -raw private_security_group_id)
PUBLIC_INSTANCE_ID=$(terraform output -raw public_instance_id)
PRIVATE_INSTANCE_ID=$(terraform output -raw private_instance_id)
PUBLIC_INSTANCE_IP=$(terraform output -raw public_instance_public_ip)
PRIVATE_INSTANCE_IP=$(terraform output -raw private_instance_private_ip)

echo "VPC_ID=$VPC_ID"
echo "PUBLIC_INSTANCE_IP=$PUBLIC_INSTANCE_IP"
echo "PRIVATE_INSTANCE_IP=$PRIVATE_INSTANCE_IP"
echo ""

echo "=== VPC/Subnet/IGW/NAT ==="
check "VPC exists" "aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs[0].VpcId' --output text"
check "Public subnet exists" "aws ec2 describe-subnets --subnet-ids $PUBLIC_SUBNET_ID --query 'Subnets[0].SubnetId' --output text"
check "Private subnet exists" "aws ec2 describe-subnets --subnet-ids $PRIVATE_SUBNET_ID --query 'Subnets[0].SubnetId' --output text"
check "IGW exists" "aws ec2 describe-internet-gateways --internet-gateway-ids $IGW_ID --query 'InternetGateways[0].InternetGatewayId' --output text"
check "NAT exists" "aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_ID --query 'NatGateways[0].NatGatewayId' --output text"

echo ""
echo "=== Route tables ==="
PUBLIC_RT_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.subnet-id,Values=$PUBLIC_SUBNET_ID" --query 'RouteTables[0].RouteTableId' --output text 2>/dev/null)
PRIVATE_RT_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.subnet-id,Values=$PRIVATE_SUBNET_ID" --query 'RouteTables[0].RouteTableId' --output text 2>/dev/null)
check "Public route table exists" "[ -n \"$PUBLIC_RT_ID\" ]"
check "Private route table exists" "[ -n \"$PRIVATE_RT_ID\" ]"

echo ""
echo "=== Security groups ==="
check "Public SG exists" "aws ec2 describe-security-groups --group-ids $PUBLIC_SG_ID --query 'SecurityGroups[0].GroupId' --output text"
check "Private SG exists" "aws ec2 describe-security-groups --group-ids $PRIVATE_SG_ID --query 'SecurityGroups[0].GroupId' --output text"

echo ""
echo "=== EC2 instances ==="
check "Public instance exists" "aws ec2 describe-instances --instance-ids $PUBLIC_INSTANCE_ID --query 'Reservations[0].Instances[0].InstanceId' --output text"
check "Private instance exists" "aws ec2 describe-instances --instance-ids $PRIVATE_INSTANCE_ID --query 'Reservations[0].Instances[0].InstanceId' --output text"
check "Public instance has public IP" "[ -n \"$PUBLIC_INSTANCE_IP\" ]"

echo ""
echo "=== Summary ==="
echo "PASS=$PASS FAIL=$FAIL"
if [ $FAIL -eq 0 ]; then
  exit 0
else
  exit 1
fi
