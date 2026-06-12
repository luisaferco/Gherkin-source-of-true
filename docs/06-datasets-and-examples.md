# Datasets and Examples

## Purpose

This document defines how Gherkin Examples are represented within the Canonical Model and translated into Azure DevOps artifacts.

Examples provide structured test data for Scenario Outlines.

The architecture introduces the concept of a Dataset as a provider-independent representation of Example data.

---

# Motivation

Gherkin Scenario Outlines allow the same Scenario to be executed with different data combinations.

Example:

```gherkin
Scenario Outline: Invoice with converted interval

Given an account retrieved with:

| meterType | <meterType> |
| datasource | ACCOUNT_BY_METER_UTILITY |

Then generated invoice should have status <status>

Examples:

| meterType | status |
| Interval  | INV    |
| Summary   | WAIT   |
```

Rather than translating Examples directly into Azure artifacts, they are first represented as Datasets within the Canonical Model.

This ensures provider independence.

---

# Dataset Principles

## DS-01 — Examples Shall Generate Datasets

Every Examples block shall generate a Dataset within the Canonical Model.

Example:

```gherkin
Examples:

| status |
| INV |
| WAIT |
```

Canonical:

```json
{
  "dataset": {
    "rows": [
      { "status": "INV" },
      { "status": "WAIT" }
    ]
  }
}
```

---

## DS-02 — Datasets Shall Remain Provider Independent

Datasets are a Canonical Model concept.

The Canonical Model shall not contain Azure-specific concepts such as:

- Shared Parameters
- Test Parameters
- Parameter Tables

These mappings are the responsibility of the Azure Translator.

---

## DS-03 — Dataset Tags Shall Be Preserved

Tags applied to Examples blocks shall be preserved within the Canonical Model.

Example:

```gherkin
@dataset:InvoiceStatus
Examples:

| status |
| INV |
| WAIT |
```

Canonical:

```json
{
  "dataset": {
    "name": "InvoiceStatus"
  }
}
```

---

# Dataset Types

The current architecture defines two Dataset types.

---

## Local Dataset

A Dataset without a dataset tag.

Example:

```gherkin
Examples:

| status |
| INV |
| WAIT |
```

Characteristics:

- Scoped to a single Scenario Outline
- Not reusable
- Generates local Azure parameters

---

## Shared Dataset

A Dataset explicitly identified using a dataset tag.

Example:

```gherkin
@dataset:InvoiceStatus
Examples:

| status |
| INV |
| WAIT |
```

Characteristics:

- Reusable
- Generates Azure Shared Parameters
- May be referenced across multiple Test Cases

---

# Dataset Identification

## DS-04 — Dataset Tags Shall Generate Shared Parameters

Examples blocks tagged using:

```gherkin
@dataset:<name>
```

shall generate Azure Shared Parameters.

Example:

```gherkin
@dataset:InvoiceStatus
Examples:

| status |
| INV |
| WAIT |
```

Azure:

```text
Shared Parameter

InvoiceStatus
```

---

## DS-05 — Untagged Examples Shall Generate Local Parameters

Examples blocks without a dataset tag shall generate local Test Case parameters.

Example:

```gherkin
Examples:

| status |
| INV |
| WAIT |
```

Azure:

```text
Local Parameters
```

---

# Canonical Representation

Example:

```gherkin
@dataset:InvoiceStatus
Examples:

| meterType | status |
| Interval  | INV    |
| Summary   | WAIT   |
```

Canonical:

```json
{
  "dataset": {

    "name": "InvoiceStatus",

    "rows": [

      {
        "meterType": "Interval",
        "status": "INV"
      },

      {
        "meterType": "Summary",
        "status": "WAIT"
      }
    ]
  }
}
```

---

## DS-06 — Dataset Names Shall Be Derived From Dataset Tags

Dataset names shall be derived from:

```gherkin
@dataset:<name>
```

Example:

```gherkin
@dataset:InvoiceStatus
```

↓

```json
{
  "name": "InvoiceStatus"
}
```

---

# Azure Translation

Azure translation depends on Dataset type.

---

## Local Dataset Translation

```text
Examples
      ↓
Dataset
      ↓
Local Parameters
```

---

## Shared Dataset Translation

```text
@dataset:InvoiceStatus
      ↓
Dataset
      ↓
Azure Shared Parameter
```

---

## DS-07 — Shared Parameter Generation Shall Be Explicit

Shared Parameter generation shall never be inferred.

A Dataset must explicitly declare its shared nature using:

```gherkin
@dataset:<name>
```

Examples without dataset tags shall always generate local parameters.

---

# Traceability

Generated Azure artifacts shall preserve traceability to the originating Dataset.

Consumers should be able to identify:

- Feature
- Scenario Outline
- Dataset Name
- Dataset Values

---

## DS-08 — Dataset Traceability Shall Be Preserved

Generated Shared Parameters and Local Parameters shall maintain traceability to the originating Examples definition.

---

# Example

Feature:

```gherkin
Scenario Outline: Invoice with converted interval

Given an account retrieved with:

| meterType | <meterType> |
| datasource | ACCOUNT_BY_METER_UTILITY |

Then generated invoice should have status <status>

@dataset:InvoiceStatus
Examples:

| meterType | status |
| Interval  | INV |
| Summary | WAIT |
```

Canonical:

```json
{
  "dataset": {

    "name": "InvoiceStatus",

    "rows": [

      {
        "meterType": "Interval",
        "status": "INV"
      },

      {
        "meterType": "Summary",
        "status": "WAIT"
      }
    ]
  }
}
```

Azure:

```text
Shared Parameter

InvoiceStatus
```

---

# Benefits

This strategy provides:

- Simpler parsing
- Explicit parameter reuse
- Reduced ambiguity
- Provider independence
- Improved traceability
- Azure DevOps compatibility

It allows Scenario Outline data to remain part of the Canonical Model while enabling controlled translation into Azure DevOps Shared Parameters and Local Parameters.
