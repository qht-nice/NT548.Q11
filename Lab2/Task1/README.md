# Lab2 - Task 1

Triển khai hạ tầng AWS bằng **Terraform** (VPC, subnets public/private, IGW, NAT, route tables, EC2, security groups) và tự động hoá deploy bằng **GitHub Actions**, kèm **Checkov** để scan bảo mật IaC.

## Yêu cầu
- **Terraform** (khuyến nghị 1.5+)
- **AWS CLI** (v2+)
- **Git**

Nếu chạy bằng GitHub Actions, repo cần có 3 secrets (đặc biệt với tài khoản lab/VocLabs):
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN`

## Cấu hình quan trọng trước khi chạy
- **Region**: cấu hình hiện tại dùng `ap-southeast-2`
- **IP được phép SSH vào public EC2**: điền vào biến `allowed_ssh_ip` theo dạng `/32` (ví dụ `1.2.3.4/32`)

Bạn có thể lấy IP public nhanh như sau:

```bash
echo "$(curl -s https://checkip.amazonaws.com)/32"
```

## Chạy thủ công (local)
1) Vào thư mục Terraform:

```bash
cd Lab2/Task1/Terraform
```

2) Tạo/sửa `terraform.tfvars` để giới hạn SSH:

```hcl
allowed_ssh_ip = "<YOUR_PUBLIC_IP/32>"
```

3) Chạy Terraform:

```bash
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```

4) Huỷ tài nguyên (khi cần):

```bash
terraform destroy --auto-approve
```

## Chạy tự động (GitHub Actions)
- Workflow nằm ở: `.github/workflows/deploy.yml`
- Workflow chạy khi bạn **push lên nhánh `main`**
- Các bước chính:
  - **Checkov** scan thư mục `Lab2/Task1/Terraform`
  - **terraform init / validate / plan / apply** trong `Lab2/Task1/Terraform`

Để trigger workflow:

```bash
git add .
git commit -m "Update Task1"
git push origin main
```

Theo dõi kết quả ở tab **Actions** của GitHub repo.
