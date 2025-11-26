# NT548.P11

## Hướng Dẫn Thiết Lập Hạ Tầng AWS Bằng CloudFormation

### Mô tả

Sử dụng Terraform để triển khai hạ tầng AWS với các thành phần chính như sau:

_VPC_: Tạo VPC với Public Subnet (kết nối Internet) và Private Subnet (sử dụng NAT Gateway). Bao gồm Internet Gateway và Default Security Group.

_Route Tables_: Cấu hình Public Route Table cho lưu lượng Internet qua Internet Gateway và Private Route Table cho lưu lượng qua NAT Gateway.

_NAT Gateway_: Cho phép kết nối Internet cho tài nguyên trong Private Subnet với tính bảo mật.

_EC2 Instances_: Tạo Public EC2 Instance có thể truy cập từ Internet và Private EC2 Instance chỉ có thể truy cập từ Public EC2 Instance. Các Instance này sử dụng một cặp khóa RSA để có thể truy cập vào.

_Security Groups_: Kiểm soát lưu lượng vào/ra cho các EC2 Instances với Public Security Group cho phép kết nối SSH từ IP cụ thể và Private Security Group cho phép kết nối từ Public EC2 Instance.

### Yêu cầu

Trước khi bắt đầu triển khai hạ tầng trên AWS bằng Terraform, cần chuẩn bị các tài nguyên:

_AWS account: để có thể tạo các tài nguyên

_AWS CLI_: Cài đặt AWS Command Line Interface (CLI) từ trang chủ AWS CLI để tương tác với AWS từ dòng lệnh.

_IAM (Identity and Access Management)_: Là dịch vụ của AWS cho phép quản lý quyền truy cập vào các dịch vụ và tài nguyên của AWS.

_File yaml đã cấu hình với tất cả các tài nguyên cần thiết.

## Các bước triển khai
### Cách 1: Sử dụng AWS Management Console
Bước 1: Chuẩn bị tệp YAML
Tạo một tệp YAML duy nhất (ví dụ: group_19.yml) với tất cả các tài nguyên trong đó (VPC, Subnets, Route Tables, NAT Gateway, EC2 Instances, và Security Groups).

Bước 2: Triển khai CloudFormation Stack
- Mở AWS Management Console.

- Vào phần CloudFormation và chọn Create Stack.

- Chọn phương thức Upload a template file, và tải tệp main.yml lên.

- Chọn Next và nhập các giá trị tham số đầu vào (VD: IP của bạn cho phép SSH, KeyPair, CIDR blocks).

- Tiếp tục các bước theo hướng dẫn và triển khai stack.

Bước 3: Kiểm tra kết quả
- Sau khi stack được tạo thành công, bạn có thể kiểm tra thông tin đầu ra trong phần Outputs của CloudFormation Stack, ví dụ như các Instance ID, VPC ID.

- Truy cập vào instance Public qua SSH từ địa chỉ IP của bạn.

- Từ instance Public, bạn có thể truy cập vào instance Private thông qua SSH.

### Cách 2: Sử dụng AWS CLI
Bước 1: Cấu hình AWS CLI
    Trước khi thực hiện triển khai CloudFormation, bạn cần cấu hình AWS CLI để sử dụng đúng thông tin tài khoản và vùng (region).

`aws configure --profile terraform-user`
    
    Điền các thông tin sau:
        _AWS Access Key ID_: Nhập Access Key của người dùng IAM.
        _AWS Secret Access Key_: Nhập Secret Key của người dùng IAM.
        _Default region name_: Nhập vùng (region) mà ta muốn sử dụng, ví dụ: us-east-1.
        _Default output format_: Chọn định dạng đầu ra, có thể để trống hoặc nhập json.

Bước 2: Tạo CloudFormation Stack
    Sau khi đã cấu hình AWS CLI, triển khai tệp YAML bằng lệnh aws cloudformation create-stack. 

    aws cloudformation create-stack \
    --stack-name <TênStack> \
    --template-body file://<ĐườngDẫnTớiTệpYaml> \
    --parameters ParameterKey=MyIPAddress,ParameterValue=<ĐịaChỉIP>,ParameterKey=KeyPairName,ParameterValue=<TênKeyPair> \
    --capabilities CAPABILITY_NAMED_IAM

* --stack-name: Tên của stack mà bạn muốn tạo.
* --template-body: Đường dẫn tới tệp YAML mà bạn đã tạo (sử dụng file:// trước đường dẫn).
* --parameters: Các tham số đầu vào cho tệp YAML, chẳng hạn như IP SSH, tên cặp khóa.
* --capabilities CAPABILITY_NAMED_IAM: Cho phép CloudFormation tạo tài nguyên có các quyền IAM (nếu cần thiết).

Bước 3: Kiểm tra trạng thái của Stack
    Sau khi chạy lệnh trên, bạn có thể kiểm tra trạng thái của stack để xem quá trình triển khai có thành công không

`aws cloudformation describe-stacks --stack-name <TênStack>`

Lệnh này sẽ trả về thông tin chi tiết về stack, bao gồm trạng thái hiện tại (CREATE_IN_PROGRESS, CREATE_COMPLETE, CREATE_FAILED, v.v.).
Bước 4: Kiểm tra đầu ra của Stack
Để kiểm tra các giá trị đầu ra (Outputs) của stack, sử dụng lệnh

`aws cloudformation describe-stacks --stack-name <TênStack> --query "Stacks[0].Outputs"`

Lệnh này sẽ trả về các giá trị đầu ra được định nghĩa trong phần Outputs của tệp YAML, chẳng hạn như ID của các EC2 instance hoặc VPC.

### Lưu ý 
    -Chỉ cho phép IP của bạn hoặc một dải IP xác định có thể SSH vào instance Public.
    -Instance Private chỉ có thể truy cập được từ instance Public, đảm bảo tính bảo mật cho các tài nguyên bên trong subnet Private.  



    




