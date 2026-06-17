# Introduction

## Purpose

This project proposes using Gherkin Feature Files as the Single Source of Truth (SSOT) for test design.

The objective is to generate Azure DevOps testing artifacts from Gherkin specifications while maintaining a clear separation between:

- Functional behavior
- Technical implementation
- Test management and reporting

Under this approach, Feature Files become the authoritative source for describing business behavior, while Azure DevOps acts as a consumer of generated testing artifacts.

---

## Motivation

In many organizations, test information is duplicated across multiple systems:

- Feature Files
- Azure DevOps Test Cases
- Automation frameworks
- SQL queries
- API catalogs
- Test datasets

Over time, these artifacts diverge, increasing maintenance costs and reducing traceability.

This project aims to eliminate that duplication by establishing a single design source and generating downstream artifacts automatically.

---

## Architecture Overview

The proposed architecture is based on three layers:

```text
                 Feature Files
                        │
                        ▼
                 Canonical Model
                   ╱          ╲
                  ▼            ▼
          Azure DevOps    Automation
```

### Feature Files

Describe business behavior using Gherkin syntax.

Example:

```gherkin
Scenario: Generate invoice
Given utility account exists
When invoice generation endpoint is invoked
Then generated invoice should exist
```

Features must remain readable by QA, Business Analysts, Product Owners, and Developers.

---

### Canonical Model

The Canonical Model is an intermediate representation generated from Feature Files and supporting registries.

Responsibilities:

- Normalize Gherkin structures
- Resolve aliases
- Preserve traceability
- Provide a stable integration contract

The Canonical Model is consumed by Azure DevOps generators and automation frameworks.

---

### Azure DevOps

Azure DevOps is responsible for:

- Test Case storage
- Test execution
- Traceability
- Reporting

Azure DevOps is not considered the primary design source.

---

### Automation Framework

Automation consumes the same Canonical Model used to generate Azure DevOps artifacts.

This guarantees alignment between:

- Designed behavior
- Reported behavior
- Executed behavior

---

# Architectural Principles

## ARCH-01 — Feature Files are the Single Source of Truth

Feature Files shall be considered the authoritative source for test design.

All generated artifacts must originate from Features.

---

## ARCH-02 — Azure DevOps is a Consumer

Azure DevOps shall consume generated artifacts and shall not be considered the primary design repository.

---

## ARCH-03 — Canonical Model is Mandatory

All transformations between Features and external systems shall occur through the Canonical Model.

Direct Feature-to-Azure transformations are discouraged.

---

## ARCH-04 — Functional and Technical Concerns Must Be Separated

Feature Files shall describe behavior.

Technical implementation details shall be managed through registries and supporting configuration.

Examples of implementation details include:

- SQL query paths
- Endpoint URLs
- File locations
- Repository structures

---

## ARCH-05 — Technical Dependencies Must Be Resolvable

Reusable technical artifacts shall be referenced through stable aliases rather than physical locations.

Examples:

```gherkin
| datasource | ACCOUNT_BY_METER_UTILITY |
```

instead of:

```gherkin
| queryPath | /Database/Bse_Core/AccountProduct/Select/ACCOUNT_BY_METER_UTILITY.sql |
```

---

## Expected Benefits

The architecture provides:

- Reduced duplication
- Improved maintainability
- Stronger traceability
- Easier onboarding
- Better support for AI-assisted generation
- Reduced impact of technical refactoring
- Consistent reporting across platforms

---

## Scope

Current scope includes:

- Feature
- Scenario
- Scenario Outline
- Examples
- Background
- Data Tables
- Query Registry
- Endpoint Registry
  
Out of scope for the initial version:

- Doc Strings
- Event Registries
- Payload Registries
- Impact Analysis
- AI Recommendations
