# Naming Conventions

## Purpose

This document defines naming conventions for Canonical Model artifacts and Azure DevOps generated assets.

Consistent naming improves:

- Traceability
- Readability
- Navigation
- Reporting
- Artifact discoverability

The goal is to preserve business readability while maintaining alignment with Feature organization.

---

# Naming Principles

## NC-01 — Names Shall Be Human Readable

Generated artifacts shall use descriptive business-readable names.

Preferred:

```text
Invoice generation with converted interval
```

Avoid:

```text
Test1
ScenarioA
Case123
```

---

## NC-02 — Naming Shall Preserve Traceability

Generated artifacts shall preserve traceability back to:

- Domain
- Subdomain
- Feature
- Scenario

---

# Domain Classification

Feature folder structure shall define business classification.

Example:

```text
features/

INV/
 └── USG/
      └── invoice-generation.feature
```

Classification:

```text
Domain     = INV
Subdomain  = USG
```

---

## NC-03 — Folder Structure Shall Define Classification

Domain and Subdomain values shall be derived from the Feature repository structure.

Example:

```text
features/INV/USG/
```

↓

```text
INV
USG
```

---

# Test Case Naming

Azure Test Cases should preserve both classification and business intent.

Format:

```text
TC_<DOMAIN>_<SUBDOMAIN>_<SEQUENCE> | <Scenario Name>
```

Example:

```text
TC_INV_USG_001 | Invoice generation with converted interval
```

---

## NC-04 — Test Cases Shall Preserve Scenario Names

The Scenario name shall be preserved as the business-readable portion of the generated Test Case.

Example:

```gherkin
Scenario: Invoice generation with converted interval
```

↓

```text
TC_INV_USG_001 | Invoice generation with converted interval
```

---

# Predecessor Work Item Naming

Environment Configuration Backgrounds generate predecessor work items.

Format:

```text
PRE_<DOMAIN>_<SUBDOMAIN>_<SEQUENCE> | <Description>
```

Example:

```text
PRE_INV_USG_001 | Enable Invoice Processing
```

---

## NC-05 — Predecessor Work Items Shall Use PRE Prefix

All generated predecessor work items shall use the PRE prefix.

Example:

```text
PRE_INV_USG_001 | Enable Invoice Processing
```

---

# Shared Step Naming

Shared Steps shall preserve the original Gherkin step description.

No artificial naming convention shall be introduced.

Example:

```gherkin
Given an account from 'Dayton Power Light' utility retrieved with:
```

Azure Shared Step Title:

```text
Given an account from 'Dayton Power Light' utility retrieved with:
```

---

## NC-06 — Shared Steps Shall Preserve Gherkin Descriptions

The Shared Step title shall be generated directly from the originating Gherkin step.

The original step text shall be preserved.

---

## NC-07 — Shared Step Details Shall Preserve Supporting Data

Shared Step definitions shall include supporting artifacts contained within the original step.

Examples:

- Data Tables
- Datasources
- Query aliases
- Parameters

Example:

Gherkin:

```gherkin
Given an account from 'Dayton Power Light' utility retrieved with:

| meterType | Interval |
| datasource | ACCOUNT_BY_METER_UTILITY |
```

Azure Shared Step:

Title:

```text
Given an account from 'Dayton Power Light' utility retrieved with:
```

Steps:

```text
meterType = Interval

datasource = ACCOUNT_BY_METER_UTILITY
```

---

# Dataset Naming

Datasets derive their names from dataset tags.

Example:

```gherkin
@dataset:InvoiceStatus
Examples:
```

↓

```text
InvoiceStatus
```

---

## NC-08 — Dataset Names Shall Be Derived From Dataset Tags

Dataset names shall be generated from:

```gherkin
@dataset:<name>
```

Example:

```gherkin
@dataset:InvoiceStatus
```

↓

```text
InvoiceStatus
```

---

# Shared Parameter Naming

Azure Shared Parameters shall preserve the Dataset name.

Example:

```gherkin
@dataset:InvoiceStatus
```

↓

```text
InvoiceStatus
```

---

## NC-09 — Shared Parameters Shall Reuse Dataset Names

Generated Shared Parameters shall use the Dataset name as their identifier.

No additional prefixes shall be added.

Preferred:

```text
InvoiceStatus
```

Avoid:

```text
SP_InvoiceStatus
Shared_InvoiceStatus
```

---

# Canonical Classification Metadata

The Canonical Model shall preserve classification metadata.

Example:

```json
{
  "classification": {

    "domain": "INV",

    "subdomain": "USG"
  }
}
```

---

## NC-10 — Classification Metadata Shall Be Preserved

Domain and Subdomain metadata shall be maintained throughout the translation process.

---

# Benefits

This strategy provides:

- Consistent naming
- Improved traceability
- Business-readable artifacts
- Azure DevOps compatibility
- Alignment with Feature repository structure
- Reduced naming maintenance

It ensures that generated artifacts remain understandable to both business and technical stakeholders while preserving their relationship to the originating Feature definitions.

## NC-11 - Canonical Titles Shall Follow Naming Convention Rules

Canonical Models shall preserve generated Test Case titles.

Generated titles shall follow Naming Convention rules.


Example for scenario name:

```
TC_INV_PYM_001 | Approve application for an eligible customer
```

Backgrounds shall follow:

```
PRE_INV_PYM_001 | Customer is on credit card application page
```
