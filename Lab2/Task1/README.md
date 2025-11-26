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
  - `AWS_ACCESS_KEY`: Khóa truy cập AWS.
  - `AWS_SECRET_ACCESS_KEY`: Khóa bí mật AWS.

### Các bước triển khai

- Tạo file pipeline 

    Tạo thư mục .github/workflows trong repository của bạn.

    Tạo file deploy.yml

- Cấu hình GitHub Secrets

    Truy cập Settings của repository.

    Chọn Secrets and variables > Actions > New repository secret.

    Thêm hai secrets:
        AWS_ACCESS_KEY: Khóa truy cập AWS.
        AWS_SECRET_ACCESS_KEY: Khóa bí mật AWS.

- Triển khai hạ tầng với Terraform

    Đảm bảo thư mục Terraform nằm ở đúng chỗ

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
            


