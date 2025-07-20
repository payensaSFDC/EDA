# Salesforce Packages: Utilities, Error Handling, and TDTM

## Overview
This repository contains three independent but interconnected Salesforce unlocked packages that provide foundational functionality for enterprise Salesforce applications:

1. **Utilities Package** - Core utility classes and configuration
2. **Error Handling Package** - Comprehensive error capture and notification framework
3. **TDTM Package** - Table-Driven Trigger Management framework

## Package Structure

```
packages/
├── utilities/                   # Foundation utilities (no dependencies)
│   ├── force-app/
│   │   └── main/default/
│   │       ├── classes/         # UTIL_* utility classes
│   │       └── objects/         # Hierarchy_Settings__c
│   └── README.md
├── error-handling/              # Error handling framework (depends on utilities)
│   ├── force-app/
│   │   └── main/default/
│   │       ├── classes/         # ERR_* and ErrorSettings* classes
│   │       ├── objects/         # Error__c object
│   │       └── labels/          # Error handling labels
│   └── README.md
└── tdtm/                        # Table-Driven Trigger Management (depends on utilities + error-handling)
    ├── force-app/
    │   └── main/default/
    │       ├── classes/         # TDTM_* classes
    │       ├── objects/         # Trigger_Handler__c object
    │       ├── objectTranslations/
    │       ├── tabs/
    │       └── labels/          # TDTM labels
    └── README.md
```

## Deployment Order

Due to package dependencies, deploy in this specific order:

1. **Utilities Package** (no dependencies)
2. **Error Handling Package** (depends on Utilities)
3. **TDTM Package** (depends on Utilities + Error Handling)

## Package Creation Commands

```bash
# Create the packages
sfdx force:package:create --name "Utilities" --description "Core utility classes and configuration" --packagetype Unlocked --path packages/utilities --nonamespace --targetdevhubusername [your-dev-hub]

sfdx force:package:create --name "Error Handling" --description "Comprehensive error handling framework" --packagetype Unlocked --path packages/error-handling --nonamespace --targetdevhubusername [your-dev-hub]

sfdx force:package:create --name "TDTM" --description "Table-Driven Trigger Management framework" --packagetype Unlocked --path packages/tdtm --nonamespace --targetdevhubusername [your-dev-hub]
```

## Package Version Creation

```bash
# Create versions (in dependency order)
sfdx force:package:version:create --package "Utilities" --definitionfile config/project-scratch-def.json --wait 10 --codecoverage --targetdevhubusername [your-dev-hub]

sfdx force:package:version:create --package "Error Handling" --definitionfile config/project-scratch-def.json --wait 10 --codecoverage --targetdevhubusername [your-dev-hub]

sfdx force:package:version:create --package "TDTM" --definitionfile config/project-scratch-def.json --wait 10 --codecoverage --targetdevhubusername [your-dev-hub]
```

## Installation

```bash
# Install in dependency order
sfdx force:package:install --package [Utilities-Package-Version-ID] --targetusername [target-org]
sfdx force:package:install --package [Error-Handling-Package-Version-ID] --targetusername [target-org]
sfdx force:package:install --package [TDTM-Package-Version-ID] --targetusername [target-org]
```

## Key Features

### Utilities Package
- Debug logging utilities
- Namespace detection
- Custom settings management
- Object metadata access
- Shared configuration through Hierarchy_Settings__c

### Error Handling Package
- Automatic error capture from DML operations
- Exception message beautification
- Email and Chatter notifications
- Configurable error storage
- Automated cleanup of old errors
- Asynchronous error detection

### TDTM Package  
- Configurable trigger management
- Multiple trigger handlers per object
- Execution order control
- Field-based filtering
- User exclusions
- Error handling integration
- Asynchronous processing support

## Configuration

After installation, configure the packages through the Hierarchy_Settings__c custom settings object:

- **Error Handling**: Enable/disable error storage, notifications, and debug logging
- **TDTM**: Configure trigger handlers through Trigger_Handler__c records

See individual package README files for detailed configuration instructions.