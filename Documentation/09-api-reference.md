# 09 - API Reference

Sources: developer help chapter 6 and *Smart Objects* (chapter 7), plus the "Function" pages for Fis-Global, Genobjfunct, Sysobjfunct, Codetablefunct, System Company and Line of Business libraries. Signatures are reproduced as documented; the help contains typographical errors (noted where relevant). Return-value notation: **P** procedure, **F** function.

## 1. Session and broker: `fis-global.p` (`ghn_globals`)

| Name | Kind | Inputs | Returns / purpose |
|---|---|---|---|
| `CtiSessionDate()` | F | - | Session date (use for `inp-asof`) |
| `CtiSessionTime()` | F | - | Session time (integer) |
| `CTIAuditDate`, `CTIAuditTime` | F | - | Date / time used for audit records |
| `CTIGetGlobal(name)` | F | attribute name | Value of a global attribute. Set from `fis-start`: `FISDIRECTORY`, `FISEnvironment`, `FISBROWSER`, `fishelp`, `WordProcessor`, `SpreadSheet`, `EmailType`, `Notepad`, `Imaging`, `Attachment`, `workdesklist`, `EntityBONumber`, `SecGroupAdditive`, `UseGLGroups`, `BOMethodLib`, `Environment`, `formtemplate`, `formdata`, `formstorage`, `checkmergetemplate`, `checkmergeprinter`; custom ones via `setglobal` |
| `setglobal(name, value)`, `showglobal` | P | | Set or display (MESSAGE) global attributes |
| `CTI-Security-Check` | P | object type (S/O, B/O, S/C, P/O), id, context, view, method, style, as-of, parentobjseq | `RETURN-VALUE` YES or NO |
| `getmethod` | P | view, method, type, id, context, as-of, style, parentobjseq | `out-proced`, `out-procedtype`, `out-audit`, `out-persistent`, `out-visual`, `out-dbaction` |
| `CTIGetError(error-id)` | F | `PROGRESS` or FT error ID | Message text (last Progress message for `PROGRESS`) |
| `CtiGetSoundex(text)` | F | string | Soundex equivalent |
| `CTISearchSource(program)` | F | program name | Full path (looks for `.r` etc.) or `?` |
| `CompareTables` | P | two buffer handles, field list (CAN-DO syntax: `"*"`, `"!Field1,*"`) | Output field list and value lists separated by `CHR(4)` |
| (rating table lookup) | P | | The help states `fisglobal.p` provides a procedure for rating table lookups and one for auditing method calls, but does not document their names or parameters |

## 2. Business object and primary object functions: `genobjfunct.i`

