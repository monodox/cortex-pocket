# Cortex Pocket

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Cortex Pocket is an offline-first, Arm-optimized mobile AI assistant powered by local LLMs with optional cloud fallback.

## 💡 Why Cortex Pocket?

- **Fully offline AI** — no other mobile app shows token-by-token Arm-optimized generation
- **Smart dual-mode engine** (local + remote fallback)
- **Developer-grade tooling**: file reasoning, code assistance
- **On-device benchmarks** expose real model performance
- **Persona-based intelligence** for multiple workflows

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
- 🔄 **Smart Mode Switching**: One-click toggle between local and remote processing
- 🎛️ **Dynamic Model Selection**: Provider-specific model options (Gemini/OpenAI)
- 📎 **Document Attachment**: Support for TXT, PDF, DOC, DOCX, MD files
- 🎯 **Intelligent Fallback**: Automatic local processing when remote fails

## 🚀 Quick Start

### Prerequisites
- Flutter 3.10+
- Dart 3.0+
- Android Studio / VS Code / Xcode (for iOS)

### Supported Platforms
- 🤖 **Android** (Primary target)
- 🍎 **iOS** 
- 🌐 **Web** (Remote API only)
- 🐧 **Linux**
- 🍎 **macOS**
- 🪟 **Windows**

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/monodox/cortex-pocket.git
cd cortex-pocket
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
flutter run -d chrome    # Web platform (Chrome)
flutter run -d edge      # Web platform (Edge)
flutter run -d web-server # Web platform (any browser)
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

