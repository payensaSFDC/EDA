# Error Handling Package

## Overview
This package provides a comprehensive error handling framework for Salesforce applications. It captures, stores, and notifies administrators of errors that occur during processing, providing detailed logging and notification capabilities.

## Components

### Apex Classes
- **ERR_Handler**: Core error handling class that processes DML errors and exceptions
- **ERR_ExceptionHandler**: Beautifies exception messages for better user experience
- **ERR_Notifier**: Handles error notifications via email or Chatter
- **ERR_AsyncErrors**: Queueable job to detect and process asynchronous job errors
- **ERR_AsyncErrors_SCHED**: Schedulable class for recurring async error processing
- **ERR_DeleteOutdated_BATCH**: Batch job for cleaning up old error records
- **ERR_DeleteOutdated_SCHED**: Schedulable class for recurring error cleanup
- **ErrorSettings*** classes: Model, service, and controller classes for managing error settings

### Custom Objects
- **Error__c**: Custom object for storing error records with fields for:
  - Error details (type, message, stack trace)
  - Context information (object type, record URL)
  - Notification tracking (email sent, posted in Chatter)

### Custom Labels
- **exceptionRequiredField**: User-friendly message for required field errors
- **stgOptAllSysAdmins**: Label for "All System Administrators" option
- **stgOptUser**: Label for "User" option  
- **stgOptChatterGroup**: Label for "Chatter Group" option

## Dependencies
- **Utilities Package**: Required for debug logging, namespace detection, and settings management

## Key Features
- Automatic error capture from DML operations
- Exception message beautification
- Email and Chatter notifications
- Configurable error storage and notifications
- Automated cleanup of old error records
- Asynchronous error detection and processing

## Usage
Deploy this package after the Utilities package. Configure error handling settings through Hierarchy_Settings__c custom settings object. 