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

## AZ-03 — Feature Classification Shall Be Available to Naming Strategies

Feature classification metadata may be consumed by naming strategies when generating Azure DevOps artifacts.

Examples:

- Domain
- Subdomain
- Feature Path
- 
## AZ-04 — Scenario Shall Map to a Test Case

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

## AZ-05 — Scenario Titles Shall Remain Business Readable

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

## AZ-06 — Scenario Outline Shall Map to a Parameterized Test Case

Scenario Outlines may consume one or more Datasets generated from Examples blocks.

Dataset behavior is defined in the Examples Mapping section.

Example:

```gherkin
Scenario Outline: Generate invoice

Then status code response should be <status>
```

↓

```text
Scenario Outline
      ↓
Parameterized Test Case
      ↓
Dataset(s)
```

---

## AZ-07 — Example Variables Shall Become Parameters

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

## AZ-08 — Examples Shall Generate Datasets

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

## Dataset Strategy

Datasets are considered a platform-independent concept.

Azure Shared Parameters are one possible representation of a Dataset.

The Canonical Model shall represent Datasets independently from Azure DevOps concepts.

---

## AZ-09 — Tagged Datasets Shall Preserve Their Metadata

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

## AZ-10 — Shared Parameter Datasets Shall Generate Azure Shared Parameters

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

## AZ-11 — Non-Shared Datasets Shall Generate Local Parameters

Datasets without a shared parameter designation shall generate local Test Case parameters.

---

## AZ-12 — Multiple Examples Shall Generate Independent Datasets

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

## AZ-13 — Given, When and Then Shall Be Preserved

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

## AZ-14 — Step Order Shall Be Preserved

The execution order defined in Gherkin shall be preserved in Azure.

---

# Reusable Step Mapping

## AZ-15 — Reusable Steps Shall Generate Shared Steps

Reusable Canonical Model steps may be translated into Azure Shared Steps.

Examples:

- Background validations
- Reusable setup operations
- Common verification logic

---

## AZ-16 — Shared Step Ownership Belongs to Azure

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

## AZ-17 — Parameters Shall Use Azure Syntax

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

## AZ-18 — Shared Parameters Shall Be Reusable

Only datasets explicitly designated as shared parameter sets shall generate Azure Shared Parameters.

Azure translators shall not infer shared parameter usage automatically.

---

# Traceability

## AZ-19 — Feature Traceability Shall Be Preserved

Generated Test Cases shall maintain traceability to their originating Feature.

Recommended metadata:

- Feature Name
- Domain
- Subdomain
- Scenario Name

---

## AZ-20 — Scenario Traceability Shall Be Preserved

Consumers shall be able to identify the originating Scenario for every generated Test Case.

---

## AZ-21 — Datasource References Shall Be Rendered As Validation Context

Datasource aliases associated with validation steps shall be rendered within the Expected Result section of Azure DevOps Test Steps.

Example:

Feature:

```gherkin
Then the application should be approved

| datasource | CREDIT_CARD_BY_CUSTOMER |
```

Canonical:

```json
{
  "keyword": "Then",

  "text": "the application should be approved",

  "datasources": [

    "CREDIT_CARD_BY_CUSTOMER"

  ]
}
```

Azure DevOps representation:

| Action                                  | Expected Result                              |
| --------------------------------------- | -------------------------------------------- |
| Then the application should be approved | Using datasource:<br>CREDIT_CARD_BY_CUSTOMER |

The Azure Translator may optionally enrich the Expected Result using metadata from the Query Registry.

Example:

| Action                                  | Expected Result                                                                                           |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Then the application should be approved | Using datasource:<br>CREDIT_CARD_BY_CUSTOMER<br><br>Retrieves all credit cards associated with a customer |

---

## AZ-22 — DataTables Shall Be Rendered According To Their Classification

Canonical DataTables shall be rendered according to their classification.

| Kind       | Azure Representation                                   |
| ---------- | ------------------------------------------------------ |
| kv         | Key/Value pairs rendered within the Action             |
| table      | Tabular representation rendered within the Action      |
| datasource | Validation context rendered within the Expected Result |
| unknown    | Translator specific implementation                     |

Example:

Canonical:

```json
{
  "datatable": {
    "kind": "kv",
    "rows": [
      {
        "key": "Age",
        "value": 30
      },
      {
        "key": "Income",
        "value": 5000
      }
    ]
  }
}
```

Azure Action:

```text
When the customer submits an application with:

Age = 30

Income = 5000
```

---

## AZ-23 — Missing Test Case References Shall Create Test Cases

If a Scenario contains:

```json
{
  "testCaseId": null
}
```

The Azure Translator shall create a new Azure DevOps Test Case.

The generated identifier shall be returned to the synchronization process.

---

## AZ-24 — Existing Test Case References Shall Update Test Cases

If a Scenario contains:

```json
{
  "testCaseId": 7231
}
```

The Azure Translator shall update the existing Azure DevOps Test Case.

No additional Test Cases shall be created.

---

## AZ-25 — Created Test Cases Shall Be Propagated Back To Feature Files

After successful creation of a Test Case, the generated Azure DevOps identifier shall be propagated back to the originating Scenario.

Feature before synchronization:

```gherkin
Scenario: Approve application for an eligible customer
```

Azure response:

```text
7231
```

Feature after synchronization:

```gherkin
@TC-7231

Scenario: Approve application for an eligible customer
```

This mechanism enables bidirectional synchronization between Feature Files and Azure DevOps while preserving Feature Files as the Source of Truth.

---

## AZ-26 — Azure Translators May Consume Registries

Azure Translators may consume Registry artifacts to enrich generated Azure DevOps representations.

Examples:

* Query Registry
* Endpoint Registry

Registry resolution shall not modify the Canonical Model.

Example:

Canonical:

```json
{
  "datasources": [
    "CREDIT_CARD_BY_CUSTOMER"
  ]
}
```

Registry:

```yaml
queries:

  CREDIT_CARD_BY_CUSTOMER:

    description: Retrieves all credit cards associated with a customer
```

Azure DevOps representation:

```text
Datasource

CREDIT_CARD_BY_CUSTOMER

Description

Retrieves all credit cards associated with a customer
```

The Canonical Model remains provider independent while allowing Translators to enhance provider-specific artifacts.


## Summary

Azure DevOps acts as a projection of the Canonical Model.

The Canonical Model defines intent.

Azure DevOps defines representation.

This separation allows the same Feature Files and Canonical Model to support multiple test management platforms while preserving consistency and traceability.
