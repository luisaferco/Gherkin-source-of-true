# Azure Mapping Rules

## Purpose

This document defines how Canonical Model concepts are translated into Azure DevOps artifacts.

The Canonical Model remains platform-independent.

Azure DevOps is treated as a consumer of the Canonical Model and is responsible for transforming generic testing concepts into Azure-specific artifacts.

```text
Feature Files
      ↓
Canonical Model
      ↓
Azure Translator
      ↓
Azure DevOps
```

---

# Translation Layer

The Azure Translator is responsible for converting Canonical Model concepts into Azure DevOps artifacts.

Examples:

| Canonical Concept | Azure DevOps Artifact |
|-------------------|----------------------|
| Scenario | Test Case |
| Reusable Step | Shared Step |
| Dataset | Shared Parameter |
| Feature Classification | Test Suite Structure |
| Tags | Test Case Metadata |

This separation allows future integrations with other platforms such as:

- Jira Xray
- Zephyr
- TestRail

without modifying the Canonical Model.

---

# Feature Mapping

## AZ-01 — Feature Shall Map to Azure Test Suite Structure

Features shall be represented within Azure Test Plans using Test Suites.

Feature classification metadata may be used to organize suites.

Example:

Repository Structure:

```text
features/
└── INV/
    └── USG/
        └── invoice_generation.feature
```

Generated Structure:

```text
INV
└── USG
    └── Invoice Generation
```

---

## AZ-02 — Feature Metadata Shall Be Preserved

Feature metadata shall be available to Azure consumers.

Examples:

- Tags
- Domain
- Subdomain
- Feature Name

---

# Scenario Mapping

## AZ-03 — Scenario Shall Map to a Test Case

Each Scenario shall generate one Azure Test Case.

Example:

```gherkin
Scenario: Generate invoice
```

↓

```text
Test Case
Generate invoice
```

---

## AZ-04 — Scenario Titles Shall Remain Business Readable

Generated Test Case titles shall prioritize readability.

Preferred:

```text
Invoice generation with summary
```

Avoid:

```text
TC_INV_USG_01_Invoice_generation_with_summary
```

Naming conventions are defined separately in:

```text
09-naming-conventions.md
```

---

# Scenario Outline Mapping

## AZ-05 — Scenario Outline Shall Map to a Parameterized Test Case

Scenario Outlines may consume one or more Datasets generated from Examples blocks.

Dataset behavior is defined in the Examples Mapping section.

Example:

```gherkin
Scenario Outline: Generate invoice

Then status code response should be <status>
```

↓

```text
Test Case
Shared Parameters
```

---

## AZ-06 — Example Variables Shall Become Parameters

Example placeholders shall be transformed into Azure parameters.

Example:

```gherkin
<status>
```

↓

```text
@status
```

---

# Examples Mapping

# Examples Mapping

## AZ-07 — Examples Shall Generate Datasets

Each Examples block shall be represented as a Dataset within the Canonical Model.

Example:

```gherkin
Examples: QA Dataset

| status |
| 200 |
```

↓

```json
{
  "dataset": {
    "name": "QA Dataset"
  }
}
```

---

## AZ-08 — Tagged Datasets Shall Preserve Their Metadata

Tags applied to Examples blocks shall be preserved.

Example:

```gherkin
@dataset:QA
Examples: QA Dataset
```

↓

```json
{
  "dataset": {
    "name": "QA Dataset",
    "tags": [
      "dataset:QA"
    ]
  }
}
```

---

## AZ-09 — Shared Parameter Datasets Shall Generate Azure Shared Parameters

Datasets explicitly tagged as shared parameter sets shall generate Azure Shared Parameters.

Example:

```gherkin
@shared-parameter:InvoiceDataset
Examples: Invoice Dataset
```

↓

Azure Shared Parameter

InvoiceDataset

---

## AZ-10 — Non-Shared Datasets Shall Generate Local Parameters

Datasets without a shared parameter designation shall generate local Test Case parameters.

---

## AZ-11 — Multiple Examples Shall Generate Independent Datasets

Each Examples block shall be represented independently.

Example:

```gherkin
@dataset:QA
Examples: QA Dataset

@dataset:UAT
Examples: UAT Dataset
```

↓

QA Dataset

UAT Dataset
---

# Step Mapping

## AZ-12 — Given, When and Then Shall Be Preserved

The Azure translation shall preserve step intent.

Example:

```gherkin
Given utility account exists

When invoice generation endpoint is invoked

Then generated invoice should exist
```

↓

```text
Given utility account exists

When invoice generation endpoint is invoked

Then generated invoice should exist
```

---

## AZ-13 — Step Order Shall Be Preserved

The execution order defined in Gherkin shall be preserved in Azure.

---

# Reusable Step Mapping

## AZ-14 — Reusable Steps Shall Generate Shared Steps

Reusable Canonical Model steps may be translated into Azure Shared Steps.

Examples:

- Background validations
- Reusable setup operations
- Common verification logic

---

## AZ-15 — Shared Step Ownership Belongs to Azure

The Canonical Model shall not contain Azure-specific concepts.

Preferred Canonical Representation:

```json
{
  "reusable": true
}
```

Azure Translation:

```text
Shared Step
```

---

# Parameter Mapping

## AZ-16 — Parameters Shall Use Azure Syntax

Example variables shall be translated into Azure parameter notation.

Example:

```gherkin
<status>
```

↓

```text
@status
```

---

## AZ-17 — Shared Parameters Shall Be Reusable

Generated Shared Parameters should be reusable across multiple Azure Test Cases whenever possible.

---

# Traceability

## AZ-18 — Feature Traceability Shall Be Preserved

Generated Test Cases shall maintain traceability to their originating Feature.

Recommended metadata:

- Feature Name
- Domain
- Subdomain
- Scenario Name

---

## AZ-19 — Scenario Traceability Shall Be Preserved

Consumers shall be able to identify the originating Scenario for every generated Test Case.

---

# Provider Independence

## AZ-20 — Azure Concepts Shall Not Leak Into the Canonical Model

Concepts such as:

- Shared Step
- Shared Parameter
- Test Suite

shall remain Azure-specific implementation details.

Equivalent concepts may exist in other platforms.

The Canonical Model shall remain provider-neutral.

## Dataset Strategy

Datasets are considered a platform-independent concept.

Azure Shared Parameters are one possible representation of a Dataset.

The Canonical Model shall represent Datasets independently from Azure DevOps concepts.

---

## Summary

Azure DevOps acts as a projection of the Canonical Model.

The Canonical Model defines intent.

Azure DevOps defines representation.

This separation allows the same Feature Files and Canonical Model to support multiple test management platforms while preserving consistency and traceability.
