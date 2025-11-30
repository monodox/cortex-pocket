# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 1. Do NOT create a public issue

Please do not report security vulnerabilities through public GitHub issues.

### 2. Report privately

Send an email to: **security@cortex-pocket.dev** (or create a private security advisory on GitHub)

Include the following information:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### 3. Response timeline

- **Initial response**: Within 48 hours
- **Status update**: Within 7 days
- **Fix timeline**: Depends on severity (1-30 days)

## Security Measures

### Data Protection
- **Local-first**: All data processed locally by default
- **Encrypted storage**: API keys and chat history encrypted
- **No telemetry**: No usage data collected
- **Optional remote**: Explicit opt-in for cloud features
- **Model isolation**: Local models run in sandboxed environment
- **Memory protection**: Sensitive data cleared from memory after use

### API Security
- **Secure storage**: API keys stored in platform keychain
- **HTTPS only**: All remote API calls use TLS
- **Key validation**: API keys validated before use
- **Error handling**: No sensitive data in error messages

### Code Security
- **Dependency scanning**: Regular dependency updates
- **Static analysis**: Code analyzed for vulnerabilities
- **Input validation**: All user inputs validated
- **Memory safety**: Dart's memory management prevents common issues

## Privacy Considerations

### Local Mode (Default)
- **Zero network calls**: Completely offline operation
- **Local storage**: All data stays on device
- **No tracking**: No analytics or telemetry

### Remote Mode (Optional)
- **Explicit consent**: User must opt-in
- **Encrypted transmission**: All API calls use HTTPS
- **No data retention**: We don't store user conversations
- **Provider policies**: Subject to API provider terms

## Responsible Disclosure

We follow responsible disclosure practices:

1. **Acknowledge** receipt of vulnerability report
2. **Investigate** and validate the issue
3. **Develop** and test a fix
4. **Release** security update
5. **Publish** security advisory (if appropriate)

## Security Best Practices for Users

### API Key Management
- **Keep keys secure**: Don't share API keys
- **Use environment variables**: For development
- **Rotate regularly**: Change keys periodically
- **Monitor usage**: Check API provider dashboards

### Device Security
- **Keep updated**: Install app updates promptly
- **Secure device**: Use device lock screens
- **Backup carefully**: Encrypted backups only
- **Network security**: Use trusted networks
- **Model verification**: Verify model file integrity
- **Storage encryption**: Enable device-level encryption
- **App permissions**: Review and limit app permissions

## AI-Specific Security Considerations

### Model Security
- **Model integrity**: Verify model file checksums
- **Sandboxed execution**: Models run in isolated environment
- **Resource limits**: Memory and CPU usage constraints
- **Input sanitization**: All prompts validated and sanitized

### Prompt Injection Protection
- **Input validation**: Filter malicious prompts
- **Context isolation**: Separate system and user contexts
- **Output filtering**: Sanitize model responses
- **Rate limiting**: Prevent abuse through excessive requests

### Data Leakage Prevention
- **Context boundaries**: Clear separation between conversations
- **Memory management**: Secure cleanup of sensitive data
- **Model state isolation**: No cross-conversation data bleeding
- **Temporary file security**: Secure handling of temporary model data

## Threat Model

### Local Mode Threats
- **Malicious models**: Compromised or backdoored model files
- **Memory attacks**: Attempts to extract data from memory
- **File system access**: Unauthorized access to model/data files
- **Side-channel attacks**: Timing or power analysis attacks

### Remote Mode Threats
- **API key theft**: Unauthorized access to API credentials
- **Man-in-the-middle**: Interception of API communications
- **Data exfiltration**: Unauthorized data transmission
- **Provider compromise**: Third-party API service breaches

### Mitigation Strategies
- **Principle of least privilege**: Minimal permissions required
- **Defense in depth**: Multiple security layers
- **Regular updates**: Prompt security patches
- **User education**: Security best practices guidance

## Third-Party Dependencies

We regularly audit and update dependencies for security vulnerabilities:

- **Flutter SDK**: Latest stable version
- **Dart packages**: Maintained and secure packages only
- **Native libraries**: Minimal FFI usage with security review
- **LLM models**: Only trusted, verified model sources
- **Cryptographic libraries**: Industry-standard encryption

## Contact

For security-related questions or concerns:
- **Email**: security@cortex-pocket.dev
- **GitHub**: Private security advisory
- **Response time**: 48 hours maximum