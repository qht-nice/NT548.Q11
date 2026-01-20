# NT548.Q11 — Hướng dẫn cài môi trường, chạy triển khai và kiểm tra kết quả

Repo chứa các bài Lab triển khai hạ tầng AWS bằng **Terraform** và **CloudFormation**, kèm pipeline/CI cho Lab2.

## 1) Yêu cầu môi trường (Windows)

### 1.1. Công cụ cần cài
- **Git**
- **AWS CLI v2**
- **Terraform**
- **Python 3.11+** (để chạy `cfn-lint`, `taskcat`)
- **Bash shell** để chạy `test.sh`
  - Khuyến nghị: **Git Bash** hoặc **WSL**

### 1.2. Cấu hình AWS credentials/region
- Thiết lập credentials cho AWS CLI (một trong các cách):
  - `aws configure` (Access key/Secret key/Region)
  - hoặc export environment variables theo môi trường lab (nếu có SessionToken)
- Xác nhận đăng nhập:

```bash
aws sts get-caller-identity
```

- Xác nhận region đang dùng (tuỳ bài lab có thể yêu cầu region khác):

```bash
aws configure get region
```

> Lưu ý: các lệnh trong repo thường dùng `--region ...`. Nếu không truyền `--region`, AWS CLI sẽ dùng region mặc định trong cấu hình.

## 2) Cách chạy mã nguồn (triển khai hạ tầng)

### 2.1. Lab1 — Terraform (`Lab1/terraform`)
**Mục tiêu**: tạo VPC + public/private subnet + IGW + NAT + route tables + security groups + EC2 public/private.

#### Bước 1 — Cập nhật IP SSH
Sửa `Lab1/terraform/terraform.tfvars`:
- `allowed_ssh_ip` đặt theo IP public dạng `/32` (ví dụ `1.2.3.4/32`)

#### Bước 2 — Init/Plan/Apply

```bash
cd Lab1/terraform
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -auto-approve -var-file="terraform.tfvars"
```

#### Bước 3 — Lấy output

```bash
cd Lab1/terraform
terraform output
```

#### Bước 4 — Chạy test script (PASS/FAIL)
Chạy bằng Git Bash/WSL:

```bash
cd Lab1/terraform
chmod +x test.sh
./test.sh
```

#### Dọn dẹp

```bash
cd Lab1/terraform
terraform destroy -auto-approve -var-file="terraform.tfvars"
```

---

### 2.2. Lab1 — CloudFormation (`Lab1/cloudformation`)
**Mục tiêu**: triển khai kiến trúc tương tự Terraform bằng CloudFormation.

#### Bước 1 — Cập nhật IP SSH trong template
Sửa `Lab1/cloudformation/group_18.yaml` tại resource `PublicEC2SecurityGroup`:
- `CidrIp` đặt theo IP public dạng `/32`

#### Bước 2 — Deploy stack

```bash
cd Lab1/cloudformation
aws cloudformation deploy --stack-name cfStack --template-file group_18.yaml --region ap-southeast-1
```

> Nếu region khác, thay `--region ...` theo môi trường đang dùng.

#### Bước 3 — Xem Outputs

```bash
aws cloudformation describe-stacks --stack-name cfStack --region ap-southeast-1 --query "Stacks[0].Outputs"
```

#### Bước 4 — Chạy test script (PASS/FAIL)
Chạy bằng Git Bash/WSL:

```bash
cd Lab1/cloudformation
chmod +x test.sh
./test.sh cfStack
```

#### Dọn dẹp

```bash
aws cloudformation delete-stack --stack-name cfStack --region ap-southeast-1
aws cloudformation wait stack-delete-complete --stack-name cfStack --region ap-southeast-1
```

---

### 2.3. Lab2 — Task1 (`Lab2/Task1`)
**Mục tiêu**: Terraform + CI (GitHub Actions) + Checkov scan.

- Cấu hình chạy tay: xem `Lab2/Task1/README.md` (Terraform apply tương tự Lab1).
- Cấu hình CI: workflow nằm ở `.github/workflows/deploy.yml`.
  - Với môi trường VocLabs thường cần đủ secrets:
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `AWS_SESSION_TOKEN`

---

### 2.4. Lab2 — Task2 (`Lab2/Task2`)
**Mục tiêu**: CloudFormation + CodeCommit + CodePipeline + CodeBuild (cfn-lint + taskcat).

- Hướng dẫn chi tiết: `Lab2/Task2/README.md`
- Các file quan trọng:
  - `pipeline.yaml`: dựng CodeCommit/CodeBuild/CodePipeline và deploy infra template
  - `buildspec.yml`: chạy `cfn-lint` và `taskcat`
  - `.taskcat.yml`: cấu hình region/template/parameters cho taskcat

## 3) Cách kiểm tra kết quả triển khai

### 3.1. Kiểm tra nhanh bằng script (PASS/FAIL)
- Terraform: `Lab1/terraform/test.sh`
- CloudFormation: `Lab1/cloudformation/test.sh`

Hai script kiểm tra bằng AWS CLI `describe-*` để xác nhận:
- VPC/Subnet/IGW/NAT tồn tại
- Route table được associate đúng subnet
- Security groups tồn tại
- EC2 instances tồn tại và public instance có public IP

### 3.2. Kiểm tra qua Outputs
- Terraform:

```bash
cd Lab1/terraform
terraform output
```

- CloudFormation:

```bash
aws cloudformation describe-stacks --stack-name <STACK_NAME> --region <REGION> --query "Stacks[0].Outputs"
```

### 3.3. Kiểm tra thủ công (tuỳ chọn)
- SSH vào public instance (cần đúng KeyPair + AllowedSshCidr):

```bash
ssh -i <KEY_FILE.pem> ec2-user@<PUBLIC_INSTANCE_IP>
```

- Từ public instance, SSH sang private instance bằng private IP:

```bash
ssh -i <KEY_FILE.pem> ec2-user@<PRIVATE_INSTANCE_PRIVATE_IP>
```

## 4) Tài liệu tham khảo trong repo
- `CODE_OVERVIEW.md`: tóm tắt mục đích các folder/file và luồng triển khai
- `Lab1/RUNBOOK.md`: hướng dẫn chạy Lab1 (các chỗ cần thay thế IP/stack name/key path)
- `Lab1/TEST_CASES.md`: mô tả test cases và kỳ vọng kiểm thử