| Name | Kind | Parameters | Purpose |
|---|---|---|---|
| `CTI-COPYBO` / `CtiCopyBO` | P | from BOI rowid, to BOI rowid | Copy instance-related records (premium, BOOI) of a B/O instance; returns YES/NO |
| `CTI-COPYPO` / `CtiCopyPO` | P | P/O id, target BOI, source BOOI, parent objectnum, OUTPUT new BOOI | Copy a P/O instance with related records and data; returns new BOOI rowid string |
| `CTI-UPDATEBO` / `CtiUpdateBO` | P | BOI rowid, comma list of types (`STATUS`, `CURRENT-STATUS`, `VERSION-TYPE`, `EFFECTIVE`, `EXPIRY`), matching value list | Update BOI and its BOOIs; `llo-process-ok` |
| `CtiCreateBO` | P | B/O id, view | Create new BOI; returns rowid string |
| `CtiCreateBOView` | P | BOI rowid, view | Create view record |
| `CtiCreateBOLink` | P | BOI A, BOI B, relationship | Create `business_object_inst_relate` |
| `CtiCreateFinancial` | P | businessobjectnum, entry type, description, amount | Create `business_object_financial` |
| `CtiCreateTransaction` | P | BOI rowid, transaction type, description, pre-status, post-status | Create `business_object_transaction` |
| `CtiCreatePO` | P | P/O id, BOI rowid, parent object definition sequence | Create BOOI |
| `CtiGetPOLinkRowid` | P | bonum, boseq, parent objectnum, P/O type | Linked BOI rowid |
| `CtiNewVersionBO` | P | BOI rowid | New version of BOI and children; returns new rowid string |
| `CtiNewVersionPO` | P | target BOI, source BOOI | New version of BOOI and children |
| `CtiSetPOLinks` | P | BOOI, P/O link definition rowid, link-to BOI/SOI, view, objectnum | Set up `business_ooinst_links` |
| `CtiSetPOParent` | P | BOOI, parent BOOI | Set parent objectnum |
| `CtiUpdateBO` | P | as above | Runs `CTI-UPDATEBO` |
| `CtiGetBODef` | F | B/O id, object sequence, P/O id, as-of, info type (`business_object_type`, `business_object_definition`, `business_object_objects`) | Rowid of definition table |
| `CtiGetBOProperty` | F | company, object id, property key | Property value |
| `CtiGetPOLinkInfo` | F | link rowid, `VISUALID` or `ROWID` | Linked info |
| `CtiGetPOLinks` | F | BOOI | Comma list of P/O definition links |
| `CtiGetPOseq` | F | BOOI buffer, BOI buffer | Parent object definition sequence |
| `CtiNextBO` | F | - | Next `businessobjectnum` (sequence `businessobjects`) |
| `CtiNextPO` | F | BOI rowid | Next `objectnum` |
| `CtiVersionBOData` | F | company, B/O id | Is Version Data on? |
| `CtiVersionPOData1` | F | company, B/O id, object sequence | Is the BOO version-data flag on? |

## 3. System object functions: `sysobjfunct.i`

Equivalents for S/O and S/C: `CTI-COPYSC`, `CTI-COPYSO`, `CTI-UPDATESO`, `CtiCopySC`, `CtiCopySO`, `CtiCreateSC`, `CtiCreateSO`, `CtiCreateSOLink`, `CtiCreateSOTrans`, `CtiCreateSOView`, `CtiNewVersionSC`, `CtiNewVersionSO`, `CtiSetSCLinks`, `CtiSetSCParent`, `CtiUpdateSO`, `CtiGetSCLinkInfo`, `CtiGetSCLinks`, `CtiGetSODef` (`system_object_type`, `system_object_definition`, `system_object_objects`), `CtiGetSOProperty`, `CtiNextSC`, `CtiNextSO` (sequence `systemobjects`), `CtiVersionSCData`, `CtiVersionSOData`. Parameters mirror the B/O set with SOI/SOOI rowids.

## 4. Code (generic) tables: `ico00f02.i`, `codetablefunct.i`

| Name | Purpose |
|---|---|
| `CTIGetTableCODE(tableid, date)` | Comma-delimited codes of the table effective on the date. Missing table returns `NO codetable!` |
| `CTIGetTableDESC(tableid, date, language)` | Descriptions in the language if the table is multilingual. `No Translation` if no `codetablelang` rows |
| `CTIgetCodTable` | Fill a `codetable` buffer for company, table, as-of |
| `CTIgetCodeTableDesc` | Description for a code in a language |
| `CTIgetCodeTableItems`, `CTIgetCodeTableList` | Delimited list of descriptions or codes; list variant returns `NO Code Table Data !` if none |
| `CTILoadComboBox` | Populate a combo-box widget |
| `{icombbox.i &type="LOADITEMS" ...}` | Include used by the Table combo-box template; requires `i-global` and `ico00f02.i`; items loaded on ENTRY trigger; template viewers call `openframecombobox` from `CTI-initialize` |

Tables: `codetablegroup`, `codetable` (`tableid`, `version`, `multi_lingual`, `display_type`, `version_control`, `multi-company`, `is_specific`, `spec_program`), `codetabledata` (`char_value`, `date_value`, `int_value`, `dec_value`), `codetablelang`. Example `ADDRESSTYPE` returns `Billing,Business,Home,Other`.

## 5. System company library: `syscomp-funct.i`, `syscompbilling.i`

Pattern: function `CTIGetXxx(...)` calls `CTI-GetXxx.p`, which uses `CTI-FindRecords(SYSTEM_COMPANY)` and returns a delimited list selected by `runtype`.

