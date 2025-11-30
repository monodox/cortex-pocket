# Cortex Pocket Data Directory

This directory contains structured data files used by Cortex Pocket for AI personas, app information, and user guidance.

## Directory Structure

```
data/
├── personas/           # AI persona training data
│   ├── developer.json     # Software developer persona
│   ├── security.json      # Security expert persona
│   ├── writer.json        # Technical writer persona
│   ├── analyst.json       # Data analyst persona
│   └── README.md          # Persona documentation
├── app_info.json       # App features and platform info
├── models.json         # Supported models and recommendations
├── faq.json           # Frequently asked questions
├── guide.json         # Cortex guide persona
└── README.md          # This file
```

## Data Files

### 🎭 `personas/`
Contains AI persona definitions with training examples, personality traits, and specializations. Each persona provides expertise in specific domains like development, security, writing, or data analysis.

### 📱 `app_info.json`
Comprehensive app information including:
- Feature descriptions with icons
- Platform support details
- Screen routes and descriptions
- Version and metadata

### 🤖 `models.json`
Model information and recommendations:
- Supported local models (Llama, Phi, Qwen, Gemma, CodeLlama)
- Remote API models (Gemini, OpenAI)
- Device-specific recommendations
- Memory requirements and quantization options

### ❓ `faq.json`
Categorized frequently asked questions covering:
- Getting started guide
- Local model setup and troubleshooting
- Remote API configuration
- Persona usage guidelines
- Privacy and security information
- Performance optimization tips

### 🎯 `guide.json`
Cortex Guide persona for app assistance:
- Comprehensive app knowledge and features
- Setup and troubleshooting guidance
- User-focused help and explanations
- Cross-platform usage tips

## Usage

These data files serve multiple purposes:

### 🧠 **AI Training & Behavior**
- Persona system prompts and training examples
- Consistent AI behavior across conversations
- Specialized expertise for different use cases

### 📚 **User Guidance**
- In-app help and documentation
- Setup instructions and troubleshooting
- Feature explanations and best practices

### 🔧 **App Configuration**
- Model recommendations based on device capabilities
- Platform-specific feature availability
- Dynamic content for UI components

## Maintenance

### Adding New Content
1. **Personas**: Add new JSON files in `personas/` directory
2. **FAQ**: Update `faq.json` with new categories or questions
3. **Models**: Update `models.json` when new models are supported
4. **App Info**: Update `app_info.json` for new features or platforms

### Data Quality Guidelines
- **Accuracy**: Ensure all information is current and correct
- **Consistency**: Maintain consistent formatting and structure
- **Completeness**: Provide comprehensive coverage of topics
- **User-focused**: Write from user perspective with clear explanations

### Integration Points
- **Persona Selection**: UI loads persona data for display and behavior
- **Help System**: FAQ and app info power in-app assistance
- **Model Management**: Model data drives download recommendations
- **Onboarding**: App info guides new user experience

This structured approach ensures consistent, maintainable, and comprehensive data management for Cortex Pocket's AI-powered features.