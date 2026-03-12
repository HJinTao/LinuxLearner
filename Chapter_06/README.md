# Chapter 06: 权限堡垒 (Permissions)

## 1. 实战背景 (The Pain Point)

你刚写好一个自动化部署脚本 `deploy.sh`，兴冲冲地输入 `./deploy.sh` 准备上线，结果终端冷冷地回了一句：
`bash: ./deploy.sh: Permission denied`

或者，当你试图连接服务器时，SSH 客户端报错：
`WARNING: UNPROTECTED PRIVATE KEY FILE!`

这些都是 Linux 权限体系在“保护”你。Linux 是一个多用户系统，每个文件都有严格的“身份”和“权限”控制。不懂权限，你在 Linux 世界将寸步难行。

## 2. 核心工具箱 (The Toolkit)

### 2.1 权限解读 (`ls -l`)
在 `ls -l` 的输出中，第一列由 10 个字符组成（例如 `-rwxr-xr-x`）：

*   **第 1 位**: 文件类型。
    *   `-`: 普通文件。
    *   `d`: 目录 (Directory)。
    *   `l`: 软链接 (Link)。
*   **第 2-4 位**: **Owner** (所有者) 的权限。
*   **第 5-7 位**: **Group** (所属组) 的权限。
*   **第 8-10 位**: **Others** (其他人) 的权限。

**权限位含义**:
*   `r` (Read):
    *   **文件**: 可以查看内容 (`cat`)。
    *   **目录**: 可以列出文件名 (`ls`)。
*   `w` (Write):
    *   **文件**: 可以修改内容。
    *   **目录**: 可以**创建、删除**目录下的文件（哪怕你没有文件的写权限！）。
*   `x` (Execute):
    *   **文件**: 可以作为程序运行 (`./script.sh`)。
    *   **目录**: 可以**进入**目录 (`cd`)。**这是新手最容易忽略的！如果目录没有 x 权限，你甚至无法查看里面文件的详细信息。**

### 2.2 `chmod` - 修改权限 (Change Mode)
语法: `chmod [who][op][perm] 文件名` 或 `chmod [数字] 文件名`

**数字表示法 (推荐)**:
权限可以用数字之和表示：
*   `r` = 4
*   `w` = 2
*   `x` = 1
*   `-` = 0

**常见组合**:
*   **777** (rwxrwxrwx): **极度危险**。任何人都可读写执行。除非你在调试且知道自己在做什么，否则**禁止使用**。
*   **755** (rwxr-xr-x): **脚本/程序标准权限**。
    *   Owner: rwx (全权)
    *   Group: r-x (读+执行)
    *   Others: r-x (读+执行)
*   **644** (rw-r--r--): **配置文件/网页标准权限**。
    *   Owner: rw- (读写)
    *   Group: r-- (只读)
    *   Others: r-- (只读)
*   **600** (rw-------): **敏感文件标准权限** (如 SSH 私钥)。
    *   只有 Owner 能读写，其他人无权访问。

**符号表示法**:
*   `u` (User), `g` (Group), `o` (Others), `a` (All)
*   `+` (添加), `-` (移除), `=` (设置)
*   示例:
    *   `chmod +x script.sh`: 给所有人添加执行权限。
    *   `chmod u+x script.sh`: 只给拥有者添加执行权限。
    *   `chmod go-w file.txt`: 移除组和其他人的写权限。

### 2.3 `chown` - 修改所有者 (Change Owner)
语法: `chown [用户]:[组] 文件名`
**注意**: 通常需要 `sudo` 权限。

*   `sudo chown nginx:nginx /var/www/html`: 将目录所有权交给 nginx 用户和组。
*   `sudo chown -R ry:dev ./project`: 递归修改目录及其下所有文件的所有者。

## 3. 实验任务 (Hands-on Lab)

请先在 `Chapter_06` 目录下运行初始化脚本：
```bash
bash lab/init.sh
```
这会生成几个权限配置错误的文件。

### 任务 1: 让脚本跑起来 (Executable)
**目标**: `deploy.sh` 脚本目前无法执行 (`Permission denied`)。
*   **要求**: 修改其权限，使其可以被**当前用户**执行。
*   *提示*: `chmod +x` 或 `chmod 755`。

### 任务 2: 保护 SSH 私钥 (Secure Private Key)
**目标**: `id_rsa` 是一个模拟的私钥文件，目前的权限是 `644` (rw-r--r--)。SSH 客户端会认为它太开放而拒绝使用。
*   **要求**: 将权限修改为 **600** (只有你能读写，别人无权访问)。
*   *提示*: `chmod 600 id_rsa`。

### 任务 3: 修复 Web 目录权限 (Web Server Access)
**目标**: `var/www/html` 是 Web 根目录。
1.  目录权限目前是 `700` (rwx------)。这意味着 Web 服务器（通常运行为 `www-data` 或 `nginx` 用户）无法进入该目录。
2.  `index.html` 权限是 `600`。Web 服务器无法读取它。
*   **要求**:
    *   将 `var/www/html` 目录权限改为 **755** (所有人可进入和读取)。
    *   将 `index.html` 文件权限改为 **644** (所有人可读取)。
*   *提示*: 目录需要 `x` 权限才能被 `cd` 进入。

### 任务 4: 修复 Shebang 脚本
**目标**: `run.py` 是一个 Python 脚本，头部已经加了 `#!/usr/bin/env python3`，但依然无法通过 `./run.py` 运行。
*   **要求**: 赋予其执行权限。

## 4. 验证与通关

完成任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，恭喜你建立了坚固的权限堡垒！

## 5. 进阶思考 (Deep Dive)

1.  **Sticky Bit (`chmod +t`)**: 在 `/tmp` 目录上常见。设置了 Sticky Bit 后，目录下的文件**只有文件所有者**才能删除，防止被别人误删。
2.  **SUID (`chmod u+s`)**: 让普通用户以文件所有者 (通常是 root) 的身份运行程序。例如 `passwd` 命令，它需要修改 `/etc/shadow` (root 才能写)，所以它设置了 SUID。**极度危险，慎用**。
3.  **umask**: 决定了新创建文件的默认权限。输入 `umask` 查看。默认通常是 `0022`，意味着新文件权限是 `666 - 022 = 644`。
