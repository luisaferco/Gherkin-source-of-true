# Registries

## Purpose

Registries provide a centralized mechanism for resolving reusable technical artifacts referenced by Feature Files.

Feature Files should express business intent.

Technical implementation details should be maintained externally in dedicated registries.

This approach reduces coupling between business specifications and implementation assets.

---

# Motivation

Avoid embedding implementation-specific references directly into Features.

Avoid:

```gherkin
Given an account is retrieved with:

| queryPath | /Database/Bse_Core/AccountProduct/Select/ACCOUNT_BY_METER_UTILITY.sql |
```

Prefer:

```gherkin
Given an account is retrieved with:

| datasource | ACCOUNT_BY_METER_UTILITY |
```

The registry is responsible for resolving the datasource alias into its physical implementation.

---

# Registry Principles

## RG-01 — Features Shall Use Logical References

Feature Files shall reference logical aliases instead of physical locations.

Examples:

- Datasources
- Endpoints
- Templates
- Configuration Sets

---

## RG-02 — Physical Implementations Shall Be Externalized

Physical locations shall be maintained outside Feature Files.

Examples:

- SQL Paths
- Endpoint URLs
- File Locations
- Configuration Files

---

## RG-03 — Registries Shall Be Version Controlled

Registries shall be stored within source control.

This ensures:

- Traceability
- Auditing
- Change history
- Peer review

---

## RG-04 — Registries Shall Be Reusable

A single registry entry may be referenced by multiple Features and Scenarios.

---

## RG-05 — Canonical Model Shall Preserve Logical References

The Canonical Model shall store aliases rather than resolved implementations.

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

# Registry Types

The architecture currently defines the following registry types:

| Registry | Purpose |
|-----------|----------|
| Query Registry | SQL and datasource definitions |
| Endpoint Registry | API endpoint definitions |
| EDI Registry | EDI template definitions |
| Future Registries | Additional reusable artifacts |

---

# Query Registry

## Purpose

The Query Registry provides aliases for SQL-based datasource retrieval and validation.

---

## Query Registry Structure

Example:

```yaml
ACCOUNT_BY_METER_UTILITY:

  path: /Database/Bse_Core/AccountProduct/Select/ACCOUNT_BY_METER_UTILITY.sql

  description: Retrieves account information by utility and meter type

INVOICE_BY_ACCNUMBER:

  path: /Database/Bse_Core/EnergyUsage/Select/INVOICE_BY_ACCNUMBER.sql

  description: Retrieves generated invoice information
```

---

## Feature Usage

```gherkin
Given an account from 'Dayton Power Light' utility retrieved with:

| meterType | Interval |
| datasource | ACCOUNT_BY_METER_UTILITY |
```

---

## Multiple Datasources

A single step may reference multiple datasources.

Example:

```gherkin
Then invoice should be validated using:

| datasource | INVOICE_BY_ACCNUMBER |
| datasource | ENERGY_USAGE_BY_ACCOUNT |
```

---

## RG-06 — Datasource Aliases Shall Be Stable

Aliases shall remain stable even if physical implementations change.

Changing:

```text
ACCOUNT_BY_METER_UTILITY.sql
```

to

```text
ACCOUNT_BY_UTILITY_METER.sql
```

should only require a registry update.

Feature Files should remain unchanged.

---

# Endpoint Registry

## Purpose

The Endpoint Registry provides logical endpoint references.

---

## Registry Structure

Example:

```yaml
invoice_generation:

  url: /billing/api/v1/invoices

  method: POST

invoice_status:

  url: /billing/api/v1/invoices/status

  method: GET
```

---

## Feature Usage

```gherkin
When invoice generation endpoint is invoked
```

Canonical Representation:

```json
{
  "endpoint": "invoice_generation"
}
```

---

## RG-07 — Endpoint URLs Shall Not Appear in Features

Feature Files shall not contain endpoint URLs.

Endpoint resolution shall be performed through the Endpoint Registry.

---

# EDI Registry

## Purpose

The EDI Registry provides logical references to EDI message definitions.

---

## Existing Strategy

Current EDI generation is driven by:

- utility
- transactionCode
- purposeCode

Example:

```gherkin
When an energy usage is sent from utility

| utility | UTL_COMD |
| transactionCode | 867 |
| purposeCode | 00 |
```

This strategy remains valid and does not currently require alias abstraction.

---

## Future Evolution

If EDI complexity increases, a dedicated EDI Registry may be introduced.

Example:

```yaml
USAGE_867_00:

  utility: UTL_COMD

  transactionCode: 867

  purposeCode: 00
```

This remains optional.

---

# Registry Resolution

The architecture follows a two-step resolution process.

```text
Feature
    ↓
Logical Alias
    ↓
Canonical Model
    ↓
Registry Resolution
    ↓
Physical Implementation
```

Example:

```gherkin
| datasource | ACCOUNT_BY_METER_UTILITY |
```

↓

```json
{
  "datasource": "ACCOUNT_BY_METER_UTILITY"
}
```

↓

```text
/Database/Bse_Core/AccountProduct/Select/ACCOUNT_BY_METER_UTILITY.sql
```

---

## RG-08 — Resolution Shall Occur Outside Feature Files

Feature Files shall never perform implementation resolution.

Resolution belongs to:

- Registry Services
- Translators
- Automation Frameworks

---

# Repository Structure

Recommended structure:

```text
repository/

├── features/
│
├── registries/
│   │
│   ├── query-registry.yaml
│   │
│   ├── endpoint-registry.yaml
│   │
│   └── edi-registry.yaml
│
└── docs/
```

---

# Benefits

Registries provide:

- Reduced maintenance
- Improved readability
- Better reusability
- Decoupled implementation
- Provider independence
- AI-friendly processing

They allow Feature Files to remain focused on business behavior while technical implementation details evolve independently.
