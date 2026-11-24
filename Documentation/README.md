# FronTier Insurance System - Technical Documentation Set

Consolidated architecture and developer documentation for the legacy **FronTier (FRONT-TIER) policy, quote and claims system** (Progress 4GL / ABL), compiled from the material in `\\tn-dev08\D1\ftdownload\docs`.

| | |
|---|---|
| Product | FRONT-TIER / FronTier Insurance System |
| Vendors named in sources | Sherwood International Inc. (2002-2003 documents); Concise Technologies Inc. (copyright 1998-2000 in the developer help) |
| Technology | Progress V9 4GL (ABL), AppBuilder/UIB SmartObjects, AppServer, ActiveX controls, Progress RDBMS (Oracle/ODBC through DataServers is stated as optional) |
| Source document dates | Sept 2002 (architecture, method broker), Oct 2002 (coding guidelines), Sept 2002 (core table diagrams), 2003 (workflow setup, Release 6.1), 2024-2025 (ISO form editions) |
| Document status | Reverse-documented from training/help material. Not verified against a running system. |

## How to read this set

| # | Document | Audience | Contents |
|---|---|---|---|
| 01 | [System overview](01-system-overview.md) | Architects, managers | Purpose, goals, design criteria, tiers, module map, runtime components |
| 02 | [Object architecture](02-object-architecture.md) | Architects, developers | B/O, P/O, S/O, S/C, repository, views, lifecycle, versioning, links |
| 03 | [Data model](03-data-model.md) | DBAs, developers | Instance tables, keys and join rules, full core-table catalogue by subject area |
| 04 | [Method broker and coding standards](04-method-broker.md) | Developers | `methrun.i`, parameters, method styles, naming, error and transaction rules, templates |
| 05 | [Development guide](05-development-guide.md) | Developers | Step-by-step build of a business object, primary objects, UI, lifecycle, queries |
| 06 | [Business modules](06-business-modules.md) | Architects, analysts | Entity, Product Modeler, Quote, Policy, Claims, Accounting, Rating, Documents, Batch, Security |
| 07 | [CIM and reporting database](07-cim-and-reporting.md) | Integration, BI | Schema maintenance, metaschema, data mapping, extracts, reporting DB |
| 08 | [Workflow (process control)](08-workflow.md) | Architects, developers | Events, event handler, process, task, model setup (Release 6.1) |
| 09 | [API reference](09-api-reference.md) | Developers | Session, object, code-table, LOB and HTML function libraries, SmartObjects |
| 10 | [Sample code and object-definition catalogue](10-sample-code-catalogue.md) | Developers | Every `.p`, `.df`, `.d`, `objdef` file explained, plus defects found in the samples |
| 11 | [Regulatory forms](11-regulatory-forms.md) | Product, compliance | ISO UM/UIM forms found in the folder |
| 12 | [Source inventory and gaps](12-source-inventory-and-gaps.md) | Everyone | File-to-document traceability, what could not be extracted, risks and open questions |

## Conventions

- **B/O** business object, **P/O** primary object, **S/O** system object, **S/C** system component.
- **BOI** `business_object_instance`, **BOOI** `business_object_obj_inst`, **SOI** `system_object_instance`, **SOOI** `system_object_obj_inst`.
- "Source:" lines name the file in the share the statement came from. Statements marked *(inferred)* are architect interpretation and not stated in the sources.
- Table and field names are shown exactly as in the sources, including source typos.

## Source folder at a glance

```
docs/
  ILN1480723 VA Select Rej UM.pdf              ISO forms (Virginia UIM notice + UM selection)
  ILU056 0125 VA Select Lower UM Limits.pdf    ISO form IL U 056 01 25
  NY UM Selection Form.pdf                     ISO form IL U 004 06 18
  FrontTier Technical Training/
    FrontTier Technical Training Agenda.doc
    Architecture Overview/   lectures, labs L00-L07, schema PDFs, developer help (CHM), sample .df/.p, objdef package, Visio
    The Method Broker/       L08, coding guidelines, Methrun parameters, demo programs
    CIM/                     CIM user guide, reporting DB guide, CIM help (CHM), mapping programs
    Queries/                 two 4GL query examples
    Workflow/                workflow setup PDF (scanned)
  Zip/                       identical copy (verified by file hash, 91 of 91) of FrontTier Technical Training, not documented separately
```
