# Canonical Model

## Purpose

The Canonical Model is the intermediate representation generated from Feature Files and supporting registries.

Its purpose is to provide a stable contract between:

- Gherkin Features
- Azure DevOps generators
- Automation frameworks
- Future integrations

The Canonical Model is the central artifact of the architecture.

```text
Feature Files
       ↓
Canonical Model
    ↙       ↘
Azure      Automation
DevOps
```

---

# Why a Canonical Model?

Without a Canonical Model, every consumer must interpret Gherkin independently.

```text
Feature
   ↓
Azure Generator
```

```text
Feature
   ↓
Automation Framework
```

This often results in duplicated logic and inconsistent behavior.

Instead, the architecture establishes a single interpretation layer.

```text
Feature
   ↓
Canonical Model
   ↓
Consumers
```

This guarantees consistency across platforms.

---

# Responsibilities

The Canonical Model is responsible for:

- Normalizing Gherkin structures
- Preserving traceability
- Preserving logical references
- Representing datasets
- Representing reusable artifacts
- Providing a stable schema for consumers

The Canonical Model is not responsible for:

- Executing tests
- Managing Azure DevOps artifacts
- Running automation
- Resolving runtime data

---

# Canonical Model Structure

At a minimum, the Canonical Model should represent:

- Feature
- Tags
- Background
- Scenario
- Scenario Outline
- Examples
- Steps
- Data Tables
- Datasource References
- Endpoint References

---

# Example Feature

```gherkin
@billing

Feature: Invoice Generation

Background:
  Given the Billing API service is available
  And a utility account exists

Scenario Outline: Generate invoice
  When invoice generation endpoint is invoked
  Then the response status code should be <status>
  And the generated invoice should exist

Examples: QA Dataset
| status |
| 200 |
```

---

# Example Canonical Representation

```json
{ "feature": {},
 "background": {},
 "scenarios": []
}
```

---

# Canonical References

## Classification Metadata

Feature location provides important business classification metadata.

Example:

```text
features/
└── INV/
    └── USG/
        └── invoice_generation.feature
```

Canonical Representation:

```json
{
  "classification": {

    "domain": "INV",

    "subdomain": "USG",

    "featurePath": "INV/USG"
  }
}
```

This metadata allows consumers to generate platform-specific naming conventions while keeping Feature Files business readable.

---

## Background Classification

Backgrounds may represent different reusable concepts.

Examples:

Setup Preconditions
Environment Configuration

Canonical Example:

{
  "background": {
    "classification": "setup"
  }
}

or

{
  "background": {
    "classification": "environment"
  }
}

The Canonical Model preserves the semantic intent of the Background.

Consumers are responsible for translating these classifications into platform-specific artifacts.

Example:

setup
   ↓
Shared Step

environment
   ↓
Predecessor Work Item

---

## Datasources

Preferred:

```json
{
  "datasource": "ACCOUNT_BY_METER_UTILITY"
}
```

Avoid:

```json
{
  "queryPath": "/Database/Bse_Core/AccountProduct/Select/ACCOUNT_BY_METER_UTILITY.sql"
}
```

---

## Endpoints

Preferred:

```json
{
  "endpoint": "invoice_generation"
}
```

Avoid:

```json
{
  "url": "/billing/api/v1/invoices"
}
```

---

## Datasets

```json

{ "datasets":
       [
       { "name": "InvoiceStatus",
        "rows": [ { "status": 200 }
        ]
       }
       ]
}
```

# Canonical Model Rules

## CM-01 — Canonical Model is Mandatory

All consumers shall use the Canonical Model as the integration contract.

Direct Feature-to-Consumer integrations are discouraged.

---

## CM-02 — Canonical Model Must Preserve Intent

The Canonical Model shall preserve the original business intent expressed in Gherkin.

---

## CM-03 — Canonical Model Must Use Logical References

Reusable technical artifacts shall be represented through aliases rather than physical locations.

Examples:

- Datasources
- Endpoints

---

## CM-04 — Canonical Model Must Not Store Physical Paths

Physical repository paths shall remain external to the Canonical Model.

Examples:

- SQL file locations
- Endpoint URLs

---

## CM-05 — Canonical Model Must Support Reusability

