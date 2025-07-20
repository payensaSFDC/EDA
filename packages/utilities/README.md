# Utilities Package

## Overview
This package provides core utility classes and configuration objects that serve as a foundation for other Salesforce packages. It contains essential functionality for debugging, namespace detection, custom settings management, and object metadata access.

## Components

### Apex Classes
- **UTIL_Debug**: Logging and debug utilities for controlled debug output
- **UTIL_Namespace**: Namespace detection and management utilities  
- **UTIL_CustomSettingsFacade**: Facade pattern for accessing custom settings
- **UTIL_Describe**: Object and field metadata access utilities
- **UTIL_Profile**: Profile-related utility methods
- **UTIL_CustomSettings_API**: API for managing custom settings in tests and runtime

### Custom Objects
- **Hierarchy_Settings__c**: Custom settings object containing configuration for:
  - Error handling settings (Store_Errors_On__c, Error_Notifications_On__c, etc.)
  - Debug settings (Enable_Debug__c)
  - Error handling control (Disable_Error_Handling__c)

## Dependencies
This package has no dependencies and can be deployed independently.

## Usage
This package is designed to be consumed by other packages that need common utility functionality. It should be installed first before any dependent packages. 