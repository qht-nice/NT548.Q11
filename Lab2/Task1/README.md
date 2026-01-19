#Task1

## Hướng dẫn triển khai hạ tầng AWS sử dụng Terraform và tự động hóa quy trình với GitHub Actions

## Yêu cầu hệ thống

### Công cụ cần cài đặt
- **Terraform**: [Tải xuống tại đây](https://developer.hashicorp.com/terraform/downloads) (phiên bản 1.5 trở lên).
- **AWS CLI**: [Tải xuống tại đây](https://aws.amazon.com/cli/) (phiên bản 2 trở lên).
- **Git**: Để quản lý mã nguồn.
- **Tài khoản AWS** với quyền quản trị.

### Các thành phần cần chuẩn bị
- Repository GitHub chứa mã nguồn Terraform.
- Secrets GitHub Actions:
  - `AWS_ACCESS_KEY_ID`: Access Key ID.
  - `AWS_SECRET_ACCESS_KEY`: Secret Access Key.
  - `AWS_SESSION_TOKEN`: Session Token (đặc biệt cần cho tài khoản lab).

## Những chỗ cần thay trước khi chạy

- **[CẦN THAY THẾ] IP SSH của bạn**: cập nhật biến `allowed_ssh_ip` (dạng `/32`, ví dụ `1.2.3.4/32`)
- **Region**: đang dùng `us-east-1`

### Các bước triển khai

- Tạo file pipeline 

    Tạo thư mục .github/workflows trong repository của bạn.

    Tạo file deploy.yml

- Cấu hình GitHub Secrets

    Truy cập Settings của repository.

    Chọn Secrets and variables > Actions > New repository secret.

    Thêm 3 secrets:
        AWS_ACCESS_KEY_ID: Access Key ID.
        AWS_SECRET_ACCESS_KEY: Secret Access Key.
        AWS_SESSION_TOKEN: Session Token (lab).

- Triển khai hạ tầng với Terraform

    Đảm bảo thư mục Terraform nằm ở đúng chỗ: `Lab2/Task1/Terraform`

## Chạy thủ công (local)

1) Vào thư mục Terraform:

```bash
cd Lab2/Task1/Terraform
```

2) Set IP được phép SSH (public SG):

Tạo/sửa `terraform.tfvars`:

```hcl
allowed_ssh_ip = "[CẦN THAY THẾ] YOUR_PUBLIC_IP/32"
```

3) Chạy Terraform:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Destroy:

```bash
terraform destroy
```

## Chạy tự động (GitHub Actions)

- Workflow: `.github/workflows/deploy.yml`
- Workflow sẽ chạy khi bạn **push lên nhánh `main`**
- Workflow có các bước:
  - Checkov scan thư mục `Lab2/Task1/Terraform`
  - terraform init/validate/plan/apply trên đúng thư mục `Lab2/Task1/Terraform`

    Chạy pipeline

        Đẩy mã nguồn lên nhánh main:

            _git add .
            _git commit -m "Add Terraform CI/CD pipeline"_: 
            _git push origin main_: 

    Truy cập tab Actions trên GitHub để xem tiến trình chạy pipeline.

- Kiểm tra kết quả triển khai

    Truy cập AWS

        Đăng nhập AWS Management Console

        Kiểm tra tài nguyên đã được tạo
    
    Xem kết quả trên GitHub Actions

        Vào Actions trên GitHub repository

        Chọn workflow vừa chạy để xem log chi tiết
            


