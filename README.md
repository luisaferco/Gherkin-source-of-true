# Gherkin-source-of-true

# Introducción

Actualmente el diseño de pruebas funcionales, los Test Cases de Azure DevOps y la automatización contienen información duplicada y, en algunos casos, dependencias directas a detalles técnicos como rutas de consultas SQL, endpoints o artefactos de repositorio.

La propuesta de este proyecto consiste en adoptar los archivos Gherkin como la **fuente única de verdad (Single Source of Truth)** para el diseño de pruebas, permitiendo que Azure DevOps se convierta principalmente en una herramienta de trazabilidad, ejecución y reporte.

Para lograrlo, se definió un modelo de transformación basado en los siguientes principios:

* Los escenarios Gherkin describen comportamiento funcional.
* Azure DevOps representa dichos escenarios mediante Test Cases, Shared Steps y Shared Parameters.
* Los detalles técnicos reutilizables (consultas SQL, endpoints, datasets, etc.) se abstraen mediante registros (Registries).
* Los paths físicos, nombres de archivos o estructuras de repositorio no deben aparecer directamente en los escenarios.
* La automatización y la generación de Test Cases consumen un modelo canónico intermedio generado a partir de los Features.

Este enfoque permite:

* Reducir duplicidad entre documentación, pruebas manuales y automatización.
* Mantener trazabilidad entre User Stories, escenarios y ejecuciones.
* Minimizar el impacto de cambios técnicos (renombre de queries, cambios de repositorio, actualizaciones de endpoints).
* Facilitar el uso de IA para generar y sincronizar artefactos de prueba.
* Promover escenarios más legibles para QA, desarrollo y negocio.

Durante este ejercicio se definieron reglas de transformación para elementos como:

* Feature
* Scenario
* Scenario Outline
* Examples
* Background
* Shared Steps
* Shared Parameters
* Queries (Datasource Registry)
* Endpoints (Endpoint Registry)
* Mensajes EDI
* Data Tables

El resultado es una arquitectura donde los archivos Feature describen únicamente la intención funcional, mientras que los detalles de implementación permanecen desacoplados y administrados mediante componentes reutilizables del repositorio.
