# Hướng dẫn chạy Lab1 (Terraform + CloudFormation)


## Những chỗ cần thay

- **[CẦN THAY THẾ] YOUR_PUBLIC_IP_CIDR**: IP public của bạn dạng `/32` 
- **[CẦN THAY THẾ] KEY_PEM_PATH**: đường dẫn tới file key SSH của lab, ví dụ: `~/labsuser.pem`
- **[CẦN THAY THẾ] STACK_NAME** (CloudFormation): ví dụ `cfStack`

Thông tin đã cố định trong repo:
- **Region**: `ap-southeast-2`
- **KeyPairName** (AWS): `vockey`
- **AMI**: `ami-0ecb62995f68bb549`

---

## Chuẩn bị

- Cài sẵn **Terraform** và **AWS CLI**
- Set region dùng cho lab (đúng file đang cấu hình là `ap-southeast-2`):

```bash
aws configure set region ap-southeast-2
```

- Trên AWS có keypair tên **`vockey`**, và trên máy bạn có file private key tương ứng (ví dụ `labsuser.pem`).

---

## A) Terraform

### 1) Sửa IP cho SSH (Public SG)

Mở `Lab1/terraform/terraform.tfvars` và thay:

```hcl
allowed_ssh_ip = "[CẦN THAY THẾ] YOUR_PUBLIC_IP_CIDR"
```

Ví dụ:

```hcl
allowed_ssh_ip = "113.173.12.179/32"
```

### 2) Init / Plan / Apply

```bash
cd Lab1/terraform
terraform init
terraform plan
terraform apply
```

### 3) Lấy outputs (để SSH / test)

```bash
terraform output
```

### 4) Chạy test (Terraform)

```bash
cd Lab1/terraform
bash ./test.sh
```

### 5) SSH (tự test)

Public instance:

```bash
ssh -i [CẦN THAY THẾ] KEY_PEM_PATH ec2-user@$(terraform output -raw public_instance_public_ip)
```

Private instance (từ public instance, dùng private IP):

```bash
ssh -i [CẦN THAY THẾ] KEY_PEM_PATH ec2-user@$(terraform output -raw private_instance_private_ip)
```

### 6) Destroy (Terraform)

```bash
cd Lab1/terraform
terraform destroy
```

---

## B) CloudFormation

### 1) Sửa IP SSH trong template (quan trọng)

Trong `Lab1/cloudformation/group_18.yaml`, phần `PublicEC2SecurityGroup` có rule:

- `CidrIp: [CẦN THAY THẾ] YOUR_PUBLIC_IP_CIDR` (hiện tại trong repo đang là `113.173.12.179/32`)

Hãy sửa đúng IP `/32` của bạn.

### 2) Create stack

```bash
cd Lab1/cloudformation

aws cloudformation create-stack \
  --stack-name [CẦN THAY THẾ] STACK_NAME \
  --template-body file://group_18.yaml \
  --region ap-southeast-2
```

Nếu stack đã tồn tại, dùng update:

```bash
aws cloudformation update-stack \
  --stack-name [CẦN THAY THẾ] STACK_NAME \
  --template-body file://group_18.yaml \
  --region ap-southeast-2
```

### 3) Đợi stack xong

```bash
aws cloudformation describe-stacks \
  --stack-name [CẦN THAY THẾ] STACK_NAME \
  --region ap-southeast-2 \
  --query "Stacks[0].StackStatus" --output text
```

### 4) Xem Outputs

```bash
aws cloudformation describe-stacks \
  --stack-name [CẦN THAY THẾ] STACK_NAME \
  --region ap-southeast-2 \
  --query "Stacks[0].Outputs" --output table
```

### 5) Chạy test (CloudFormation)

```bash
cd Lab1/cloudformation
bash ./test.sh [CẦN THAY THẾ] STACK_NAME
```

### 6) Destroy (CloudFormation)

```bash
aws cloudformation delete-stack --stack-name [CẦN THAY THẾ] STACK_NAME --region ap-southeast-2
```

---

## Ghi chú nhanh

- **KeyName trong CloudFormation** đang set `vockey`. Bạn SSH bằng file private key tương ứng (ví dụ `labsuser.pem`).
- **Tên hiển thị EC2** (Name tag) trong CloudFormation:
  - `PublicEC2Instance`
  - `PrivateEC2Instance`

