# Background Strategy

## Purpose

This document defines how Gherkin Background sections are represented within the Canonical Model and translated into Azure DevOps artifacts.

According to AEPE Gherkin guidelines, a Given represents a precondition for a Scenario.

When a precondition applies to all Scenarios within a Feature, it shall be defined as a Background.

Backgrounds may represent different types of preconditions and therefore require different Azure DevOps representations.

---

# Motivation

Gherkin provides a native mechanism for expressing reusable preconditions.

Example:

```gherkin
Background:
Given Billing API service is available
And a valid utility account exists
```

All Scenarios within the Feature inherit these conditions.

Azure DevOps does not provide a native Background artifact.

A translation strategy is therefore required.

---

# Background Principles

## BG-01 — Backgrounds Represent Shared Preconditions

Backgrounds shall represent preconditions shared by all Scenarios within a Feature.

Backgrounds must not describe the primary business behavior under test.

Preferred:

```gherkin
Background:
Given Billing API service is available
And a valid utility account exists
```

Avoid:

```gherkin
Background:
When invoice generation endpoint is invoked
```

---

## BG-02 — Backgrounds Shall Be Reusable

Background definitions shall be represented as reusable artifacts within the Canonical Model.

Example:

```json
{
  "background": {
    "reusable": true
  }
}
```

---

## BG-03 — Backgrounds Shall Remain Provider Independent

The Canonical Model shall preserve Background intent without introducing Azure-specific concepts.

Preferred:

```json
{
  "reusable": true
}
```

Avoid:

```json
{
  "sharedStep": true
}
```

---

# Background Classification

AEPE defines two categories of Backgrounds.

---

## Setup Background

Represents reusable setup activities required before executing scenarios.

Examples:

```gherkin
Background:
Given Billing API service is available
And user is authenticated
And account exists
```

Characteristics:

- Validates service availability
- Retrieves prerequisite data
- Establishes business context
- Does not modify environment configuration
- Does not require deployment or restart

---

## Environment Configuration Background

Represents environment preparation activities that modify configuration before testing.

Examples:

```gherkin
Background:
Given Consul parameter "EnableInvoiceGeneration" is set to true
And Billing Service is restarted
```

Characteristics:

- Changes environment state
- Updates configuration
- Enables feature flags
- Requires deployment or restart activities
- May require manual execution

---

# Azure Translation Strategy

Background translation depends on its classification.

---

## BG-04 — Setup Backgrounds Shall Generate Shared Steps

Setup Backgrounds shall generate Azure Shared Steps.

Examples:

- Health checks
- Login operations
- Authentication
- Data retrieval
- Business preconditions
- Service validation

Translation:

```text
Background
      ↓
Shared Step
      ↓
Inserted at beginning of generated Test Cases
```

---

## BG-05 — Environment Configuration Backgrounds Shall Generate Predecessor Work Items

Environment Configuration Backgrounds shall generate dedicated predecessor work items.

Examples:

- Consul updates
- Feature Toggle changes
- Infrastructure preparation
- Service restart activities
- Deployment requirements

Translation:

```text
Background
      ↓
[PRE] Work Item
      ↓
Linked as predecessor
      ↓
Business Test Case
```

---

## BG-06 — Background Classification Shall Be Explicit

Backgrounds shall be classified during translation according to the following rules.

| Condition Type | Classification |
|----------------|---------------|
| Service validation | Setup Background |
| Login | Setup Background |
| Authentication | Setup Background |
| Data retrieval | Setup Background |
| Business precondition | Setup Background |
| Consul configuration | Environment Configuration |
| Feature Toggle update | Environment Configuration |
| Service restart | Environment Configuration |
| Infrastructure modification | Environment Configuration |

---

# Shared Step Structure

Setup Backgrounds should generate business-readable Shared Steps.

Example:

Feature:

```gherkin
Background:
Given Billing API service is available
And a valid utility account exists
```

Azure Shared Step:

Title:

```text
Invoice Generation Setup
```

Steps:

```text
1. Verify Billing API service is available
2. Retrieve valid utility account
```

---

# Predecessor Work Item Structure

Environment Configuration Backgrounds should generate dedicated predecessor work items.

Example:

Feature:

```gherkin
Background:
Given Consul parameter "EnableInvoiceGeneration" is set to true
And Billing Service is restarted
```

Azure Work Item:

Title:

```text
[PRE] Enable Invoice Generation
```

Description:

```text
Update Consul parameter:
EnableInvoiceGeneration=true
Restart Billing Service
```

---

## BG-07 — Predecessor Work Items Shall Be Reusable

A single predecessor work item may support multiple generated Test Cases.

Duplicate predecessor definitions should be avoided.

---

# Query Usage Within Backgrounds

Backgrounds may reference Datasources through the Query Registry.

Example:

```gherkin
Background:
Given the BillingParameter "PROCESS_INTERVAL_USAGE_REQUEST" is set to "YES" by
|productType | MISO                     |
| datasource | CONVERT_INTERVAL_PRODUCT |
```

Canonical:

```json
{
  "datasource": "CONVERT_INTERVAL_PRODUCT"
}
```

Physical query resolution remains the responsibility of the Registry layer.

---

## BG-08 — Backgrounds with data set Shall Use Registries

Backgrounds shall follow the Registry rules defined in:

```text
04-registries.md
```

Physical SQL paths shall not appear within Background definitions.

---

# Traceability

Generated artifacts shall preserve traceability to their originating Background definition.

Consumers should be able to identify:

- Feature
- Domain
- Subdomain
- Background Classification
- Referencing Scenarios

Example:

```text
Feature:Invoice Generation

Background:Invoice Generation Setup

Scenario:Invoice with converted interval
```

---

## BG-09 — Background Traceability Shall Be Preserved

Generated Shared Steps and Predecessor Work Items shall maintain traceability to their originating Feature and Background.

---

# Benefits

This strategy provides:

- Clear separation between setup and environment preparation
- Reduced duplication
- Better traceability
- Improved maintainability
- Provider independence
- Consistent Azure DevOps representation

It preserves AEPE Gherkin semantics while enabling efficient translation into Azure DevOps artifacts.
