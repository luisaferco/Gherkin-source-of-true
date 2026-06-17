# Azure Translator Design

## Purpose

This document describes the responsibilities and workflow of the Azure Translator component.

The Azure Translator consumes Canonical Models and Registry Bundles and produces Azure DevOps artifacts.

Feature Files remain the Source of Truth.

Azure DevOps is considered a reporting and traceability platform.

---

# Architecture Overview

# Architecture Overview

```text
Feature Files

        │
        ▼

Canonical Model
        │
        ├──────────────► Azure Translator
        │
        └──────────────► Automation Framework
                              │
                              ├── Query Registry
                              └── Endpoint Registry

Azure Translator
        │
        ▼
Azure Request Builder

        ▼
Azure DevOps REST APIs

        ▼
Translator Result

        ▼
Feature Updater

        ▼
Feature Files
```

---

# Translator Responsibilities

The Azure Translator is responsible for:

- Creating Azure DevOps Test Cases
- Updating existing Azure DevOps Test Cases
- Creating Shared Parameters
- Creating Shared Steps
- Creating predecessor Work Items
- Producing synchronization results

The Translator shall not consume registries.

The Translator shall not modify Feature Files directly.

Feature synchronization is delegated to the Feature Updater.

---

# Translator Input

The Translator consumes:

## Canonical Model

Example:

```json
{
  "feature": {},
  "background": {},
  "scenarios": []
}
```

---

## Registry Bundle

A Registry Bundle contains provider independent registries.

Examples:

```text
Query Registry

Endpoint Registry
```

---

# Translator Decisions

---

## Test Case Creation

Condition:

```json
{
   "testCaseId": null
}
```

Action:

Create Azure DevOps Test Case

---

## Test Case Update

Condition:

```json
{
   "testCaseId": 7231
}
```

Action:

Update Azure DevOps Test Case

---

## Shared Parameter Creation

Condition:

Dataset

```json
{
   "shared": true
}
```

Action:

Create Azure Shared Parameter

---

## Local Parameters

Condition:

Dataset

```json
{
   "shared": false
}
```

Action:

Generate local parameters

---

## Shared Step Creation

Condition:

Background

```json
{
   "classification":"setup"
}
```

Action:

Create Azure Shared Step

---

## Predecessor Creation

Condition:

Background

```json
{
   "classification":"environment"
}
```

Action:

Create predecessor Work Item

---

# Translator Output

The Translator produces a Translator Result.

Example:

```json
{
   "createdTestCases":[

      {

         "scenario":

            "Approve application for an eligible customer",

         "id":7231

      }

   ],

   "updatedTestCases":[

      7300

   ],

   "sharedParameters":[

      "InvoiceStatus"

   ],

   "sharedSteps":[

      812

   ],

   "predecessors":[

      900

   ]

}
```

---

# Feature Updater

Feature synchronization is delegated to the Feature Updater component.

The Feature Updater consumes Translator Results.

Example:

Feature before synchronization:

```gherkin
Scenario:
Approve application for an eligible customer
```

Translator Result:

```json
{
   "id":7231
}
```

Feature after synchronization:

```gherkin
@TC-7231

Scenario:
Approve application for an eligible customer
```

---

# Feature Updater Responsibilities

Feature Updater responsibilities include:

* Adding missing Test Case tags

* Updating existing Test Case tags

* Preserving formatting

* Preserving comments

* Preserving Scenario order

---

# Future Extensions

Potential future providers include:

* Azure DevOps

* TestRail

* Xray

* Zephyr

* qTest

Canonical Models remain provider independent.

Only Translators are provider specific.

---

# Benefits

This architecture provides:

* Feature Files as Source of Truth

* Bidirectional synchronization

* Provider independence

* Registry enrichment

* Reduced Azure maintenance

* Stable Canonical Contracts

* Incremental provider adoption

The Azure Translator enables automated synchronization while preserving business-readable Feature Files.
