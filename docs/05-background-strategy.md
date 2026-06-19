# Background Strategy

## Purpose

This document describes how Gherkin Backgrounds are represented within the Canonical Model and translated into Azure DevOps artifacts.

Backgrounds are reusable artifacts shared by all Scenarios within a Feature.

Feature Files remain the Source of Truth.

---

# Background Semantics

According to Gherkin semantics, a Background represents preconditions that are true for all Scenarios within a Feature.

Examples include:

* General business rules
* Environment preparation
* Configuration prerequisites
* Service validations
* Authentication contexts
* Test data preparation

Backgrounds are represented as reusable predecessor artifacts.

---

# Canonical Representation

Backgrounds shall be represented within the Canonical Model as follows.

```json
{
   "background":{

      "workItemId":null,

      "name":"PRE_INV_PYM_001 | Customer is on credit card application page",

      "reusable":true,

      "predecessor":true,

      "steps":[

         {

            "keyword":"Given",

            "text":"the customer is on the credit card application page"

         }

      ]

   }

}
```

---

## Properties

| Property    | Description                                       |
| ----------- | ------------------------------------------------- |
| workItemId  | Azure DevOps Work Item identifier                 |
| name        | Predecessor title                                 |
| reusable    | Indicates that the Background may be reused       |
| predecessor | Indicates translation into a predecessor artifact |
| steps       | Gherkin steps composing the Background            |

---

# Naming Convention

Background names should follow Naming Convention rules.

Example

```text
PRE_INV_PYM_001 | Customer is on credit card application page
```

---

# Query Usage Within Backgrounds

Backgrounds may reference Datasources through aliases.

Example

```gherkin
Background:

Given the BillingParameter "PROCESS_INTERVAL_USAGE_REQUEST" is set to "YES" by

| productType | MISO                     |
| datasource  | CONVERT_INTERVAL_PRODUCT |
```

Canonical

```json
{
   "datatable":{

      "kind":"kv",

      "rows":[

         {

            "key":"productType",

            "value":"MISO"

         }

      ]

   },


   "datasources":[

      "CONVERT_INTERVAL_PRODUCT"

   ]

}
```

Backgrounds preserve datasource aliases.

Registries remain execution-time artifacts and are outside the scope of Azure synchronization.

---

# Azure Translation

Backgrounds shall be translated into Azure DevOps predecessor Work Items.

If

```json
{
   "workItemId":null
}
```

Translator action

```text
Create predecessor Work Item
```

If

```json
{
   "workItemId":812
}
```

Translator action

```text
Update predecessor Work Item
```

The Translator is responsible for creating predecessor relationships between Test Cases and their associated Background Work Item.

---

# Feature Synchronization

Background references shall be preserved by the Canonical Model.

Example

```json
{
   "background":{

      "workItemId":812

   }

}
```

Missing references shall be represented as:

```json
{
   "background":{

      "workItemId":null

   }

}
```

Consumers are responsible for creating or updating predecessor Work Items.

---

# Benefits

This strategy provides:

* Reusable Background definitions

* Provider independent Canonical Models

* Simplified Translator implementations

* Bidirectional synchronization

* Reduced Azure DevOps maintenance

* Consistent Background handling across Features

Backgrounds remain business-readable while Azure DevOps provides traceability and reporting capabilities.
