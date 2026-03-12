# Vol.7 Solution (Packages & Archives)

## 任务 1: 解救旧代码
**命令:**
```bash
tar -xzvf legacy_code.tar.gz
```
**解析:**
`x` 表示解包 (extract)，`z` 表示解压 gzip 格式，`v` 显示详细信息，`f` 指定文件名。这是最常用的解压命令。

## 任务 2: 备份配置文件
**命令:**
```bash
tar -czvf config_backup.tar.gz config/
```
**解析:**
`c` 表示创建包 (create)，`z` 表示使用 gzip 压缩，`v` 显示详细信息，`f` 指定文件名。最后加上要备份的目录名。

## 任务 3: 跨平台压缩
**命令:**
```bash
zip -r logs.zip logs/
```
**解析:**
`zip` 命令用于创建 .zip 文件。由于我们压缩的是一个目录，必须加上 `-r` (recursive) 参数来递归包含其中的文件。

## 避坑指南
*   **文件名位置**: `tar` 命令中 `-f` 后面必须紧跟文件名，不能写成 `-cfvz config.tar.gz`（这会被解释为文件名为 `v`）。
*   **绝对路径**: 打包时尽量不要使用绝对路径（如 `/etc/config/`），否则解压时可能会覆盖系统文件。最好先 `cd` 到目录下再打包相对路径。
