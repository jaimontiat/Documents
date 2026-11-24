# 06 - Business Modules

Sources: developer help *Business Modules* and the module pages (Entity, Rating, Product Modeler, Accounting, Quote/Submission, Policy Administration, Claims Administration, System Company, Document Fulfillment, Batch Process, Security, Reporting, Release Management); *All FronTier Core Tables.pdf*; LOB function library pages. Only the **capabilities listed in the help** and the **tables in the schema diagrams** are documented. Business rule implementations are not part of the share (source delivered separately to customers).

## 1. Module dependency summary

| Module | Depends on | Used by |
|---|---|---|
| Entity maintenance | Security (people record for users) | Quote, Policy, Claims, Accounting, Security |
| Product Modeler | System company, rating | Quote, Policy, Claims |
| Rating engine | Product Modeler (rate book link) | Quote, Policy |
| Quote/Submission | Entity, Product Modeler, Rating, Documents, Workflow | Policy |
| Policy administration | Product Modeler, Rating, Documents, Workflow, Accounting | Claims |
| Claims administration | Product Modeler (reserve codes vs coverage), Documents, Accounting | - |
| Accounting | System company | Policy, Claims |
| Document fulfilment | System company devices | Entity, Quote, Policy, Claims |
| Workflow | Events on any B/O or P/O | All |

## 2. Entity maintenance

Central store of people and companies. Anywhere an entity is needed the system references the central record.

- Unlimited addresses, phones, contacts, and attachments (images, notes, audio).
- **Views** per entity type (agent, broker, insurer, system user, premium payer ...) each with its own model, UI and rules.
- Relationship management: entity-to-entity relationships (`entity_link`), navigable.
- Org chart, locations, resources (working days), positions.
- Business view: every place the entity is referenced.
- Search: phonetic by name (`searchname_po`, soundex), combinations, ranges, status.
- A user created in Security gets a central `people` record. The system user is a view of `ENTITY` (`SYSTEMUSER`).

Tables: see [03](03-data-model.md) section 5. Example view programs: `INSURER` view used by `TINSURER` link.

## 3. Product Modeler (line of business definition)

An **S/O named `LOBDEF`** whose instances define each product (for example "Ontario Auto"). Modelled by system components:

| Component | Purpose | Table |
|---|---|---|
| Policy Definition (`POLICYDEF`) | Policy parameters per jurisdiction: max discount/surcharge, valid payment plans, commissions on plan, generate invoice or payable | `lobpolicy_sc` |
| Lifecycle | Default term months, auto renew, renewal lead days, minimum premium/retained, waived premium limit, rounding, reinstatement rules, retro endorse/reinstate days; cancel types (notice days, grace, calculation method, allow reinstate); renewal rules and days | `loblifecycle_sc`, `loblifecyclecancel_subsc`, `loblifecyclerenewal_subsc`, `loblifecycle_renewal_days` |
| Risks | Risk types and class (for example CAR, TRUCK) | `lobrisk_sc` |
| Coverages | Group, code, premium-bearing, mandatory, default, dependent coverages, valid discounts/surcharges, max discount/surcharge, rate type, allow multiple | `lobcoverage_sc` |
| Endorsements | As coverages | `lobendorsement_sc` |
| Limits, deductibles, statistical codes, base rates | Value tables per coverage/jurisdiction with defaults | `loblimits_table`, `lobdeduct_table_sc`, `lobstat_table`, `lobbaserate_table_sc` |
| Discounts, surcharges, factors, rating factors | Percentage or amount, defaults, manual override, display order | `lobdiscounts_sc`, `lobsurcharges_sc`, `lobfactors_sc`, `lobratefactors_sc` |
| Flags and questions | Underwriting flags, questions with response type, thresholds, rule program | `lobflags_sc`, `lobquestion_sc` |
| Documents | Per policy/risk/coverage/endorsement form rules: mandatory/optional/default transactions, copies, device, rule program, lock with policy, allow multiple per term/object | `lobdocdef_table` |
| Billing items | Billing code, jurisdictions, tax codes, allow manual update, invoice broker | `lobbillitemtype_subsc` |
| Producers and insurers | Valid producers (licence), valid insurers (effective/expiry) | `validproducerlink_sc`, `validinsurerlink_sc` |
| Commissions | By producer type and transaction type | `lobprodcomm_sc`, `lobprodcomm_subsc` |
| Ratebook link | Which rate book applies, transactions, effective/expiry, activation, legal approval | `ratebooklink_sc`, `lobrating_sc` |
| Claim types, claim coverage map | Which claim B/Os apply; reserve subfile to coverage mapping | `lobclaimtypes_sc`, `lobcovclaim_table_sc` |
| Validation and concern definitions | Rules, levels and prerequisites tied to lifecycle status | `validationdef_sc`, `validationleveldef_sc`, `concerndef_sc`, `concernleveldef_sc` |
| Report servers | Report server connection details | `lobreportservers_sc` |
| EDI | `lobedidef_table` |

