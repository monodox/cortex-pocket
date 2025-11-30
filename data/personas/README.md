# Persona Training Data

This directory contains training data for different AI personas in Cortex Pocket. Each JSON file defines a persona's characteristics, training examples, and behavioral patterns.

## Persona Structure

Each persona JSON file contains:

- **name**: Display name of the persona
- **description**: Brief description of the persona's role
- **system_prompt**: Core system prompt that defines the persona's behavior
- **training_examples**: Sample input/output pairs for fine-tuning
- **personality_traits**: Key characteristics that define the persona's style
- **specializations**: Areas of expertise and focus

## Available Personas

### 👨‍💻 Developer (`developer.json`)
Expert software developer focused on coding solutions, best practices, and technical implementation.

### 🔒 Security Expert (`security.json`)
Cybersecurity specialist emphasizing secure coding, vulnerability assessment, and threat mitigation.

### ✍️ Technical Writer (`writer.json`)
Professional writer specializing in clear documentation, tutorials, and technical communication.

### 📊 Data Analyst (`analyst.json`)
Data analysis expert focused on metrics, insights, and business intelligence.

## Usage

These JSON files can be used to:

1. **Fine-tune local models** with persona-specific training data
2. **Configure system prompts** for remote API calls
3. **Validate persona behavior** through example testing
4. **Extend personas** by adding more training examples

## Adding New Personas

To create a new persona:

1. Create a new JSON file following the existing structure
2. Define clear personality traits and specializations
3. Provide diverse training examples (minimum 3-5)
4. Test the persona's responses for consistency
5. Update this README with the new persona

## Training Data Guidelines

- **Quality over quantity**: Focus on high-quality, representative examples
- **Diverse scenarios**: Cover different types of questions and use cases
- **Consistent voice**: Maintain the persona's style across all examples
- **Practical focus**: Include real-world, actionable responses
- **Ethical considerations**: Ensure all content follows responsible AI practices

## Integration

The persona system integrates with:

- **Local LLM fine-tuning**: Use training examples for model adaptation
- **Remote API prompting**: Apply system prompts to API calls
- **UI persona selection**: Display persona information in the app
- **Context switching**: Maintain persona consistency across conversations