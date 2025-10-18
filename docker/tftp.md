 
# TFTP 服务器镜像 (netboot.xyz)


基于 Alpine Linux 构建的轻量级 Docker 镜像，提供预装 [netboot.xyz](https://netboot.xyz) EFI 引导文件的 TFTP 服务器。专为网络引导环境设计，支持 x86 和 ARM 架构设备的 PXE 引导。

## 功能特点

- ✅ **预配置 TFTP 服务**：使用 `tftp-hpa` 提供标准 TFTP 服务
- ✅ **全平台引导文件**：包含 x86 和 ARM 架构的 netboot.xyz EFI 文件
- ✅ **安全运行**：以非特权用户 `tftpd` 运行服务
- ✅ **持久化支持**：通过 Docker 卷保存自定义引导文件
- ✅ **轻量高效**：镜像大小仅约 10MB

## 快速开始

运行 TFTP 服务器（使用内置引导文件）：

```bash
docker run -d \
  --name netboot-tftp \
  -p 69:69/udp \
  centdo/tftp:latest
 ```

使用主机目录存储文件
 
```bash
docker run -d \
  --name custom-tftp \
  -p 69:69/udp \
  -v /path/to/my-tftp-files:/srv/tftp \
  centdo/tftp:latest
```

下载文件测试
```bash
tftp localhost
tftp> get amd.efi
Received 1024624 bytes in 0.5 seconds
tftp> quit
```
