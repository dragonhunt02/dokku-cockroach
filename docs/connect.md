You can also pass additional arguments to `cockroach sql` console

```shell
# Example to allow 'DROP DATABASE...' and similar unsafe operations
dokku postgres:connect lollipop --safe-updates=false
```
