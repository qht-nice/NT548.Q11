## Giải thích sơ lược code (Lab1 + Lab2 Task1 + Lab2 Task2)

File này tóm tắt nhanh **mục đích các folder/file chính** và **luồng triển khai**.

---

### Lab1

#### 1) Terraform (`Lab1/terraform/`)
- **Mục tiêu**: Tạo hạ tầng AWS cơ bản (VPC + public/private subnet + IGW + NAT + route tables + security groups + EC2 public/private).
- **File chính**:
  - `Lab1/terraform/main.tf`: cấu hình provider, gọi các module, và định nghĩa outputs.
  - `Lab1/terraform/variables.tf`: biến đầu vào (CIDR, instance type, AMI, allowed_ssh_ip…).
  - `Lab1/terraform/terraform.tfvars`: giá trị override khi chạy thật (đặc biệt `allowed_ssh_ip`).
- **Modules**:
  - `Lab1/terraform/modules/vpc/`: tạo VPC, subnets, IGW, public route table + association.
  - `Lab1/terraform/modules/nat-gateway/`: tạo EIP + NAT Gateway, private route table + association.
  - `Lab1/terraform/modules/security-group/`: tạo SG cho public instance (SSH theo IP) và private instance (allow từ public SG theo port cần).
  - `Lab1/terraform/modules/ec2/`: tạo EC2 public/private, gán subnet + SG + keypair.
- **Test**:
  - `Lab1/terraform/test.sh`: script kiểm tra nhanh bằng terraform output + AWS CLI describe (PASS/FAIL).

#### 2) CloudFormation (`Lab1/cloudformation/`)
- **Mục tiêu**: Tương tự Terraform nhưng bằng CloudFormation.
- **File chính**:
  - `Lab1/cloudformation/group_18.yaml`: template tạo VPC/subnet/IGW/NAT/route tables/SG/EC2 + Outputs.
  - `Lab1/cloudformation/test.sh`: script đọc Outputs từ stack và kiểm tra bằng AWS CLI.

#### 3) Tài liệu
- `Lab1/RUNBOOK.md`: hướng dẫn người khác chạy lab (các chỗ **[CẦN THAY THẾ]**).
- `Lab1/TEST_CASES.md`: mô tả test cases và lệnh chạy.

---

### Lab2 - Task1 (Terraform + GitHub Actions + Checkov)

#### 1) Terraform (`Lab2/Task1/Terraform/`)
- **Mục tiêu**: Deploy hạ tầng AWS tương tự Lab1 bằng Terraform, có thể thêm hardening để pass Checkov (tuỳ policy/lab permission).
- **File chính**:
  - `Lab2/Task1/Terraform/main.tf`: provider + gọi modules + outputs.
  - `Lab2/Task1/Terraform/variables.tf`, `terraform.tfvars`: biến cấu hình (AMI, instance type, allowed_ssh_ip…).
- **Modules**:
  - `modules/vpc`, `modules/nat-gateway`, `modules/security-group`, `modules/ec2`: tương tự Lab1 nhưng có thể có thay đổi để phù hợp Checkov/lab.

#### 2) GitHub Actions
- `.github/workflows/deploy.yml`
  - **Mục tiêu**: CI/CD terraform (init/validate/plan/apply) và chạy Checkov scan.
  - **Chú ý VocLabs**: thường cần đủ 3 secrets:
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `AWS_SESSION_TOKEN`

---

### Lab2 - Task2 (CloudFormation + CodeCommit + CodePipeline + CodeBuild + cfn-lint + taskcat)

#### 1) Infra template
- `Lab2/Task2/group_18.yaml`
  - **Mục tiêu**: Tạo hạ tầng (VPC/subnets/IGW/NAT/route tables/SG/EC2) bằng CloudFormation.
  - **Parameters quan trọng**:
    - `AllowedSshCidr`: IP public dạng `/32`
    - `KeyName`: tên keypair phải tồn tại trong đúng region
    - `AmiId`: AMI dùng cho EC2 trong đúng region

#### 2) Pipeline template
- `Lab2/Task2/pipeline.yaml`
  - **Mục tiêu**: Tạo CodeCommit repo + artifact S3 + CodeBuild project + CodePipeline.
  - **Luồng**:
    - Source: CodeCommit (branch `main`)
    - Build: CodeBuild chạy `cfn-lint` và `taskcat`
    - Deploy: CloudFormation deploy `group_18.yaml` (stack `nt548-task2-infra`) và truyền parameter overrides để tránh lỗi KeyName/AMI.

#### 3) Buildspec + Taskcat config
- `Lab2/Task2/buildspec.yml`
  - Cài `cfn-lint` + `taskcat`
  - Lint template và chạy `taskcat` test.
- `Lab2/Task2/.taskcat.yml`
  - Định nghĩa region test và parameter default cho template khi taskcat deploy stack test.

#### 4) Tài liệu
- `Lab2/Task2/README.md`: hướng dẫn chạy Task2 và các file liên quan.

---

### Notes chung
- Region hiện đang cấu hình theo yêu cầu mới của lab (tuỳ thời điểm chỉnh), hãy kiểm tra trong:
  - Terraform provider `region = "..."`
  - lệnh AWS CLI `--region ...`
  - taskcat `regions: ...`
- Với tài khoản lab, lỗi hay gặp là **permission/quota** (ví dụ thiếu quyền IAM/CodeBuild hoặc quota VPC/IGW/EIP).


