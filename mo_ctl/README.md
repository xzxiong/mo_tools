# mo-ctl
mo部署，管理工具

## Command tracelog

- `$ mo-ctl tracelog --help`
```txt
Help to create external tables in target mo cluster, that helps to access others mo cluster's logs/metrics info.

Usage:
  mo-ctl tracelog [flags]

Flags:
      --access-key-id string       AWS bucket (required)
      --bucket string              AWS bucket (required)
      --db string                  target MO cluster Database name (required)
      --endpoint string            AWS endpoint (required)
      --example                    show cmd example
  -h, --help                       help for tracelog
      --host string                target MO cluster Host (default "127.0.0.1")
      --old-schema                 use old schema. you can see the diffs with '--show' flag
  -p, --password string            target MO cluster password
      --path-prefix string         AWS bucket (required)
  -P, --post int                   target MO cluster post (default 6001)
      --provider string            type of storage, val in [s3, minio] (default "s3")
      --region string              AWS region (required)
      --secret-access-key string   AWS bucket (required)
      --show                       show all sql will exec
      --timeout int                access MO cluster timeout (seconds)
  -u, --user string                target MO cluster user (required) (default "test")
```
- got example `./mo-ctl tracelog --example`
```shell
$ ./mo-ctl tracelog --example
example:
  ./mo-ctl tracelog --host "127.0.0.1" -P 6001 -udump -p "111" --db "test" \
	--endpoint "s3.us-west-2.amazonaws.com" --region "us-west-2" --bucket "bucket_name" \
	--access-key-id "I0AM0AWS0KEY0ID00000" --secret-access-key "0IAM0AWS0SECRET0KEY000000000000000000000" \
	--path-prefix "mo-data/etl" --provider "s3"
```
- result got those tables and views
```
mysql> use test;
Database changed
mysql> show tables;
+-----------------+
| Tables_in_test  |
+-----------------+
| metric          |
| statement_info  |
| rawlog          |
| log_info        |
| span_info       |
| error_info      |
+-----------------+
6 rows in set (0.01 sec)
```
- md5sum
```
4f8c951dfaaf8863f364f3857170a9b7  mo-ctl.linux      // Linux
ca49d1ccf3c7ef21efe49fda05c11b34  mo-ctl.mac.intel  // macOS Intel
70a933c6b6e8142f4a1f5ba61eb9cfb4  mo-ctl.mac.m1     // macOS Apple Silicon
```
