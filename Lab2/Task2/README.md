## Lab2 - Task 2

Triển khai hạ tầng AWS bằng **CloudFormation** và tự động hoá **build + deploy** bằng **AWS CodePipeline** (source từ **CodeCommit**) và **CodeBuild** (tích hợp `cfn-lint` + `taskcat`).

> Lưu ý (VocLabs/lab): một số môi trường có thể chặn quyền tạo CodeBuild. Khi gặp `AccessDenied`, có thể chuyển sang chạy `cfn-lint`/`taskcat` local và deploy CloudFormation thủ công để lấy log báo cáo.

### Các file chính
- **`Lab2/Task2/group_18.yaml`**: template CloudFormation tạo VPC + public/private subnet + IGW + NAT + route tables + SG + EC2.
- **`Lab2/Task2/buildspec.yml`**: CodeBuild chạy `cfn-lint` và `taskcat`.
- **`Lab2/Task2/.taskcat.yml`**: cấu hình taskcat (region `ap-southeast-2`).
- **`Lab2/Task2/pipeline.yaml`**: template **full flow** (CodeCommit + CodeBuild + CodePipeline + deploy).

### Cấu hình quan trọng trước khi chạy
- **Region**: `ap-southeast-2`
- **AllowedSshCidr**: CIDR được phép SSH vào public EC2 (khuyến nghị IP public dạng `/32`, ví dụ `1.2.3.4/32`)
- **KeyName**: EC2 KeyPair phải **tồn tại** trong region (ví dụ `vockey`)
- **AmiId**: AMI phải đúng region `ap-southeast-2` (mặc định: `ami-0b8d527345fdace59`)

Lấy IP public nhanh:

```bash
echo "$(curl -s https://checkip.amazonaws.com)/32"
```

---

### A) Tạo CodePipeline (tự động build + deploy)

1) Deploy stack pipeline:

```bash
aws cloudformation create-stack \
  --region ap-southeast-2 \
  --stack-name nt548-task2-pipeline \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://Lab2/Task2/pipeline.yaml
```

Chờ stack tạo xong:

```bash
aws cloudformation wait stack-create-complete --region ap-southeast-2 --stack-name nt548-task2-pipeline
```

2) Lấy URL CodeCommit để clone:

```bash
aws cloudformation describe-stacks \
  --region ap-southeast-2 \
  --stack-name nt548-task2-pipeline \
  --query "Stacks[0].Outputs[?OutputKey=='RepositoryCloneUrlHttp'].OutputValue" \
  --output text
```

3) Push source lên CodeCommit (branch `main`) để trigger pipeline:

- Clone repo CodeCommit bằng URL ở bước (2).
- Copy toàn bộ repo hiện tại (có `Lab2/Task2/...`) vào, commit và push lên `main`.

4) Vào AWS Console → **CodePipeline** → chọn pipeline → xem các stage:
- **Source**: lấy code từ CodeCommit
- **Build**: chạy `cfn-lint` + `taskcat` theo `Lab2/Task2/buildspec.yml`
- **Deploy**: deploy template infra `Lab2/Task2/group_18.yaml`

> Lưu ý: `pipeline.yaml` dùng `ParameterOverrides` để truyền `KeyName`, `AmiId`, `AllowedSshCidr` xuống stack infra. Khi thay đổi key/AMI/IP, cần cập nhật các tham số `DeployKeyName`, `DeployAmiId`, `DeployAllowedSshCidr` khi tạo/update stack pipeline.

---

### B) Deploy hạ tầng CloudFormation (chạy tay – để test nhanh)

```bash
aws cloudformation create-stack \
  --region ap-southeast-2 \
  --stack-name nt548-task2-infra \
  --template-body file://Lab2/Task2/group_18.yaml \
  --parameters \
    ParameterKey=AllowedSshCidr,ParameterValue="<PUBLIC_IP/32>" \
    ParameterKey=KeyName,ParameterValue="vockey" \
    ParameterKey=AmiId,ParameterValue="ami-0b8d527345fdace59" \
  --capabilities CAPABILITY_NAMED_IAM
```

Xem output:

```bash
aws cloudformation describe-stacks \
  --region ap-southeast-2 \
  --stack-name nt548-task2-infra \
  --query "Stacks[0].Outputs" \
  --output table
```

---

### C) Chạy `cfn-lint` / `taskcat` local (để chụp log báo cáo)

```bash
pip install --user cfn-lint taskcat
~/.local/bin/cfn-lint -t Lab2/Task2/group_18.yaml
~/.local/bin/taskcat test run -c Lab2/Task2/.taskcat.yml
```

---

### D) Upgrade AWS CLI (nếu cần)

Kiểm tra version:

```bash
aws --version
```