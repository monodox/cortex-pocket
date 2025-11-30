# Contributing to Cortex Pocket

Thank you for your interest in contributing to Cortex Pocket! This document provides guidelines for contributing to the project.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a branch** for your feature or bug fix
4. **Make your changes** following our coding standards
5. **Test your changes** thoroughly
6. **Submit a pull request**

## Development Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/cortex-pocket.git
cd cortex-pocket

# Install dependencies
flutter pub get

# Run the app (native platforms)
flutter run

# Run on web (requires Remote API)
flutter run -d chrome
```

### Platform-Specific Setup

**Native Platforms (Android/iOS/Desktop):**
- FFI support for local LLM integration
- Model files in `assets/models/` directory
- Native compilation for llama.cpp bindings

**Web Platform:**
- Remote API only (no local models)
- Configure API keys for testing
- CORS considerations for development

## Coding Standards

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure code is properly formatted (`dart format .`)
- Run linter (`flutter analyze`)

## Pull Request Process

1. **Update documentation** if needed
2. **Add tests** for new functionality
3. **Ensure all tests pass**
4. **Update CHANGELOG.md** with your changes
5. **Request review** from maintainers

## Types of Contributions

- **Bug fixes**: Fix existing issues
- **Features**: Add new functionality
- **Documentation**: Improve docs and examples
- **Performance**: Optimize existing code
- **Tests**: Add or improve test coverage
- **Model Integration**: Add support for new LLM models
- **Platform Support**: Improve cross-platform compatibility
- **Security**: Enhance privacy and security features
- **UI/UX**: Improve user interface and experience

## Reporting Issues

When reporting bugs, please include:

- **Device/Platform information**
- **Steps to reproduce**
- **Expected vs actual behavior**
- **Screenshots** if applicable
- **Logs/Error messages**

## Feature Requests

For new features:

- **Check existing issues** first
- **Describe the use case**
- **Explain the benefit**
- **Consider implementation complexity**

## Code Review

All submissions require review. We use GitHub pull requests for this purpose. Reviewers will check for:

- Code quality and style
- Test coverage
- Documentation updates
- Breaking changes
- Performance impact
- Privacy implications
- Security considerations
- Cross-platform compatibility
- AI model integration quality

## AI/LLM Specific Guidelines

### Model Integration
- Test with multiple quantization levels (Q3, Q4, Q6, Q8)
- Ensure memory efficiency for mobile devices
- Document model requirements and performance
- Follow responsible AI practices

### Privacy & Security
- Maintain local-first architecture
- Encrypt sensitive data (API keys, chat history)
- No telemetry or tracking in local mode
- Clear consent for remote API usage

### Performance Considerations
- Optimize for mobile/edge devices
- Memory usage monitoring
- Battery life impact assessment
- Streaming response implementation

## Testing Guidelines

### Local Model Testing
- Test model loading and unloading
- Verify quantization support
- Memory leak detection
- Performance benchmarking

### Remote API Testing
- API key validation
- Network error handling
- Fallback to local models
- Rate limiting compliance

### Cross-Platform Testing
- Test on all supported platforms
- Verify FFI compatibility
- Web-specific limitations
- Platform-specific UI adaptations

## License

By contributing, you agree that your contributions will be licensed under the MIT License.