data/
├── personas/       # AI persona training data
│   ├── developer.json  # Software developer persona
│   ├── security.json   # Security expert persona
│   ├── writer.json     # Technical writer persona
│   └── analyst.json    # Data analyst persona
├── app_info.json   # App features and platform info
├── models.json     # Supported models and recommendations
├── faq.json       # Frequently asked questions
└── guide.json     # Cortex guide persona
```

### Key Components
- **FFI Layer**: Native llama.cpp integration (native platforms only)
- **Data Layer**: Encrypted storage & repositories
- **Service Layer**: LLM processing & management
- **UI Layer**: 10 screens with Material Design
- **Utils Layer**: Device info, benchmarks, file handling
- **Platform Layer**: Conditional imports for web/native compatibility
- **Training Data**: AI personas with specialized knowledge and behavior patterns

## 🏎️ Arm Optimization

Cortex Pocket is optimized specifically for Arm-based mobile CPUs:

- Built with llama.cpp compiled for Armv8-A + NEON acceleration
- Uses f16 KV cache for reduced memory bandwidth
- Utilizes quantized GGUF models (Q8, Q6, Q4, Q3) for efficient mobile inference
- Thread scheduling optimized for big.LITTLE CPU architectures
- On-device profiling captures:
  - token/s
  - RAM usage
  - CPU cluster utilization
  - model load latency

These optimizations ensure fast, private AI performance on modern Android devices.

## 🔧 Model Integration

1. **Add model files** to `assets/models/`
2. **Update LLMService** for your specific model
3. **Configure FFI bindings** for optimal performance
4. **Set quantization** (Q8/Q6/Q4/Q3) based on device capabilities

## 🎭 AI Personas

Cortex Pocket features specialized AI personas with unique expertise and training:

### Available Personas
- 👨‍💻 **Developer**: Expert in coding, debugging, and software architecture
- 🔒 **Security Expert**: Specializes in cybersecurity and secure coding practices
- ✍️ **Technical Writer**: Focuses on clear documentation and communication
- 📊 **Data Analyst**: Expert in metrics, insights, and business intelligence
- 🎯 **Cortex Guide**: Comprehensive app assistance and troubleshooting

### Training Data Structure
Each persona includes:
- **System Prompts**: Core personality and behavior definition
- **Training Examples**: Real-world input/output pairs for consistency
- **Personality Traits**: Behavioral characteristics and communication style
- **Specializations**: Areas of expertise and focus domains

See `data/` directory for complete persona definitions and training data.

## 🧠 How It Works (Pipeline)

1. **User selects a model** (local or remote)
2. **LLMService decides inference mode** (offline/online)
3. **For local**:
   - FFI sends prompt → llama.cpp engine
   - Tokens streamed back → UI bubble
4. **For remote**:
   - HTTPS request with encrypted API key
   - Response parsed and streamed
5. **Chat history stored locally** using encrypted storage

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
- **Mode Toggle**: Switch between local/remote with navbar toggle switch
- **Model Selection**: Choose from provider-specific models via action menu
- **Document Attachment**: Attach files using the plus button in chat
- **Smart Fallback**: Remote failures automatically use local processing
- **Visual Indicators**: Icons show current mode (⚡ local, ☁️ remote)
- **Benchmarks**: Always use local models regardless of remote setting
- **Web Platform**: Local models not supported - requires Remote API configuration
- **Error Recovery**: Comprehensive error messages with step-by-step solutions
- **Smart Guidance**: Context-aware help based on current configuration

### Supported Models
**Gemini API (AIza...):**
- gemini-2.5-flash (Default)
- gemini-2.5-pro
- gemini-2.5-flash-lite  
- gemini-3-pro-preview

**OpenAI API (sk-...):**
- gpt-3.5-turbo
- gpt-4
- gpt-4-turbo

## 📁 Data & Configuration

Cortex Pocket includes comprehensive data files for AI behavior and user guidance:

### Training Data (`data/`)
- **Persona Definitions**: Specialized AI personalities with training examples
- **App Information**: Features, platforms, and screen descriptions
- **Model Database**: Supported models with device recommendations
- **FAQ System**: Categorized help and troubleshooting guides
- **Guide Assistant**: Comprehensive app knowledge for user support

### Supported Models
- **Llama 3.2 3B**: Meta's mobile-optimized model
- **Phi-3.5 Mini**: Microsoft's efficient 3.8B model
- **Qwen2.5 3B**: Alibaba's multilingual coding model
- **Gemma 2 2B**: Google's lightweight model
- **CodeLlama 7B**: Meta's specialized coding model

## 🔒 Privacy & Security

- **100% Local Processing**: Default mode - no data leaves your device
- **Encrypted Storage**: Chat history and API keys secured with encryption
- **No Network Calls**: Completely offline operation by default
- **Optional Remote**: Explicit opt-in with clear privacy implications
- **Open Source**: Transparent and auditable code

## 🚨 Troubleshooting & Error Handling

### First Time Setup
**Issue**: "No model available" when trying to chat
- **Solution**: Choose either local model or remote API
- **Local**: Go to Models → Browse Models → Download .gguf file
- **Remote**: Go to Settings → Enter API key → Enable remote mode

**Issue**: "Web version - local models not supported"
- **Cause**: Web browsers cannot run native AI models
- **Solution**: Use remote API (OpenAI/Gemini) in Settings
- **Alternative**: Download mobile app for local AI

### Model Installation
**Issue**: Model loading fails on mobile
- Check available RAM (4GB+ recommended)
- Try smaller quantization (Q3 instead of Q4)
- Close background apps
- Restart app and try again

**Issue**: "Model file not found"
- Ensure .gguf file is in `assets/models/` directory
- Check file name matches exactly
- Verify file downloaded completely

### Remote API Issues
**Issue**: "API key invalid" error
- Verify key format: `sk-...` (OpenAI) or `AIza...` (Gemini)
- Check key hasn't expired
- Test key in Settings before enabling

**Issue**: Remote API fails, no local fallback
- Load a local model for backup
- Check internet connection
- Verify API quota/billing status

### Performance Issues
**Issue**: Slow token generation
- Enable performance mode in device settings
- Close background apps
- Try smaller model (Gemma 2B)
- Check thermal throttling

**Issue**: App crashes during inference
- Insufficient RAM - try Q3 quantization
- Model too large for device
- Restart app and reload model

### Platform-Specific
**Web Platform**:
- Only remote API supported
- Local models not available
- Use Settings to configure API key

**Mobile Platform**:
- Both local and remote supported
- Download models from HuggingFace
- Use benchmarks to test performance

### Getting Help
- Check **About** screen for app info
- Review **FAQ** in app data
- Open GitHub issue with device details
- Include error messages and steps to reproduce

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.ject is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## 🛡️ Security

See [SECURITY.md](SECURITY.md) for security policy and reporting vulnerabilities.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.