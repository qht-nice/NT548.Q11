# NT548.P11

## Hướng Dẫn Thiết Lập Hạ Tầng AWS Bằng Terraform

### Mô tả

Sử dụng Terraform để triển khai hạ tầng AWS với các thành phần chính như sau:

_VPC_: Tạo VPC với Public Subnet (kết nối Internet) và Private Subnet (sử dụng NAT Gateway). Bao gồm Internet Gateway và Default Security Group.

_Route Tables_: Cấu hình Public Route Table cho lưu lượng Internet qua Internet Gateway và Private Route Table cho lưu lượng qua NAT Gateway.

_NAT Gateway_: Cho phép kết nối Internet cho tài nguyên trong Private Subnet với tính bảo mật.

_EC2 Instances_: Tạo Public EC2 Instance có thể truy cập từ Internet và Private EC2 Instance chỉ có thể truy cập từ Public EC2 Instance. Các Instance này sử dụng một cặp khóa RSA để có thể truy cập vào.

_Security Groups_: Kiểm soát lưu lượng vào/ra cho các EC2 Instances với Public Security Group cho phép kết nối SSH từ IP cụ thể và Private Security Group cho phép kết nối từ Public EC2 Instance.

### Yêu cầu

Trước khi bắt đầu triển khai hạ tầng trên AWS bằng Terraform, cần chuẩn bị các tài nguyên:

_Terraform_: Cài đặt Terraform từ trang chủ Terraform nếu chưa cài đặt. Đảm bảo sử dụng phiên bản từ 1.3.0 trở lên.

_AWS CLI_: Cài đặt AWS Command Line Interface (CLI) từ trang chủ AWS CLI để tương tác với AWS từ dòng lệnh.

_IAM (Identity and Access Management)_: Là dịch vụ của AWS cho phép quản lý quyền truy cập vào các dịch vụ và tài nguyên của AWS.

### Các bước triển khai

- Tạo user IAM:

    Trong AWS Management Console, truy cập vào phần IAM để tạo một user mới.

    Tạo một người dùng IAM mới và cấp quyền phù hợp (ở đây ta cấp quyền AdministratorAccess).

    Tạo và lưu Access Key và Secret Key cho user mới này.

- Cấu Hình Tài Khoản profile Bằng AWS CLI:

    Mở terminal hoặc command prompt và chạy lệnh sau để cấu hình profile cho user IAM: 

    `aws configure --profile terraform-user`

    Điền các thông tin sau:

        _AWS Access Key ID_: Nhập Access Key của người dùng IAM.
        _AWS Secret Access Key_: Nhập Secret Key của người dùng IAM.
        _Default region name_: Nhập vùng (region) mà ta muốn sử dụng, ví dụ: us-east-1.
        _Default output format_: Chọn định dạng đầu ra, có thể để trống hoặc nhập json.

    Để kiểm tra cấu hình của profile AWS CLI, sử dụng lệnh

    `aws configure list --profile terraform-user`


- Clone project về và điều hướng vào thư mục chứa file [**main.tf**](./main.tf).

- Thực hiện lần lượt các lệnh sau:

    `terraform init`: Lệnh bắt buộc cần thực hiện đầu tiên để khởi tạo một Terraform Project.

    `terraform validate`: Sẽ tiến hành kiểm tra tất cả các Terraform configuration để đảm bảo rằng toàn bộ syntax đều chính xác. Thường sử dụng sau khi configuration files được sửa chữa để kiểm tra hợp lệ.

    `terraform plan`: Hiển thị ra những resource nào sẽ được tạo và kiểm tra lỗi syntax.

    `terraform apply`: Triển khai các resource được tạo trong plan. Khi chạy câu lệnh apply, thì terraform sẽ chạy lại câu lệnh plan, và sẽ hiện ra một thông báo để xác nhận tạo resource. Gõ 'yes' để tạo các resource sau khi đã kiểm tra.

    `terraform destroy`: là lệnh dùng destroy tất cả resource.

### Lưu ý

Sau khi triển khai các resource bằng lệnh `terraform plan`, đăng nhập AWS để kiểm tra các resource vừa tạo và trạng thái của chúng.

Sau lưu khóa RSA được tạo ra từ [**main.tf**](./main.tf) để có thể truy cập vào các instance EC2.