| Component | Function | Table | Notes |
|---|---|---|---|
| Accounting preferences | `CTIGetAcctPreference` / `CTIGetAccPreference` | `accountingpref_sc` | Runtype `CURRENCY`, `DATA-ROWID`, `INST-ROWID` |
| Terms | `CTIGetTerm`, `CTIGetTermPick`, `CTIGetTermDue` | `termtable_sc`, `entity_bo.term_code` | Due date from `num_of_days` |
| Payment plans | | `paymentplans_sc` | |
| Billing codes | `CTIGetBillingCode`, `CTIGetBillingRate`; `f_billcode_des/gl/type/list`, `f_billdes_*`, `f_billgl_*` | `billitemcodes_sc`, `billitemrates_subsc` | Runtype `CODES`, `TYPES`, `GLCODES`, `FUTUREGLCODES`, `DESCRIPTIONS`, `DATA-ROWID`, `INST-ROWID`; rate by company, currency, code, jurisdiction, LOB, as-of |
| GL chart link | `CTIGetGLChart` | `glchart_so` | |
| GL identity | `CTIGetGLIdentity` | `glidentity_sc` | Runtype `GLCODES` etc. |
| Devices | `CTIGetDevices` | `device_sc` | |

## 6. Line of business library: `lobfunct.i`

Common input is the ROWID of the system object instance (`LOBDEF`) plus jurisdiction. `CTI-FindRecords(POLICYDEF)` locates the `POLICYDEF` component instance.

| Function | Table | Returns |
|---|---|---|
| `CTI-GetLOBPolicyDEF` | | ROWID string of the `POLICYDEF` SOOI |
| `CTI-GetJurisdictions` | `lobpolicy_sc` | `jurisdictions` |
| `CTIGetPolicyData` | | policy-level LOB data |
| `CTIGetMandPolicyCoverages`, `CTIGetDefaultPolicyCoverages` | `lobcoverage_sc` | `code,group,description` list (flag MANDATORY or DEFAULT; negated with `!`) |
| `CTIGetMandPolicyEndorse`, `CTIGetDefaultPolicyEndorse` | `lobendorsement_sc` | `id,group,description` |
| `CTIGetRisks` | `lobrisk_sc` | `riskid,risk_description,risk_class` |
| `CTIGetMandRiskCoverages`, `CTIGetDefaultRiskCoverages`, `CTIGetMandRiskEndorse`, `CTIGetDefaultRiskEndorse` | | Coverages/endorsements per risk |
| `CTIGetValidCoverage(s)` | `lobcoverage_sc`, `lobendorsement_sc` | Coverages/endorsements valid for policy (umbrella) or risk (vehicle, home); reserve sub-file mapping |
| `CTIGetCovLimits` / `CTIGetCovDedLimits`, `CTIGetRiskCovLimits`, `CTIGetEndorseLimits`, `CTIGetRiskEndorseLimits` | `loblimits_table`, `lobdeduct_table_sc` | `limits|deductibles|flags` e.g. `100000,200000|250,500|MANDATORY,MANUALRATING,SYSTEMCONTROL,ORDER=n,DEPENDENT=a;b` |
| `CTIGetPolicyDocument`, `CTIGetRiskDocument` | `lobdocdef_table` | `rowid|is-mandatory|POLICY/COVERAGE/ENDORSEMENT (or LOBRISK/...)|lock_with_policy|allow_multiple|allow_multiple_per_term` for each form; status Mandatory/Default/Optional |
| `CTIProducerCommision` | `lobprodcomm_subsc` | commission amount (decimal) by producer type, transaction type, producer rowid |
| `CTIGetRatebook` | | ROWID of rate-book SOI for jurisdiction and effective date |
| `CTIGetInsurer` | `validinsurerlink_sc` | list of insurer ROWIDs |
| `CTIGetClaimTypes` | `lobclaimtypes_sc` | list of claim system object ids |
| `CTI-GetBillItemInfo` | `lobbillitemtype_subsc` | tax codes |
| `CTI-GetTableList` (dynamic tables) | `ratingtable_sc`, `ratingtabledata_subsc` | index1..6 or data[1..20] lists |

