# 12 - Source Inventory, Traceability and Gaps

## 1. Extraction method

The share is a read-only training/help package. Content was extracted on a local copy so nothing in the source folders was changed.

| Source format | Files | Method | Quality |
|---|---|---|---|
| `.doc` (OLE Word 97-2003) | 19 | Custom parser of the Word binary piece table (text, tables as ` | ` separated rows, headers/footers excluded). Word automation was not usable on this machine. | Text and tables complete. **Embedded screenshots and drawn diagrams are not captured.** |
| `.pdf` with a text layer | 7 | PdfPig text extraction | Good |
| `.pdf` scanned (`workflow setup.pdf`, 33 pages incl. cover) and font-garbled (`ILN1480723 VA Select Rej UM.pdf`) | 2 | Rendered with the Windows PDF API and read with the Windows OCR engine | Readable; spellings of screen labels and some numbers approximate |
| `.chm` | 2 | Decompiled with `hh -decompile`, HTML converted to text in TOC order | Text complete; GIF screenshots and diagrams (about 300) not reproduced |
| `.vsd` Visio | 3 | Attempted stream scan | **Not extracted** (compressed binary) |
| `.p`, `.df`, `.d`, `.def`, `.xml` sources | 61 | Read directly | Complete |
| `Thumbs.db` | 1 | Ignored | n/a |

`Zip\FrontTier Technical Training` was compared file by file by SHA hash with `FrontTier Technical Training` and is **identical (91 of 91 files)**. It was ignored.

## 2. Traceability: source file to document

| Source | Document(s) |
|---|---|
| `FrontTier Technical Training Agenda.doc` | [05](05-development-guide.md) |
| `L00 - Training Agenda.doc` | [05](05-development-guide.md) |
| `L01` to `L07` | [05](05-development-guide.md), [02](02-object-architecture.md) |
| `The Method Broker\L08`, `Methrun Parameters.doc` (x2), `Method Broker.doc` | [04](04-method-broker.md) |
| `Coding Guidelines for FrontTier Methods.doc` | [04](04-method-broker.md), [10](10-sample-code-catalogue.md) |
| `FronTier Architecture and Object Definitions.doc`, `FronTier Architecture and Instance Data.doc` | [02](02-object-architecture.md), [03](03-data-model.md) |
| `FronTier Architecture and Methods.doc`, `Lab Template.doc` | [10](10-sample-code-catalogue.md) (title page / empty) |
| `All FronTier Core Tables.pdf`, `Business Object Architecture Tables.pdf`, `System Object Architecture Tables.pdf` | [03](03-data-model.md) |
| `developerhelp.chm` | [01](01-system-overview.md), [02](02-object-architecture.md), [04](04-method-broker.md), [06](06-business-modules.md), [09](09-api-reference.md) |
| `Central Interface Manager User Guide.pdf`, `How to use Reporting Database.pdf`, `CIM_USER_HELP.chm` | [07](07-cim-and-reporting.md) |
| `workflow setup.pdf` | [08](08-workflow.md) |
| Three ISO form PDFs | [11](11-regulatory-forms.md) |
| `*.df`, `tquote_bo.p`, `pstrtquote.p`, `objdef\*`, `Queries\*`, `CIM\*.p`, `The Method Broker\*.p/.d` | [10](10-sample-code-catalogue.md), [03](03-data-model.md), [07](07-cim-and-reporting.md) |
| `tquote.vsd`, `Training BO LifeCycle.vsd`, `Training Object Model.vsd` | not extracted |

## 3. What this documentation does NOT cover

| Gap | Consequence |
|---|---|
| **No production source code.** The share has one method library (`tquote_bo.p`) and training programs. The standard libraries (`bo-stdmethod`, `po-stdmethod`, `methrun.p`, `fisglobal.p`, lifecycle includes, rating, claims, accounting logic) are not included. | Business rules for rating, cancellation, renewal, claim reserving and accounting cannot be documented from this material. Only their configuration tables and capabilities are described. |
| **No database content or `.df` of the full FronTier schema.** Only three training `.df` files; the core schema is known from diagrams (field names and types, not indexes, area assignments, triggers or sequence definitions beyond `businessobjects` and `systemobjects`). | Index design and referential rules for the 400+ core tables need the real schema. |
| **Screenshots and diagrams** inside Word, PDF and CHM are not captured. They carry dialog layouts and the lecture diagrams (object model, instance data examples). | Dialog field lists were captured where they appear as tables in the text; screen layouts are not. |
| **Visio drawings** (3). | Quote model, lifecycle and object model drawings are described only through the lab text. |
| **Runtime and infrastructure**: AppServer configuration, database sizing, Oracle/Progress version, OS, deployment, backup, batch scheduling setup, user/security administration procedures. | No operations or deployment documentation exists in the share. |
| **Claims and accounting functional detail** beyond capability lists and schema. | See above. |
| **Interfaces** other than CIM (EDI formats, document merge vendors, imaging, fax). | Only table names and vendor field placeholders are known. |
| **Release/version.** The workflow document says "Release 6.1" (2003); the training material is Sept-Oct 2002 and uses Progress V9. Product release of the source is not stated elsewhere. | Treat documented behaviour as 2002-2003 vintage. |

