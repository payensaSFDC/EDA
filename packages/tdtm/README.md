# TDTM (Table-Driven Trigger Management) Package

## Overview
This package provides a flexible, configurable trigger management framework that allows triggers to be managed through configuration rather than code changes. TDTM enables multiple trigger handlers to run in a controlled sequence with filtering and error handling capabilities.

## Components

### Apex Classes
- **TDTM_TriggerHandler**: Core trigger handler that orchestrates TDTM class execution
- **TDTM_Config**: Configuration management for retrieving TDTM settings
- **TDTM_Runnable**: Abstract base class that all TDTM classes must extend
- **TDTM_Manager**: Utility for managing TDTM configuration programmatically
- **TDTM_DefaultConfig**: Provides default TDTM configuration records
- **TDTM_Global_API**: Public API for interacting with TDTM framework
- **TDTM_Filter**: Advanced filtering functionality for trigger records
- **TDTM_ProcessControl**: Controls when TDTM processing should occur
- **TDTM_TriggerActionHelper**: Helper utilities for trigger actions
- **TDTM_ExcludedUserNames**: Manages users excluded from TDTM processing

### Custom Objects
- **Trigger_Handler__c**: Configuration object that defines:
  - Which classes to run for which objects
  - Trigger actions (Before/After Insert/Update/Delete)
  - Load order and active status
  - Filtering criteria
  - User exclusions

### Custom Labels
- **InvalidFilter**: Error message for invalid TDTM filter configurations

## Dependencies
- **Utilities Package**: Required for debug logging and object metadata access
- **Error Handling Package**: Required for error processing and exception handling

## Key Features
- **Configurable Triggers**: Define trigger behavior through configuration records
- **Multiple Handler Support**: Run multiple trigger handlers in sequence
- **Load Order Control**: Control the execution order of trigger handlers
- **Filtering**: Apply field-based filters to determine when handlers run
- **User Exclusions**: Exclude specific users from TDTM processing
- **Error Integration**: Integrates with error handling framework
- **Asynchronous Support**: Support for asynchronous trigger processing

## Usage
1. Deploy Utilities and Error Handling packages first
2. Deploy this TDTM package
3. Create or configure Trigger_Handler__c records to define your trigger behavior
4. Extend TDTM_Runnable class for your custom trigger logic
5. Call TDTM_TriggerHandler.run() from your triggers

## Example Trigger Implementation
```apex
trigger MyObjectTrigger on MyObject__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    TDTM_TriggerHandler.run(Trigger.new, Trigger.old, Trigger.operationType, Schema.MyObject__c.SObjectType);
}
``` 