# Test Cases cho Lab1 Infrastructure

Tài liệu này mô tả các test cases để kiểm tra từng dịch vụ được triển khai thành công trong Lab1.

## Tổng quan

Lab1 bao gồm 2 phương thức triển khai:
- **Terraform**: Triển khai infrastructure bằng Terraform
- **CloudFormation**: Triển khai infrastructure bằng CloudFormation

Mỗi phương thức đều có script test tự động để kiểm tra các thành phần.

## Test Cases

### Test Case 1: VPC Resources (3 điểm)

#### 1.1 VPC tồn tại
- **Mô tả**: Kiểm tra VPC đã được tạo thành công
- **Kiểm tra**: VPC ID tồn tại và có thể query được
- **Expected**: VPC ID hợp lệ

#### 1.2 VPC CIDR Block
- **Mô tả**: Kiểm tra CIDR block của VPC
- **Kiểm tra**: CIDR block phải là `10.0.0.0/16`
- **Expected**: `10.0.0.0/16`

#### 1.3 VPC DNS Settings (CloudFormation only)
- **Mô tả**: Kiểm tra DNS support và DNS hostnames được bật
- **Kiểm tra**: `EnableDnsSupport` và `EnableDnsHostnames` phải là `true`
- **Expected**: Cả hai đều là `true`

---

### Test Case 2: Subnets (3 điểm)

#### 2.1 Public Subnet tồn tại
- **Mô tả**: Kiểm tra Public Subnet đã được tạo
- **Kiểm tra**: Public Subnet ID tồn tại
- **Expected**: Subnet ID hợp lệ

#### 2.2 Private Subnet tồn tại
- **Mô tả**: Kiểm tra Private Subnet đã được tạo
- **Kiểm tra**: Private Subnet ID tồn tại
- **Expected**: Subnet ID hợp lệ

#### 2.3 Public Subnet CIDR Block
- **Mô tả**: Kiểm tra CIDR block của Public Subnet
- **Kiểm tra**: CIDR block phải là `10.0.1.0/24`
- **Expected**: `10.0.1.0/24`

#### 2.4 Private Subnet CIDR Block
- **Mô tả**: Kiểm tra CIDR block của Private Subnet
- **Kiểm tra**: CIDR block phải là `10.0.2.0/24`
- **Expected**: `10.0.2.0/24`

#### 2.5 Public Subnet MapPublicIpOnLaunch (CloudFormation)
- **Mô tả**: Kiểm tra Public Subnet có tự động gán public IP
- **Kiểm tra**: `MapPublicIpOnLaunch` phải là `true`
- **Expected**: `true`

---

### Test Case 3: Internet Gateway (3 điểm)

#### 3.1 Internet Gateway tồn tại
- **Mô tả**: Kiểm tra Internet Gateway đã được tạo
- **Kiểm tra**: Internet Gateway ID tồn tại
- **Expected**: Internet Gateway ID hợp lệ

#### 3.2 Internet Gateway attached to VPC
- **Mô tả**: Kiểm tra Internet Gateway đã được gắn vào VPC
- **Kiểm tra**: Internet Gateway phải attached với VPC ID đúng
- **Expected**: Attachment state là `available`

---

### Test Case 4: NAT Gateway (1 điểm)

#### 4.1 NAT Gateway tồn tại
- **Mô tả**: Kiểm tra NAT Gateway đã được tạo
- **Kiểm tra**: NAT Gateway ID tồn tại
- **Expected**: NAT Gateway ID hợp lệ

#### 4.2 NAT Gateway State
- **Mô tả**: Kiểm tra NAT Gateway đã sẵn sàng
- **Kiểm tra**: State phải là `available`
- **Expected**: `available`

#### 4.3 NAT Gateway trong Public Subnet
- **Mô tả**: Kiểm tra NAT Gateway được đặt trong Public Subnet
- **Kiểm tra**: NAT Gateway Subnet ID phải match với Public Subnet ID
- **Expected**: Subnet ID khớp

---

### Test Case 5: Route Tables (2 điểm)