Reusable artifacts shall be represented in a way that allows multiple scenarios to consume the same logical definition.

---

## CM-06 — Canonical Model Is Generated

The Canonical Model is a generated artifact.

It should not be manually maintained.

---

## CM-07 — Canonical Model Is Not the Source of Truth

The Canonical Model is derived from Feature Files.

Feature Files remain the authoritative source.

---

## CM-08 — Canonical Model Must Be Provider Independent

The Canonical Model shall not contain platform-specific concepts.

Examples:

Avoid:

```json
{
  "sharedStep": true
}
```

Prefer:

```json
{
  "reusable": true
}
```

The Canonical Model must remain portable across multiple test management platforms.

---

## CM-09 — Canonical Model Must Preserve Classification Metadata

The Canonical Model shall preserve classification metadata derived from the Feature repository structure.

Examples:

- Domain
- Subdomain
- Feature Path

This metadata may be consumed by downstream platforms to generate identifiers, folders, suites or naming conventions.

---

## CM-10 — Canonical Model Shall Preserve Dataset Semantics

Datasets shall be represented independently of platform-specific parameter concepts.

The Canonical Model shall not contain platform-specific concepts such as:

Shared Parameters
Local Parameters

Consumers are responsible for translating datasets into platform-specific parameter artifacts.

This ensures provider independence and portability across test management platforms.

---

## CM-11 — External Test Case References Shall Be Preserved

Scenario tags matching the pattern:

```gherkin
@TC:7231
```
shall be interpreted as references to externally managed Test Cases.

Canonical Example:
```json
{
  "name": "Approve application for an eligible customer",

  "testCaseId": 7231
}
```

When the tag is absent:
```json
{
  "name": "Approve application for an eligible customer",

  "testCaseId": null
}
```
The Canonical Model preserves the reference but does not define creation or update behavior.

---
## CM-12 — DataTables Shall Preserve Their Structure

DataTables shall preserve their original tabular representation within the Canonical Model.

The parser may classify DataTables into one of the following kinds:

| Kind | Description |
|------|-------------|
| kv | Two-column key/value table |
| table | Multi-row business data |
| datasource | Datasource aliases |
| unknown | Parser unable to classify |

Examples:

### Key/Value DataTable

Feature:

```gherkin
When the customer submits an application with:
| Age          | 30   |
| Income       | 5000 |
| Credit Score | 750  |
```

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
      },
      {
        "key": "Credit Score",
        "value": 750
      }
    ]
  }
}
```

---

### Tabular DataTable

Feature:

```gherkin
When a customer purchases products
| sku    | quantity |
| ABC123 | 2        |
| XYZ987 | 1        |
```

Canonical:

```json
{
  "datatable": {
    "kind": "table",
    "headers": [
      "sku",
      "quantity"

    ],

    "rows": [
      {
        "sku": "ABC123",
        "quantity": 2
      },
      {
        "sku": "XYZ987",
        "quantity": 1
      }
    ]

  }
}
```

---

### Datasource References

Feature:

```gherkin
Then generated invoice should be updated
| datasource | INVOICE_BY_ACCOUNT |
```

Canonical:

```json
{
  "datasources": [
    "INVOICE_BY_ACCOUNT"
  ]
}
```
## CM-13 — Canonical Scenarios Shall Preserve Generated Titles

Canonical Scenarios shall preserve the generated Test Case title according to Naming Convention rules.

The generated title shall be independent from provider-specific identifiers.

Example

```gherkin
Scenario: Approve application for an eligible customer
```

Canonical
```json
{
   "title":"TC_INV_PYM_001 | Approve application for an eligible customer",
   "testCaseId":null
}
```

Consumers are responsible for using generated titles when creating provider artifacts.



---
# Consumer Responsibilities

## Azure DevOps

Consumes the Canonical Model and transforms generic concepts into Azure DevOps artifacts such as:

- Test Cases
- Shared Steps
- Shared Parameters

---

## Automation Framework

Consumes the Canonical Model to execute:

- Queries
- API Calls
- Assertions

---

# Benefits

The Canonical Model provides:

- Consistency
- Traceability
- Decoupling
- Reusability
- Extensibility
- AI-friendly processing

It enables Azure DevOps and Automation to evolve independently while remaining synchronized through a common contract.