Documentation defects: several `INPUT PARAMETER` lines say `OD` for `OF`, `ROWDI` for `ROWID`, `jurusdiction`, and the risk functions refer to `CTI-GetEndorseEndorse` where `CTI-GetRiskEndorse` is meant.

## 7. HTML functions (report generator)

`CTIAttrib`, `CTIText` (text with size/colour/background/alignment/bold-italic-underline), `CTIImage`, `CTILine`, `CTITableStart`, `CTITableItem`, `CTIPaper` (page background and link colours), `CTILink`, `CTIListItem`, and content-tree helpers `ContentSetLink`, `ContentResetLink`, `ContentWriteLink`. Used by the HTML report generator, SysDoc and the business-object HTML views (`OVERVIEW-HTML`).

## 8. Image functions

`CtiGetImage(standard image name, size 16 or 32, sensitive/insensitive) -> COM handle`; `CtiGetImageList(size) -> image list COM handle`. At start-up the Image Catalog loads all images into two image-list OCXs (16x16 and 32x32) on the visual broker. `Standard Image Maintenance` ties standard names to methods, objects and menus; "Use In" lists users of an image.

## 9. SmartObjects (UI controls)

All are Progress SmartObjects with FronTier instance attributes and development methods, built on `I-fisobject.i`. Copyright Concise Technologies Inc. 1998-2000.

| Control | File | Purpose and key attributes | Third-party requirement |
|---|---|---|---|
| Menu | `common/src/dev/s-toolmenu.w` | Window menu from dynamic menu name (`MENU-NAME`); methods `menu-refresh`, `menu-delete`, `MENU-sensitive` | Progress menu (no ActiveX) |
| Popup menu | `s-toolpopup.w` | ActiveBar popup with images and instant items (`MENU-INSTANCES`); `menu-popup`, `menu-setastop` | ActiveBar 1.031 `ActBar.ocx` |
| Toolbar | `s-toolbar.w` | Toolbar from dynamic menu items flagged *toolbar item*; `TOOLBAR-MENU`, `TOOLBAR-BUTTONS`; `bar-*` methods, `MENUbar-refresh` | `comctl32.ocx` 5.0 SP2 |
| Tree-view | `fis-adm/objects/s-tree.w` | Lazy-loaded tree; attributes `TREE-RUN-MODE`, `TREE-P-TREEINIT`, `TREE-P-NODECREATE`; `treenode-init/add/update/remove/expand/select`, `tree-get-attribute`; positions ROOT, CURRENT, PARENT, FIRST, LAST, NEXT, PREV, CHILD | `comctl32.ocx` |
| B/O definition tree | `s-bodef-tree.w` | Shows `business_object_objects`; methods `BOO-refresh`, `BOO-action`, `BOO-sort` (updates `objectorder`) | built on `s-tree.w` |
| Flowchart | `s-flowchart.w` | Nodes and links; `chartnode-setup`, `chartlink-setup`, `chart-repaint`, `chart-zoom`; used for workflow process model | Northwoods Go++/GoControl (`XGO.ocx`) |
| Outlook bar | `s-outlook.w` | Groups and items (`BAR-LABELS`, `ITEM-LABELS`); `ctiaddbar`, `ctiadditem`, `ctisetexternal` | Sheridan ActiveListBar 1.05 (`SSLstBar.ocx`) |
| Calendar | `fcalend.w` | Date picker bound to a date field | `MSCAL.ocx` (Calendar Control 8.0) |
| Image edit and toolbar | `fimage.w`, `fimtool.w` | Image viewer with zoom/rotate/print | Wang Imaging for Windows (`Imgedit.ocx`) |
| Web browser | `s-webbrowser.w` | HTML view, `bws-openfile`, `bws-runfile`, `bws-print` | Microsoft Web Browser (`shdocvw.dll`) |
| Tab folder | `folder.w` | Tabs or buttons (`Folder-Labels`, `Folder-Style`) | `comctl32.ocx` TabStrip |

Other interfaces listed: time entry control, list view control, grid control.