#### 5.1 Public Route Table tồn tại
- **Mô tả**: Kiểm tra Public Route Table đã được tạo
- **Kiểm tra**: Route Table ID tồn tại và associated với Public Subnet
- **Expected**: Route Table ID hợp lệ

#### 5.2 Public Route Table routes to Internet Gateway
- **Mô tả**: Kiểm tra Public Route Table có route đến Internet Gateway
- **Kiểm tra**: Route table có route `0.0.0.0/0` đi qua Internet Gateway
- **Expected**: Route tồn tại với gateway ID đúng

#### 5.3 Private Route Table tồn tại
- **Mô tả**: Kiểm tra Private Route Table đã được tạo
- **Kiểm tra**: Route Table ID tồn tại và associated với Private Subnet
- **Expected**: Route Table ID hợp lệ

#### 5.4 Private Route Table routes to NAT Gateway
- **Mô tả**: Kiểm tra Private Route Table có route đến NAT Gateway
- **Kiểm tra**: Route table có route `0.0.0.0/0` đi qua NAT Gateway
- **Expected**: Route tồn tại với NAT Gateway ID đúng

---

### Test Case 6: Security Groups (2 điểm)

#### 6.1 Public Security Group tồn tại
- **Mô tả**: Kiểm tra Public Security Group đã được tạo
- **Kiểm tra**: Security Group ID tồn tại
- **Expected**: Security Group ID hợp lệ

#### 6.2 Public Security Group allows SSH
- **Mô tả**: Kiểm tra Public Security Group cho phép SSH (port 22)
- **Kiểm tra**: Ingress rule cho port 22 tồn tại
- **Expected**: Rule tồn tại với port 22

#### 6.3 Public Security Group restricts SSH to specific IP
- **Mô tả**: Kiểm tra Public Security Group chỉ cho phép SSH từ IP cụ thể
- **Kiểm tra**: SSH ingress rule phải có CIDR block là `/32` (specific IP)
- **Expected**: CIDR block là `/32`

#### 6.4 Private Security Group tồn tại
- **Mô tả**: Kiểm tra Private Security Group đã được tạo
- **Kiểm tra**: Security Group ID tồn tại
- **Expected**: Security Group ID hợp lệ

#### 6.5 Private Security Group allows SSH from Public SG
- **Mô tả**: Kiểm tra Private Security Group cho phép SSH từ Public Security Group
- **Kiểm tra**: Ingress rule cho port 22 với source là Public Security Group
- **Expected**: Rule tồn tại với source security group đúng

---

### Test Case 7: EC2 Instances (2 điểm)

#### 7.1 Public Instance tồn tại
- **Mô tả**: Kiểm tra Public EC2 Instance đã được tạo
- **Kiểm tra**: Instance ID tồn tại
- **Expected**: Instance ID hợp lệ

#### 7.2 Public Instance State
- **Mô tả**: Kiểm tra Public Instance đang chạy
- **Kiểm tra**: Instance state phải là `running`
- **Expected**: `running`

#### 7.3 Public Instance có Public IP
- **Mô tả**: Kiểm tra Public Instance có public IP address
- **Kiểm tra**: Public IP address không rỗng
- **Expected**: Public IP address tồn tại

#### 7.4 Public Instance trong Public Subnet
- **Mô tả**: Kiểm tra Public Instance được đặt trong Public Subnet
- **Kiểm tra**: Instance Subnet ID phải match với Public Subnet ID
- **Expected**: Subnet ID khớp

#### 7.5 Public Instance sử dụng Public Security Group
- **Mô tả**: Kiểm tra Public Instance sử dụng đúng Security Group
- **Kiểm tra**: Instance Security Group ID phải match với Public Security Group ID
- **Expected**: Security Group ID khớp

#### 7.6 Private Instance tồn tại
- **Mô tả**: Kiểm tra Private EC2 Instance đã được tạo
- **Kiểm tra**: Instance ID tồn tại
- **Expected**: Instance ID hợp lệ

#### 7.7 Private Instance State
- **Mô tả**: Kiểm tra Private Instance đang chạy
- **Kiểm tra**: Instance state phải là `running`
- **Expected**: `running`