Key properties: new lines of business are added **without programming**; the generic policy administration screen shows default lifecycle; statutory reporting codes can be tracked at any level; basic premium administration integrates with accounting.

Policy and quote B/Os are **linked to a LOBDEF instance by definition link**. Run-time lookups walk that link through functions (for example `CTIGetRatebook`, `CTIGetInsurer`, `CTIGetRisks`, `CTIGetValidCoverages`, `CTIGetPolicyDocument`, `CTIProducerCommision`, `CTI-GetJurisdictions`; see [09](09-api-reference.md)).

## 4. Rating engine

- **Ratebook** object (`ratebook_so`, with `ratebook_id`, `transaction_effective`, `activated_date`, `deactivated_date`): encapsulates structure, algorithms and tables, version-controlled, can hold external attachments, and can generate a ratebook report documenting structures, algorithms and tables.
- **Rating tables** (`ratingtable_sc`, `ratingtablefields_subsc`, `ratingtabledata_subsc`): generic user-defined tables created without DB or UI work; up to six index columns (`index1..6`) and up to 20 data columns (`data[1..20]`); multi-field return from one query; import/export; 4GL access helper (`CTI-GetTableList`).
- **Rating algorithms** in Progress 4GL, tracked **per transaction type**, annual premium returns.
- Newer process-driven model: `ratingprocess_sc` / `ratingprocess_subsc` (steps with procedure type, internal procedure, method level/name/style/object/view, async processing, instance-based), `ratinginout_*` (input/output node and attribute definitions), `ratingsttable_sc` (static tables with their own data table).
- Original "black box" model: `ratingalgorithm_sc`, `ratingphase_sc`, `ratingstep_sc`, `ratingobject_sc`, `ratingitem_sc`.
- **Rating test suite**: suites, runs, test cases, XML definitions, test data nodes/attributes, expected vs actual comparison.
- Quote/policy rating is effective-date driven; per-coverage rate type, manual override and base rate are stored on `coverage_object` and `endorsement_object`; rate book selection and `newer_available`/`uw_approved` on `ratebookselect_po`.

## 5. Quote/Submission

Lifecycle from submission to decision; multiple quote versions for comparative rating; tracks accepted/rejected/declined; auto-creates and binds a policy when accepted and validated.

Features: notes, attachments, complex query for submission clearance, integrated effective-date rating, unlimited premiums, taxes, discounts, surcharges, version retention, audit, history, copy quote, workflow triggers (diary, notes, abeyance), Word/Excel integration for form letters, document fulfilment interface (real-time and batch, history, multilingual).

Data: `quote_object`, coverages, endorsements, discount/surcharge, flags, questions, score, producer, rate factors; premium tables; `business_object_transaction`.

## 6. Policy administration

Life cycle from binding through the entire history: endorsement, cancellation, reinstatement, renewal. Default lifecycle for all lines, overridable per line of business at any point.

Features listed: unlimited notes, attachments and workflow processes per transaction; full online history and user audit log; short and extended term policies; **new business** (from bound quote, direct, or import; document and workflow triggers); **endorsements** (lifecycle tracking, unlimited changes, reason codes, back-dated and future-dated, discard rejected, out-of-sequence, cross-term, document/workflow triggers).

Tables: `policy_object` (renewal flags, cancel details, non-renewal reason, `from_quote_*` trace), versioning through `busobjsequence`/`version_group`/`in_force`, conflicts through `business_object_inst_conflict`, billing through the billing tables.

## 7. Claims administration

Initial reporting and assignment through investigation, adjustment, reserving, payment and closure; reopen. Uses the Product Modeler for line-specific rules and reserve codes against coverage.

Features: unlimited notes, attachments, workflow processes, loss details and third-party interests (mortgagees, lien holders, lessors) per loss detail; assignment of adjusters, examiners, supervisors at claim, claimant and reserve sub-file level; **processing thresholds and required approval overrides** (`secthreshold_sc`); close/reopen; totals per claimant and claim (reserved, outstanding, paid, recovery, incurred); full transaction history online (reserve creation, payments, increases, decreases, closure, reopen, recoveries); document and workflow triggers; unlimited claimants with employer, wage and injury details.

Data model: claim = `baseclaim_bo`; incident = `claimevent_bo`; claimants, reserve sub-files, reserves, reserve changes, payments, loss, expense, recovery, transaction and amount summary tables (see [03](03-data-model.md)). Claim GL distribution is configured in system company (`claim_codes_sc`, `claims_gldistr_subsc`).

## 8. Accounting

Premium and claim-related accounting only; not general corporate accounting (for example not rent or expenses). Data can be uploaded to a corporate system in full or summarised.

