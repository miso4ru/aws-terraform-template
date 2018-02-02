# aws-terraform-template

## 設計方針
- ディレクトリ階層毎にtfstateを分離
- グローバル/リージョン/環境 で3階層
- IPアドレスなどの全階層共通変数はvariables.tfに記載, symlinkで階層間を共有
- AWSのARNやIDなどのAWSリソース情報はoutput, terraform_remote_stateを利用して階層間で共有
- tfstateはs3管理, Backend S3を用いて同アカウントのs3にtfstateを保存

## ディレクトリ構成

階層
```
.
|-- <region>
|   |-- <environment>
|   |   |-- <environment-resources>.tf         ... 環境毎のリソースを定義する (S3/CloudFront/EC2/S3/ElastiCache/RDS)
|   |   |-- remote_state.tf
|   |   |-- output.tf
|   |   |-- terraform.tf
|   |   `-- variables.tf -> ../../variables.tf
|   |
|   |-- <region-resources>.tf                  ... 全環境共通リソースを定義する(vpc, sg)
|   |-- remote_state.tf
|   |-- output.tf
|   |-- terraform.tf
|   `-- variables.tf -> ../variables.tf
|
|-- <global-resouces>.tf                       ... iam等 全リージョン、全環境共通リソースを定義する
|-- output.tf
|-- remote_state.tf
|-- terraform.tf
`-- variables.tf
```

各ディレクトリに配置するファイルについて
```
./
|-- <resouces>.tf     ... 同階層に記載するAWSリソースを定義する,名前は任意
|-- output.tf         ... 別階層から参照する情報をouputに記載, 別階層のremote_state.tfから読み取る
|-- remote_state.tf   ... 別階層のtfstateに記載されている情報を参照
|-- terraform.tf      ... 同ディレクトリのterraform設定を記載(backend s3)
`-- variables.tf      ... 全環境共通の変数
```


## VPC Subnet設計
### Region
リージョン間VPNを貼る可能性を踏まえ、CIDRが被らないよう設計する

| region         | IPv4 CIDR    |
| :---           | :----        |
| ap-northeast-1 | 10.0.0.0/16  |
| other          | 10.xx.0.0/16 |

### 広域サブネット
/23割り * AZ (1AZ 507台)  
1AZに500台以上作成する可能性がある場合、maskを広げて設計する。

| name        | masks | use                                                      |
| :---        | :---- | :------------------------------------------------------  |
| public-*    | /23   | PublicIPを付与するEC2用                                  |
| protected-* | /23   | 主に直接通信不要のEC2に利用 NAT-Gatwayを経由してOutBound通信可 |
| private-*   | /23   | 外部通信不要なEC2, RDS, ElastiCache等に利用              |

### 特殊サブネット
/25割り * AZ (1AZ 123台まで)  

| name | masks | use             |
| :--- | :---- | :-------------  |
| lb-*   | /25   | ELB, ALBに利用  |
| nat-*  | /25   | NAT-Gateway専用 |

