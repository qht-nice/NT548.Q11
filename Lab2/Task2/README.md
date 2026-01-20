## Lab2 - Task 2

Triển khai hạ tầng AWS bằng **CloudFormation** và tự động hoá **build + deploy** bằng **AWS CodePipeline** (source từ **CodeCommit**) và **CodeBuild** (tích hợp `cfn-lint` + `taskcat`).

> Ghi chú: với một số tài khoản lab/VocLabs, quyền tạo CodeBuild có thể bị chặn. Nếu gặp lỗi `AccessDenied` khi tạo CodeBuild, bạn vẫn có thể:
> - Chạy `cfn-lint` / `taskcat` trên máy local để lấy log cho báo cáo
> - Dùng CodePipeline + CloudFormation deploy (không có stage CodeBuild) tuỳ theo quyền trong lab

### Các file chính
- **`Lab2/Task2/group_18.yaml`**: template CloudFormation tạo VPC + public/private subnet + IGW + NAT + route tables + SG + EC2.
- **`Lab2/Task2/buildspec.yml`**: CodeBuild chạy `cfn-lint` và `taskcat`.
- **`Lab2/Task2/.taskcat.yml`**: cấu hình taskcat (region `ap-southeast-2`).
- **`Lab2/Task2/pipeline.yaml`**: template **full flow** (CodeCommit + CodeBuild + CodePipeline + deploy).

### Cấu hình quan trọng trước khi chạy
- **Region**: dùng `ap-southeast-2`
- **AllowedSshCidr** (SSH vào public EC2): IP public của bạn dạng `/32` (ví dụ `1.2.3.4/32`)
- **KeyPair (KeyName)**: dùng key pair **đã tồn tại** trong region (thường là `vockey`, hoặc key bạn tự tạo)
- **AmiId**: AMI phải đúng region `ap-southeast-2` (repo đang dùng `ami-0b8d527345fdace59`)

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

- Clone repo CodeCommit bằng URL ở bước (2)
- Copy toàn bộ repo hiện tại (có `Lab2/Task2/...`) vào, commit và push lên `main`.

4) Vào AWS Console → **CodePipeline** → chọn pipeline → xem các stage:
- **Source**: lấy code từ CodeCommit
- **Build**: chạy `cfn-lint` + `taskcat` theo `Lab2/Task2/buildspec.yml`
- **Deploy**: deploy template infra `Lab2/Task2/group_18.yaml`

> Lưu ý: `pipeline.yaml` hiện có `ParameterOverrides` để truyền `KeyName`, `AmiId`, `AllowedSshCidr` xuống stack infra. Nếu bạn đổi key/AMI/IP, hãy update các tham số `DeployKeyName`, `DeployAmiId`, `DeployAllowedSshCidr` khi tạo/update stack pipeline.

---

### B) Deploy hạ tầng CloudFormation (chạy tay – để test nhanh)

```bash
aws cloudformation create-stack \
  --region ap-southeast-2 \
  --stack-name nt548-task2-infra \
  --template-body file://Lab2/Task2/group_18.yaml \
  --parameters \
    ParameterKey=AllowedSshCidr,ParameterValue="<YOUR_PUBLIC_IP/32>" \
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

### E) Upgrade AWS CLI (nếu cần)

> Upgrade AWS CLI **không** vượt qua được policy “explicit deny”, nhưng giúp tránh lỗi version/cfn-lint/taskcat trên máy.

Kiểm tra version:

```bash
aws --version
```