# Contributing to iOS-PluginBase

Thank you for your interest in contributing to the iOS-PluginBase project! This document provides guidelines and setup instructions for development.

## Development Setup

### Prerequisites

Before you begin, ensure you have the following installed:

- **Xcode 16.0+** with iOS 13.0+ SDK
- **Ruby 2.7+** (for Rake tasks and CocoaPods)
- **CocoaPods** (latest version)
- **Tuist 4.61.1** (for project generation)
- **Homebrew** (for installing Tuist)

### Installation Steps

1. **Clone other plugin repositories:**

   ```bash
   cd your-workspace
   git clone https://github.com/moengage/apple-plugin-cards.git
   git clone https://github.com/moengage/apple-plugin-geofence.git
   git clone https://github.com/moengage/apple-plugin-inbox.git
   ```

1. **Comment out `iOS-PluginBase` version based dependency in cards, geofence and inbox `Package.swift` package manifest and uncomment relative path dependency.** i.e

  ```swift
    // comment out following by prefixing with "// "
    .package(url: "https://github.com/moengage/iOS-PluginBase.git", exact: "6.6.0"),
    // For development uncomment out following by removing prefix "// "
    // .package(path: "../iOS-PluginBase")
  ```

1. **Clone the repository:**

   ```bash
   git clone https://github.com/moengage/iOS-PluginBase.git
   cd iOS-PluginBase
   ```

1. **Install Tuist:**

   ```bash
   brew install --formula tuist@4.61.1 --force
   ```

1. **Setup the project:**

   ```bash
   rake setup
   ```

   This command will:
   - Install Tuist dependencies
   - Generate the Xcode workspace
   - Install CocoaPods dependencies

### Project Structure Requirements

**IMPORTANT:** For proper integration with Cards, Geofence, and Inbox plugins, you must maintain the following relative directory structure:

```text
your-workspace/
├── iOS-PluginBase/                    # This repository
├── apple-plugin-cards/                # Cards plugin repository
├── apple-plugin-geofence/             # Geofence plugin repository
└── apple-plugin-inbox/                # Inbox plugin repository
└── hybrid/                            # Hybrid package repository (Flutter, RN etc.)
```

The relative paths are critical for:

- **CocoaPods integration** (see `Examples/Podfile`)
- **Tuist project generation** (see `Examples/Project.swift`)
- **Local development and testing**

### Development Workflow

1. **Open the workspace:**

   ```bash
   open Examples/MoEngagePluginBase.xcworkspace
   ```

2. Build and Run tests

### Project Architecture

This project consists of:

- **MoEngagePluginBase**: Core plugin base functionality
- **MoEngageSegmentPluginBase**: Segment-specific plugin implementation
- **Examples**: Sample applications demonstrating usage

### Key Files

- `Package.swift`: Swift Package Manager configuration
- `MoEngagePluginBase.podspec`: CocoaPods specification
- `Rakefile`: Build automation tasks
- `package.json`: Version and dependency management
- `Examples/Podfile`: CocoaPods dependencies for examples
- `Examples/Project.swift`: Tuist project configuration

### Dependencies

The project depends on:

- **MoEngage Apple SDK** (version 10.07.1+)
- **UIKit, Foundation, UserNotifications** frameworks
- **Cards, Geofence, Inbox plugins** (for full functionality)

### Version Management

Versions are managed through:

- `package.json`: Contains version information and SDK requirements
- `Package.swift`: Auto-generated from `package.json` via `Utilities/post_build.rb`
- `MoEngagePluginBase.podspec`: CocoaPods version specification

### Testing

The project includes:

- Unit tests in `Tests/MoEngagePluginBaseTests/`
- Integration tests with sample applications
- Tests for Segment plugin functionality

### Release Process

The project uses automated release workflows:

- **CI/CD**: GitHub Actions for testing and deployment
- **Dependent releases**: Automated release of dependent plugins (Cards, Geofence, Inbox)
- **Version bumping**: Automated version management across related repositories

### Troubleshooting

**Common Issues:**

1. **Tuist not found:**

   ```bash
   brew install --formula tuist@4.61.1 --force
   ```

2. **CocoaPods issues:**

   ```bash
   cd Examples
   pod deintegrate
   pod install
   ```

3. **Missing plugin dependencies:**
   - Ensure the relative directory structure is maintained
   - Clone the required plugin repositories in the correct locations

4. **Build failures:**

   ```bash
   rake setup  # Re-run setup
   ```

### Code Style

- Follow Swift style guidelines
- Use meaningful variable and function names
- Add documentation for public APIs
- Write unit tests for new functionality

### Submitting Changes

1. Create a feature branch from `development`
2. Make your changes
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request with a clear description

### Support

For questions or issues:

- Check existing GitHub issues
- Create a new issue with detailed information
- Contact the maintainers

---

**Note:** This project is primarily used as a base for MoEngage hybrid framework plugins and is not intended for direct use in applications.