- Bank accounts: create, maintain, reconcile premium bank accounts; manual transactions identified.
- **Accounts receivable**: agency bill, direct bill; cash receipts with unapplied credit; reverse/delete; full or line-item reconcile; auto, semi-auto, manual matching; debit/credit memos; auto-waive small differences; statements of open items; manual billing.
- **Accounts payable**: tax and company payables (filer, inspection ...), outstanding payables by company/entity and due date, select for clearance, check-request data for third-party check software or corporate AP, reconcile against AP bank account, stop payment (reverse).
- **General ledger** chart, accounts, transactions with source reference; GL groups and sub-groups; `glidentity_sc` ties named identities to GL codes.
- **Billing**: payment plans (down payment %, instalments, service charge, delay, minimum days between), payment methods (lead days), terms, billing codes and rates by jurisdiction/LOB/effective date, billing plan per policy with overrides.
- System company supports multiple currencies through `accountingpref_sc.base_currency`.

## 9. System company

Single controlling company: chart-of-accounts link, accounting preferences, data/access security preferences, document fulfilment preferences (`docprefs_sc`), licence information (`productlicense_sc`), policy preferences, devices (`device_sc`), assembler and router vendors, cancel types, I/O control for external file interfaces (`iocontrol_sc`, `iocontroldetails_subsc`), custom attributes.

## 10. Document fulfilment

Production system for output documents defined in Document Fulfillment Maintenance and requested from other modules; routes to devices (print, fax, e-mail, file) defined in Device Management; third-party integration points for fax, e-mail, imaging.

- **Authoring**: Word template documents, third-party authoring tools, version control, multilingual, virtual device linking, catalogue (`docdef`, `docdef_attrib`, `docset*`, `doctypes`, `extractdef`).
- **Production**: online or batch, print queue (`printque_so` and sub-objects), print production admin, print destination management, print server, advanced routing (e-mail, file), history retained for reprints (`documenthistory_subpo`).
- Documents attach to B/Os through `documents_po`, and to the B/O definition through the Documents tab and `lobdocdef_table`.

## 11. Batch processing

Scheduled and date-driven processes such as automatic renewal and policy expiry (`batchprocess_so`, `batchprocesslog_subso`, `batchchildprocess_sc`).

- Scheduling: date/time, recurring (daily, weekly, monthly, yearly) with interval, working-day aware, weekday-only, next working day.
- Execution on the AppServer (`runonappserver`, `defaultappserver`) to cut network traffic; parallel child processes; polling with interval and auto start/stop; virtual user (`virtualuser_loginid`).
- Audit and error logs: online view, purge, print/export, rerun or reschedule. E-mail notify on completion.
- Batch process names visible in the Event Handler setup screenshot (OCR of a scanned page, spellings approximate): `POLICY`, `POLICY-ACTIVATE`, `POLICY-...RENEWAL` (three variants), `PROCEDE-EXPORT`, `PROCEDE-MAPPING`, `REPORTDBEXTRACT`, `TEMP-PURGE`, `TEST`, `WORKFLOW-EVENT`.

## 12. Security

- Group security: inclusion and exclusion models; users in one or more groups; user-level override (`secgroup_so`, `systemuser_so`, `secmenu_sc`, `secmethod_sc`, `secfield_sc`, `secthreshold_sc`).
- **Method-level security**: checked by the broker before each method call (`CTI-Security-Check`: object type, id, context, view, method, style, as-of date; returns YES/NO). Entries can be object, definition or object-sequence level and exclude flags.
- **Field-level**: `secfield_sc` (`allow_edit`, `allow_view`, method and attribute lists).
- Thresholds by area/function (for example claim approval limits).
- Pass-through NT login; password policy (`securitypref_sc`: lifetime, max tries, disable after max, logging file); `securitylog` records logins; virtual users for batch.
- Audit configuration and tracking at group or user level.

## 13. Reporting administration

Front end to predefined report templates: scheduling and delivery, AppServer execution. Tables: `reportingcatalog_so`, `reportdef_sc` (report id, server, external location, imaging flag), parameter defaults and overrides, `reportsetup_po`, `reportreq_po` (request queue with priority and due date), `reportsched_subpo`, `reportsecurity_subpo`.

## 14. Release management and SysDoc

Track releases in various states, generate release notes and instructions, issues and tasks. SysDoc generates HTML system documentation from repository data on demand.

## 15. EDI and external interfaces

`lobedidef_table`, `editrans_po`, `edisubmission` (EDI type, id, method, submission, mapping id, external file, error, purge, storage type) with mapping through CIM ([07](07-cim-and-reporting.md)); `iocontrol_sc` for file paths and transmit numbers.

## 16. JSP development tools

`jspviewer_so` / `jspviewer_sc` describe web page layouts (table attributes, field rows/columns, widget type, list values, JavaScript functions, mandatory flag). Methods with style `JSP` (`NEW-JSP`, `DELETE-JSP`, `SAVEUPDATE-JSP`) exist in the exported `TINSURER` definition, which indicates a web channel in later releases.
