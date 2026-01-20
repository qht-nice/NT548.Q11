# Lab1 (Terraform)

Tài liệu này hướng dẫn chạy phần Terraform của Lab1 để tạo hạ tầng AWS gồm: **VPC**, **Public/Private Subnet**, **Internet Gateway**, **NAT Gateway**, **Route Tables**, **Security Groups**, và **2 EC2 instances** (1 public, 1 private).

## Yêu cầu
- **Terraform** (khuyến nghị 1.3+)
- **AWS CLI** (v2+), và bạn đã đăng nhập AWS (ví dụ dùng `aws configure` hoặc credentials của lab)

## Cấu hình quan trọng trước khi chạy
- **Region**: theo cấu hình trong `main.tf` (repo đang dùng `ap-southeast-2`)
- **KeyPair**: EC2 dùng key pair có sẵn (ví dụ `vockey` theo lab)
- **IP được phép SSH vào public EC2**: cấu hình qua biến `allowed_ssh_ip` (dạng `/32`)

Lấy IP public nhanh:

```bash
echo "$(curl -s https://checkip.amazonaws.com)/32"
```

## Cách chạy
1) Vào thư mục Terraform:

```bash
cd Lab1/terraform
```

2) (Khuyến nghị) tạo/sửa `terraform.tfvars` để giới hạn SSH:

```hcl
allowed_ssh_ip = "<YOUR_PUBLIC_IP/32>"
```

3) Triển khai:

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

## Gợi ý kiểm tra sau khi apply
- Dùng `terraform output` để lấy `public_instance_public_ip` và thử SSH vào public instance.
- Từ public instance, SSH tiếp vào private instance bằng private IP.