## 4. Inconsistencies in the source material

| Topic | Inconsistency | Handling |
|---|---|---|
| Vendor naming | Sherwood International Inc. (2002-2003 documents) versus Concise Technologies Inc. (copyright on the 1998-2000 help). Product spelled FronTier, FrontTier, Front-Tier, FRONT-TIER, FIS. | Treated as one product. Code prefix `CTI-`/`cti` is the Concise Technologies origin *(inferred)*. |
| `inp-objtype` values | Docs say P/O or B/O; security and CIM calls also use S/O and S/C. | Documented all four. |
| Method library names | Labs generate `tquote.p`; training file is `tquote_bo.p`; the guidelines propose `<id>_bo.p`. | Documented as convention plus the default-library field. |
| Output variable names | `out-defobjseq` versus `out-defpbjseq`; `out-rowidc` versus `iout-rowidc`. | Corrected to the first form. |
| Error handler procedure | `ctimessage.p` and `citmessage.p` both appear. | Both noted. |
| Mapping extract delimiter | CIM guide: Progress DB supports only blank delimiter; sample uses comma. | Flagged in [07](07-cim-and-reporting.md). |
| Reporting DB limitations | CIM help lists "no incremental"; the PDF describes incremental extracts and schema. | PDF treated as current. |
| `TQUOTE` package | Missing Lab 4 attachments; versioning flags off. | Flagged in [10](10-sample-code-catalogue.md). |
| Companies/paths | Examples use `c:\ft\dev\Sherwood\...`, `c:\ft\dev\ssq\...`, `concise/src/apps`, `\MethodLib`. | Listed as seen. |
| "Business Object Architecture Tables.pdf" referenced for "Business Object Definitions" | The pages are titled "Primary Object Definitions" and "Business Object Definitions". | No impact. |

## 5. Architect's assessment *(inferred, not from the sources)*

### Strengths worth preserving
- A single generic instance model (BOI/BOOI plus links) with copy-on-write versioning gives auditability and cheap policy history.
- Metadata-driven UI, security and lifecycle reduce per-product code.
- Product Modeler plus Rating tables allow new products without a deployment.
- CIM gives a documented extraction contract and reporting-database path without touching the production schema.

### Risks for maintenance or migration
| Risk | Why |
|---|---|
| **Query complexity** | Every business query needs BOI -> BOOI -> data joins with `databusinessobjsequence`; mistakes silently return wrong versions (as the sample queries do). |
| **Hidden coupling** | Method libraries are resolved by name from repository rows; workflow events are bound to method names and styles; documents and rating are reached by definition links. Static analysis will miss these. |
| **Vendor-controlled system architecture** | System-object source is not delivered; extension points are limited to configuration, overrides and mapping procedures. |
| **UI technology** | Progress V9 AppBuilder, ActiveX (Microsoft common controls 5.0, ActiveBar, Sheridan list bar, GoControl, Wang Imaging, MSCAL). Several of these are end-of-life. |
| **Coding-standard debt** | The guidelines themselves list legacy behaviour (`METHOD-ERROR` returns, UI in non-visual code, procedure-scoped variables, weak transactions) and the samples still show it. |
| **Data quality of templates** | Sample code and documentation contain defects (see [10](10-sample-code-catalogue.md) section 5). |
| **Skills** | Progress 4GL with this specific object framework. |

### Recommended next steps
1. Obtain the real source tree and a schema dump (`.df`) and run the repository export (`objdef`) for each production object to document actual product definitions.
2. Generate the **SysDoc** output (documented capability) from a running instance and add it to this set.
3. Export Visio drawings to PDF/PNG and OCR or embed the diagrams.
4. Run `buffer_count.p` and the profiler tables to find unstable method libraries (guidelines: over 25-30 buffers).
5. Use CIM with one metaschema for all objects to create a reporting database; this is the least invasive integration and migration data path.
6. Decide a target for the generic instance model before any rewrite: either keep the surrogate-key/version-on-change design or map it to a relational policy schema with explicit versions.