#### 7.8 Private Instance trong Private Subnet
- **Mô tả**: Kiểm tra Private Instance được đặt trong Private Subnet
- **Kiểm tra**: Instance Subnet ID phải match với Private Subnet ID
- **Expected**: Subnet ID khớp

#### 7.9 Private Instance sử dụng Private Security Group
- **Mô tả**: Kiểm tra Private Instance sử dụng đúng Security Group
- **Kiểm tra**: Instance Security Group ID phải match với Private Security Group ID
- **Expected**: Security Group ID khớp

#### 7.10 Private Instance không có Public IP
- **Mô tả**: Kiểm tra Private Instance không có public IP address
- **Kiểm tra**: Public IP address phải là `None` hoặc rỗng
- **Expected**: Không có public IP

---

### Test Case 8: Default Security Group (CloudFormation only)

#### 8.1 Default Security Group tồn tại
- **Mô tả**: Kiểm tra Default Security Group đã được tạo
- **Kiểm tra**: Security Group với tên "DefaultSecurityGroup" tồn tại
- **Expected**: Security Group ID hợp lệ

---

### Test Case 9: Connectivity Tests (Manual)

#### 9.1 Public Instance Internet Connectivity
- **Mô tả**: Kiểm tra Public Instance có thể truy cập Internet
- **Cách test**: SSH vào Public Instance và chạy:
  ```bash
  curl -I https://www.google.com
  ping -c 3 8.8.8.8
  ```
- **Expected**: Kết nối thành công

#### 9.2 Private Instance NAT Connectivity
- **Mô tả**: Kiểm tra Private Instance có thể truy cập Internet qua NAT Gateway
- **Cách test**: 
  1. SSH vào Public Instance
  2. Từ Public Instance, SSH vào Private Instance
  3. Trong Private Instance, chạy:
     ```bash
     curl -I https://www.google.com
     ping -c 3 8.8.8.8
     ```
- **Expected**: Kết nối thành công qua NAT Gateway

#### 9.3 SSH từ Internet vào Public Instance
- **Mô tả**: Kiểm tra có thể SSH vào Public Instance từ Internet
- **Cách test**: Từ máy local (IP đã được cấu hình trong Security Group):
  ```bash
  ssh -i <key-file> ec2-user@<public-instance-ip>
  ```
- **Expected**: SSH thành công

#### 9.4 SSH từ Public Instance vào Private Instance
- **Mô tả**: Kiểm tra có thể SSH từ Public Instance vào Private Instance
- **Cách test**: Từ Public Instance:
  ```bash
  ssh -i <key-file> ec2-user@<private-instance-private-ip>
  ```
- **Expected**: SSH thành công

---

## Cách chạy Test Scripts

### Terraform Tests

```bash
cd Lab1/terraform

# Đảm bảo infrastructure đã được deploy
terraform init
terraform plan
terraform apply

# Chạy test script
./test.sh
```

### CloudFormation Tests

```bash
cd Lab1/cloudformation

# Đảm bảo stack đã được deploy
aws cloudformation create-stack \
  --stack-name MyVPCStack \
  --template-body file://group_18.yaml \
  --region us-east-1

# Chờ stack tạo xong, sau đó chạy test
./test.sh MyVPCStack
```

## Kết quả mong đợi

Sau khi chạy test scripts, bạn sẽ thấy:
- ✓ PASSED: Test case đã pass
- ✗ FAILED: Test case đã fail

Tất cả các test cases tự động phải PASSED để đảm bảo infrastructure được triển khai đúng.

## Lưu ý

1. **Manual Tests**: Một số test cases (connectivity tests) cần được thực hiện thủ công vì yêu cầu SSH vào instances.

2. **IP Address**: Đảm bảo IP address trong Security Group được cấu hình đúng với IP public của bạn.

3. **Key Pair**: Đảm bảo bạn có key pair đúng để SSH vào instances.

4. **Region**: Scripts mặc định sử dụng region `us-east-1`. Nếu bạn dùng region khác, cần cập nhật trong scripts hoặc set environment variable `AWS_DEFAULT_REGION`.

5. **AWS Credentials**: Đảm bảo AWS credentials đã được cấu hình đúng (`aws configure`) và có quyền đọc (`Describe*`) để chạy test scripts.

