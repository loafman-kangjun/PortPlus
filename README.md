# PORT+ 串口与网络调试助手

![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.x-blue?logo=flutter)
**PORT+** 是一个使用 Flutter 构建的跨平台串行通信和网络调试工具，旨在为开发者、爱好者和工程师提供一个简洁、易用且功能强大的界面，用于监控和调试 UART (串口)、WebSocket 和 TCP 连接。

## ✨ 功能特性 (Features)

* **多种连接支持**:
    * **UART (串口)**: 连接和监控物理或虚拟串口设备。
        * 自动检测可用串口。
        * 可配置波特率、数据位、停止位、校验位。
    * **WebSocket**: 连接到 WebSocket 服务器进行实时双向通信。
    * **TCP Client**: 连接到 TCP 服务器发送和接收数据。
    * **(可选) TCP Server**: 创建 TCP 服务器监听传入连接 (如果实现了此功能)。
* **实时数据监控**: 清晰地显示接收和发送的数据流。
* **数据发送**: 支持发送 ASCII 字符串或 Hex (十六进制) 数据。
* **连接管理**: 轻松打开、关闭和切换不同的连接。
* **清晰的状态显示**: 明确指示当前连接状态（连接中、已连接、已断开、错误）。
* **跨平台**: 基于 Flutter 构建，目标支持 Windows, macOS, Linux 桌面平台。
* **简洁的用户界面**: 提供直观易用的操作体验。
* **(可选) 日志记录**: 将通信数据记录到文件 (如果实现了此功能)。
* **(可选) 数据格式化**: 支持以不同格式（如文本、Hex）显示数据 (如果实现了此功能)。

## 💻 支持平台 (Supported Platforms)

由于使用了 Flutter，PORT+ 旨在支持以下桌面平台：

* ✅ Windows
* ✅ macOS
* ✅ Linux

*注意：串口 (UART) 功能依赖于操作系统本地接口，可能需要特定驱动或权限设置。各平台支持情况可能因依赖的插件而异。*

## 📸 截图 (Screenshots)

*请在此处添加你的应用截图，展示主要界面、设置对话框和数据收发视图等。*

## 🚀 安装与运行 (Installation)

如果你想从源码运行或参与开发：

**环境要求**:

* 安装 [Flutter SDK](https://flutter.dev/docs/get-started/install) (请确保版本符合要求，例如 >= 3.x)
* 安装 [Git](https://git-scm.com/)
* (对于特定平台) 可能需要安装 C++ 构建工具链 (例如 Visual Studio for Windows, Xcode for macOS, build-essential for Linux)。
* (对于串口) 可能需要根据你使用的 `flutter_serial_port` 或类似插件的要求，安装额外的驱动或库 (例如 `libudev-dev` on Linux)。

**步骤**:

1.  **克隆仓库**:
    ```bash
    git clone https://github.com/loafman-kangjun/PortPlus
    cd PortPlus # 或者你的项目目录名
    ```

2.  **获取依赖**:
    ```bash
    flutter pub get
    ```

3.  **运行应用**:
    ```bash
    flutter run
    ```
    * 你也可以使用 `flutter build <platform>` 来构建特定平台的发布版本 (例如 `flutter build windows`)。

## 📖 使用说明 (Usage)

1.  启动 PORT+ 应用。
2.  在界面上选择你想要使用的连接类型（UART, WebSocket, TCP Client）。
3.  配置相应的连接参数：
    * **UART**: 选择串口号，设置波特率、数据位、停止位和校验位。
    * **WebSocket**: 输入 WebSocket 服务器的 URL (例如 `ws://echo.websocket.org`)。
    * **TCP Client**: 输入目标服务器的 IP 地址或主机名以及端口号。
4.  点击“连接” (Connect) 按钮。
5.  连接成功后，接收到的数据会显示在主数据视图区域。
6.  在发送输入框中输入你想要发送的数据（可以选择文本或 Hex 格式）。
7.  点击“发送” (Send) 按钮。
8.  完成调试后，点击“断开” (Disconnect) 按钮关闭连接。

## 📦 主要依赖 (Dependencies)

* [Flutter SDK](https://flutter.dev/)
* * `flutter_serial_port` (或你使用的其他串口包) - 用于 UART 通信
* `web_socket_channel` - 用于 WebSocket 通信
* `dart:io` (内置) - 用于 TCP 通信
* *请更新以上列表，包含你项目中实际使用的主要库。*

## 🤝 贡献 (Contributing)

欢迎各种形式的贡献！如果你有任何建议、发现 Bug 或想要添加新功能：

1.  **Fork** 本仓库。
2.  创建你的特性分支 (`git checkout -b feature/AmazingFeature`)。
3.  提交你的更改 (`git commit -m 'Add some AmazingFeature'`)。
4.  推送到分支 (`git push origin feature/AmazingFeature`)。
5.  打开一个 **Pull Request**。

也欢迎通过 [Issues](https://github.com/loafman-kangjun/PortPlus/issues) 报告问题或提出建议。

## 📄 许可证 (License)

本项目采用 MIT 许可证。详情请参阅 `LICENSE` 文件。

## 📧 联系方式 (Contact)

---

希望这个 PORT+ 工具能对你的开发和调试工作有所帮助！