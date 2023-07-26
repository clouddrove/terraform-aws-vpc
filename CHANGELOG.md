# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2023-07-26
### :sparkles: New Features
- [`02502c0`](https://github.com/clouddrove/terraform-aws-vpc/commit/02502c0e86dfb8a7fd1366462aed27e796c3acf0) - update workfflows and readme.yaml *(PR [#53](https://github.com/clouddrove/terraform-aws-vpc/pull/53) by [@theprashantyadav](https://github.com/theprashantyadav))*
- [`16ad441`](https://github.com/clouddrove/terraform-aws-vpc/commit/16ad4418a97cb8fc83144cb7f9dbdd51eb779e34) - Updated resources to be dynamic and added support for flow logs to be published in cloudwatch *(commit by [@13archit](https://github.com/13archit))*
- [`25f99bd`](https://github.com/clouddrove/terraform-aws-vpc/commit/25f99bd53cc6c051b785636572e5add5f7097d01) - Added cloudwatch resource *(commit by [@13archit](https://github.com/13archit))*
- [`95a1a68`](https://github.com/clouddrove/terraform-aws-vpc/commit/95a1a68e3020612551124370fa1daa67bb433131) - Added test example and modified main.tf *(commit by [@13archit](https://github.com/13archit))*

### :bug: Bug Fixes
- [`309542d`](https://github.com/clouddrove/terraform-aws-vpc/commit/309542de7735f506d4dccd1246f550e76f384a9c) - Fixed kms key policy and updated example folder *(commit by [@13archit](https://github.com/13archit))*
- [`a0ac339`](https://github.com/clouddrove/terraform-aws-vpc/commit/a0ac3394317c253c34e86ba9e609bddb6a1f4f85) - Fixed vulnerabilities *(commit by [@13archit](https://github.com/13archit))*
- [`9537489`](https://github.com/clouddrove/terraform-aws-vpc/commit/953748945e248044656093e1a23a6b942fbb7396) - Updated comments and example folder heirarchy *(commit by [@13archit](https://github.com/13archit))*
- [`6bb0fb9`](https://github.com/clouddrove/terraform-aws-vpc/commit/6bb0fb9e1ace6efc68c7ba9bfbc07c8a07728eae) - Fixed directory in workflows *(commit by [@13archit](https://github.com/13archit))*
- [`b59d760`](https://github.com/clouddrove/terraform-aws-vpc/commit/b59d7606d93713fafeb9dfe194c7110351787183) - Fixed _example/complete and dependabot.yml *(commit by [@13archit](https://github.com/13archit))*
- [`8e70e44`](https://github.com/clouddrove/terraform-aws-vpc/commit/8e70e44c180d62937d158c9750279fec18f965c2) - Added ignore for vpc flow log error because it enabled via separate resource *(commit by [@13archit](https://github.com/13archit))*
- [`b07fc3c`](https://github.com/clouddrove/terraform-aws-vpc/commit/b07fc3ce14059898ab2336f6f87c522c8873b074) - updated github actions *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*

### :memo: Documentation Changes
- [`baa9f10`](https://github.com/clouddrove/terraform-aws-vpc/commit/baa9f1089b3d2ccacf9339104762e32d274fc3b3) - update CHANGELOG.md for 1.3.1 *(commit by [@clouddrove-ci](https://github.com/clouddrove-ci))*


## [1.3.1] - 2023-05-31
### :sparkles: New Features
- [`6f2735f`](https://github.com/clouddrove/terraform-aws-vpc/commit/6f2735fa5657122dd4c6e61375d38073ba6f4ceb) - updated tfsec.yml file *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`fcf15d1`](https://github.com/clouddrove/terraform-aws-vpc/commit/fcf15d1e75c6b7f44ba5a8d2742586b21c293375) - updated changelog.yml name *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`6793df2`](https://github.com/clouddrove/terraform-aws-vpc/commit/6793df265367191319be1c3b2946f8c11d823510) - updated changelog.yml name and file *(commit by [@vibhutigoyal](https://github.com/vibhutigoyal))*
- [`0df9c4d`](https://github.com/clouddrove/terraform-aws-vpc/commit/0df9c4d9c34598f500340ea99f509ce4c83b4a49) - add deepsource & added assignees,reviewer in dependabot *(commit by [@Tanveer143s](https://github.com/Tanveer143s))*


## [v1.3.0] - 2022-12-28
### :bug: Bug Fixes
- [`da3fdc9`](https://github.com/clouddrove/terraform-aws-vpc/commit/da3fdc9fbcde60c8f07cf3235ddb0b1f73842a0c) - Updated terraform versions.
- [`7c0caf6`](https://github.com/clouddrove/terraform-aws-vpc/commit/7c0caf63f0f61b1e80632e89cedbf6e1d6097362) - fix lables tag.
- [`18ca74f`](https://github.com/clouddrove/terraform-aws-vpc/commit/18ca74f3b0d938b776f865a12b882f62edba5f09) -update workflows


## [v0.15.1] - 2022-05-3
### :bug: Bug Fixes
- [`18ca74f`](https://github.com/clouddrove/terraform-aws-vpc/commit/18ca74f3b0d938b776f865a12b882f62edba5f09) - Updated README.md


## [v0.15.0] - 2021-07-9
### :sparkles: New Features
- [`e674ac1`](https://github.com/clouddrove/terraform-aws-vpc/commit/e674ac11ea5342e2b4adb38bd962e2712d8a411d) - added ipv4 ipam pool feature

### :bug: Bug Fixes
- [`6cd4741`](https://github.com/clouddrove/terraform-aws-vpc/commit/6cd47412dab4d85edac36299760ee646d70e64ab) - update github action version


## [v0.14.0] - 2021-05-10
### :sparkles: New Features
- [`58693eb`](https://github.com/clouddrove/terraform-aws-vpc/commit/58693eb3bb1232481489abdac86d9ba4550e62fa) - restricts the default security

### :bug: Bug Fixes
- [`167ad38`](https://github.com/clouddrove/terraform-aws-vpc/commit/167ad38200cb8bdbef0915eb42c3d49637d352c9) - fix terratest
- [`904a689`](https://github.com/clouddrove/terraform-aws-vpc/commit/904a689009ad57a6c387b5d64e9d62a6b844fd01) - update lables variable
- [`673b395`](https://github.com/clouddrove/terraform-aws-vpc/commit/673b395b0fd32f52ddf863e70606d666179a1c41) - fix github action
- [`abe6771`](https://github.com/clouddrove/terraform-aws-vpc/commit/abe6771dc9a7b0f5240410de909723f17e8af317) - upgrade module to terraform 0.14


## [v0.13.0] - 2020-10-21
### :bug: Bug Fixes
- [`f53a689`](https://github.com/clouddrove/terraform-aws-vpc/commit/f53a689d8e20141a9dc990ced179bac4ae4bf278) - change tag name in main.tf


## [v0.12.5] - 2020-03-30
### :bug: Bug Fixes
- [`4448833`](https://github.com/clouddrove/terraform-aws-vpc/commit/44488334cf3b066e938e00eb54e5785614751e9d) - update terratest pipeline
- [`b0de455`](https://github.com/clouddrove/terraform-aws-vpc/commit/b0de45544932e1029e2e69c3db6f0a5baac589a1) - add pre-commit


## [v0.12.4] - 2019-12-27
### :bug: Bug Fixes
- [`f0a4833`](https://github.com/clouddrove/terraform-aws-vpc/commit/f0a483382fbe78c420f05b88b5dcefb7399060b2) - update github action


## [v0.12.3] - 2019-09-24
### :bug: Bug Fixes
- [`3381ea4`](https://github.com/clouddrove/terraform-aws-vpc/commit/3381ea41a43776e49f4abd3f86634afc408d93cd) - fix the igw tag


## [v0.12.2] - 2019-09-14
### :bug: Bug Fixes
- [`fad5b32`](https://github.com/clouddrove/terraform-aws-vpc/commit/fad5b325d7aa929c8e07a4a414697c1f753bdcd8) - change output syntax


## [v0.12.1] - 2019-09-05
### :bug: Bug Fixes
- [`5c9fc8e`](https://github.com/clouddrove/terraform-aws-vpc/commit/5c9fc8e74bf9b6b96a1bead95a18d9bb77fa257d) - fix the tags for eks


## [v0.12.0] - 2019-08-12
### :bug: Bug Fixes
- [`7cb99d0`](https://github.com/clouddrove/terraform-aws-vpc/commit/7cb99d03bdbb9f608afee9a729bb083d0eb6c3b2) - update url


## [v0.11.0] - 2019-08-12
### :bug: Bug Fixes
- [`c10254f`](https://github.com/clouddrove/terraform-aws-vpc/commit/c10254fb4700118ff31244ab49470bf0a985a6a7) - terraform 0.12.0


[v0.11.0]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.11.0...master
[v0.12.0]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.11.0...0.12.0
[v0.12.1]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.12.0...0.12.1
[v0.12.2]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.12.1...0.12.2
[v0.12.3]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.12.2...0.12.3
[v0.12.4]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.12.3...0.12.4
[v0.12.5]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.12.4...0.12.5
[v0.13.0]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.12.5...0.13.0
[v0.14.0]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.13.0...0.14.0
[v0.15.0]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.14.0...0.15.0
[v0.15.1]: https://github.com/clouddrove/terraform-aws-vpc/compare/0.15.0...0.15.1
[v1.3.0]:  https://github.com/clouddrove/terraform-aws-vpc/compare/0.15.1...1.3.0
[1.3.1]: https://github.com/clouddrove/terraform-aws-vpc/compare/1.3.0...1.3.1
[2.0.0]: https://github.com/clouddrove/terraform-aws-vpc/compare/1.3.1...2.0.0