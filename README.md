# Cortex Pocket

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

On-device AI powered by optimized local LLMs. Cortex brings powerful offline LLM capabilities to your device using optimized on-device models for fast, private AI assistance.

## ✨ Features

- 🔒 **Fully Offline**: No cloud dependency, complete privacy by default
- ⚡ **Real-time Generation**: Token-by-token response streaming
- 📱 **Optimized Performance**: Arm-optimized for mobile devices
- 🛡️ **Secure Conversations**: All processing happens locally
- 💻 **Code Assistance**: Built-in support for code analysis
- 🧠 **Smart Reasoning**: Advanced on-device intelligence
- 🎭 **Multiple Personas**: Developer, Security, Writer, Analyst modes
- 📊 **Performance Monitoring**: Real-time benchmarks and metrics
- 📁 **File Analysis**: Support for logs, code, and text files
- ☁️ **Optional Remote API**: Secure cloud fallback with API key encryption

## 🚀 Quick Start

### Prerequisites
- Flutter 3.10+
- Dart 3.0+
- Android Studio / VS Code / Xcode (for iOS)

### Supported Platforms
- 🤖 **Android** (Primary target)
- 🍎 **iOS** 
- 🐧 **Linux**
- 🍎 **macOS**
- 🪟 **Windows**

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/cortex-pocket.git
cd cortex
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# Android (default)
flutter run

# Specific platforms
flutter run -d android
flutter run -d ios
flutter run -d linux
flutter run -d macos
flutter run -d windows
```

## 🏗️ Architecture

```
lib/
├── core/           # Navigation & routing
├── data/           # Storage & repositories
├── ffi/            # Native LLM bindings
├── models/         # Data models
├── services/       # Business logic
├── theme/          # UI theming
├── ui/             # User interface
├── utils/          # Helper utilities
└── main.dart       # App entry point
```

### Key Components
- **FFI Layer**: Native llama.cpp integration
- **Data Layer**: Encrypted storage & repositories
- **Service Layer**: LLM processing & management
- **UI Layer**: 10 screens with Material Design
- **Utils Layer**: Device info, benchmarks, file handling

## 🔧 Model Integration

1. **Add model files** to `assets/models/`
2. **Update LLMService** for your specific model
3. **Configure FFI bindings** for optimal performance
4. **Set quantization** (Q8/Q6/Q4/Q3) based on device capabilities

## 📱 Screens

1. **Splash** (`/`) - Loading & initialization
2. **Home** (`/home`) - Main dashboard
3. **Chat** (`/chat`) - AI conversation interface
4. **Models** (`/models`) - Model selection & management
5. **Personas** (`/personas`) - AI personality selection
6. **File Analysis** (`/file-reasoning`) - Document processing
7. **Benchmarks** (`/benchmark`) - Performance metrics
8. **History** (`/history`) - Chat session management
9. **Settings** (`/settings`) - App configuration
10. **About** (`/about`) - App information

## ☁️ Remote API Mode (Optional)

Cortex Pocket includes an optional remote API feature for enhanced capabilities:

### Setup
1. Go to **Settings** → **Remote API**
2. Enter your API key (OpenAI compatible)
3. Tap **Save & Test** to validate
4. Enable **Use Remote API** toggle
5. Confirm privacy consent dialog

### Privacy & Security
- **API keys stored encrypted** using Flutter Secure Storage
- **Explicit consent required** before enabling remote mode
- **Clear privacy notices** when remote mode is active
- **Automatic fallback** to local model if remote fails
- **Easy disable/clear** - remove API key anytime

### Usage
- Chat shows current mode: "Mode: On-device" or "Mode: Remote"
- Remote failures automatically fall back to local processing
- Benchmarks always use local models regardless of remote setting

## 🔒 Privacy & Security

- **100% Local Processing**: Default mode - no data leaves your device
- **Encrypted Storage**: Chat history and API keys secured with encryption
- **No Network Calls**: Completely offline operation by default
- **Optional Remote**: Explicit opt-in with clear privacy implications
- **Open Source**: Transparent and auditable code

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## 🛡️ Security

See [SECURITY.md](SECURITY.md) for security policy and reporting vulnerabilities.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.