# Changelog

All notable changes to Cortex Pocket will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Enhanced Chat Interface**: Complete redesign with advanced features
- **Mode Toggle Switch**: One-click switching between local and remote processing
- **Dynamic Model Selection**: Provider-specific model options based on API key type
- **Document Attachment**: Support for TXT, PDF, DOC, DOCX, MD file uploads
- **Action Menu**: Quick access to document attachment and model switching
- **Visual Mode Indicators**: Icons and colors showing current processing mode
- **Smart Model Detection**: Automatic model list based on API provider
- **Gemini Model Support**: Full support for Gemini 2.5 Flash, Pro, Lite, and 3.0 Preview
- **Legal Compliance**: Complete legal documentation suite
- **Privacy Policy Screen**: Comprehensive privacy information and data handling
- **Terms of Use Screen**: Legal terms, acceptable use, and liability limitations
- **Cookie Policy Screen**: Local storage usage and data management policies
- **AI Disclaimer Screen**: Important AI usage warnings and accuracy limitations
- **Legal Navigation**: Integrated legal section in settings with proper routing

### Enhanced
- **Chat Experience**: Intuitive mode switching and model selection
- **User Interface**: Clean toggle switches and visual feedback
- **Error Handling**: Better error messages with helpful guidance
- **Cross-Platform**: Improved compatibility across all supported platforms
- **Settings UI**: Added dedicated legal section with clear navigation
- **Route Management**: Extended routing system for legal screens
- **Compliance Ready**: Full legal framework for app store deployment

### Technical
- **Provider Detection**: Automatic API provider identification
- **Model Management**: Dynamic model lists based on API key type
- **File Handling**: Secure document attachment with type validation
- **State Management**: Improved reactive UI updates
- **Code Quality**: Fixed lint warnings and improved async handling

## [1.2.0] - 2024-12-20

### Added
- **Smart Chat Interface**: Revolutionary chat experience with mode switching
- **Document Attachment**: Upload and process documents directly in chat
- **Dynamic Model Selection**: Provider-aware model options
- **Visual Mode Toggle**: Intuitive switch between local and remote processing
- **Gemini Model Suite**: Support for latest Gemini models including 2.5 Flash
- **Action Menu**: Quick access to all chat features

### Enhanced
- **User Experience**: Streamlined interface with visual feedback
- **Error Handling**: Detailed error messages with actionable guidance
- **Performance**: Optimized model switching and state management

## [1.1.0] - 2024-12-19

### Added
- **Remote API Support**: Optional cloud-based inference with OpenAI-compatible APIs
- **Secure API Key Management**: Encrypted storage using Flutter Secure Storage
- **API Key Edit/Delete**: Full CRUD operations for API key management with confirmation dialogs
- **Intelligent Mode Switching**: Automatic fallback from remote to local processing
- **Privacy Consent System**: Explicit user consent required for remote mode activation
- **Mode Indicator**: Real-time display of current processing mode (On-device/Remote)
- **Comprehensive Settings Store**: Centralized configuration management for all app settings
- **Enhanced Settings UI**: Improved settings screen with remote API configuration

### Enhanced
- **LLM Service**: Updated with remote/local switching logic and state management
- **Chat Interface**: Added mode indicator and improved error handling
- **Settings Management**: Expanded ConfigStore with model, UI, and performance settings
- **Privacy Controls**: Clear privacy notices and easy disable/clear functionality

### Security
- **Encrypted Storage**: API keys stored securely and never logged
- **No Data Leakage**: Maintains privacy-first approach with optional remote features
- **Safe Defaults**: Remote mode disabled by default, on-device processing primary

## [1.0.0] - 2024-01-15

### Added
- 🎉 Initial release of Cortex Pocket
- 💬 Real-time chat interface with AI assistant
- 🏠 Home dashboard with quick access to all features
- 🤖 Multiple AI personas (Developer, Security, Writer, Analyst, Helper)
- 📊 Performance benchmark dashboard with metrics
- 📁 File analysis for logs, code, and text documents
- 🎨 Professional light/dark theme system
- 🔒 Encrypted local chat history storage
- ⚙️ Comprehensive settings and configuration
- 📱 10 fully functional screens with Material Design
- 🔧 FFI layer foundation for native LLM integration
- 📈 Real-time performance monitoring
- 🎯 Device capability detection and optimization
- 💾 Secure local data storage with repositories
- 🛠️ Utility layer for file handling and benchmarks

### Technical Features
- Flutter 3.10+ with Material 3 design
- Dart 3.0+ with null safety
- FFI bindings for native performance
- Encrypted storage with AES-256
- Repository pattern for data management
- Professional theming system
- Comprehensive error handling
- Performance optimization utilities

### Architecture
- Clean architecture with 7 layers
- Separation of concerns
- Dependency injection ready
- Scalable folder structure
- Professional code organization

### Security
- 100% local processing
- No network communication
- Encrypted chat storage
- Privacy-first design
- Secure memory management

### Performance
- Optimized for mobile devices
- ARM architecture support
- Efficient memory usage
- Real-time metrics tracking
- Quantization support (Q8/Q6/Q4/Q3)

## [0.1.0] - 2024-01-01

### Added
- Project initialization
- Basic Flutter setup
- Initial architecture planning