# Contributing to Cortex AI

Thank you for your interest in contributing to Cortex AI! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

### Prerequisites
- Flutter 3.10+
- Dart 3.0+
- Git
- Android Studio / VS Code

### Setup Development Environment
1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/cortex.git`
3. Install dependencies: `flutter pub get`
4. Create a branch: `git checkout -b feature/your-feature`

## 📝 How to Contribute

### Types of Contributions
- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation improvements
- 🎨 UI/UX enhancements
- ⚡ Performance optimizations
- 🧪 Tests

### Before You Start
1. Check existing issues and PRs
2. Create an issue for new features
3. Discuss major changes first
4. Follow coding standards

## 🔧 Development Guidelines

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages
```
type(scope): description

feat(chat): add message encryption
fix(ui): resolve theme switching bug
docs(readme): update installation steps
```

### Testing
- Write tests for new features
- Ensure existing tests pass
- Test on multiple devices/platforms
- Verify performance impact

## 📋 Pull Request Process

1. **Create PR** with clear title and description
2. **Link Issues** that the PR addresses
3. **Add Screenshots** for UI changes
4. **Update Documentation** if needed
5. **Request Review** from maintainers

### PR Checklist
- [ ] Code follows project standards
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Performance tested

## 🏗️ Project Structure

```
lib/
├── core/           # Navigation & routing
├── data/           # Storage & repositories  
├── ffi/            # Native bindings
├── models/         # Data models
├── services/       # Business logic
├── theme/          # UI theming
├── ui/             # User interface
├── utils/          # Helper utilities
└── main.dart       # Entry point
```

## 🎯 Areas for Contribution

### High Priority
- Native LLM integration
- Performance optimizations
- Additional model formats
- Platform-specific features

### Medium Priority
- UI improvements
- Additional personas
- Export/import features
- Accessibility enhancements

### Documentation
- Code documentation
- User guides
- API documentation
- Architecture diagrams

## 🐛 Bug Reports

### Include:
- Flutter/Dart version
- Device/OS information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs

### Template:
```markdown
**Environment:**
- Flutter: 3.10.0
- Dart: 3.0.0
- OS: Android 13

**Steps to Reproduce:**
1. Open chat screen
2. Send message
3. Observe error

**Expected:** Message should send
**Actual:** App crashes
```

## 💡 Feature Requests

### Include:
- Clear use case description
- Proposed implementation
- Alternative solutions considered
- Impact on existing features

## 📞 Communication

- **Issues**: GitHub Issues for bugs/features
- **Discussions**: GitHub Discussions for questions
- **Security**: security@cortex-ai.dev for vulnerabilities

## 🏆 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in app about section

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.