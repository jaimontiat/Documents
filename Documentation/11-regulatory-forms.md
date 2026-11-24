# 11 - Regulatory Forms

Three ISO (Insurance Services Office) personal-auto forms sit at the top level of the share. They are not FronTier documentation; they are **sample output/inputs of the document-fulfilment capability** (forms driven per jurisdiction and transaction through `lobdocdef_table`, see [06](06-business-modules.md) section 10). They are recorded here because they define data the policy system must capture.

Files:

| File | Form | Edition | Pages |
|---|---|---|---|
| `ILU056 0125 VA Select Lower Uninsured Motorists Coverage Limits.pdf` | IL U 056 - Virginia Selection of Lower Uninsured Motorists Coverage Limits | 01 25 (c) ISO 2024 | 2 |
| `ILN1480723 VA Select Rej UM.pdf` | Page 1: IL N 148 07 23 Virginia Important Notice Regarding Election of Uninsured Motorists Coverage. Pages 2-3: IL U 056 **01 22** (previous edition of the form above) | 07 23 / 01 22 (c) ISO 2023 | 3 |
| `NY UM Selection Form.pdf` | IL U 004 - New York Required Notice of Availability of Supplementary Uninsured/Underinsured Motorists Coverage | 06 18 (c) ISO 2018 | 4 |

The text of `ILN1480723` could not be extracted as text (font encoding); it was read by OCR, so numbers in it should be checked against the PDF.

## 1. IL U 056 01 25 - Virginia lower UM limits selection

Purpose: the applicant may reject UM coverage at limits equal to the liability limits and choose lower limits, **but not below Virginia's minimum liability limits**.

| Item | 01 25 edition | 01 22 edition (OCR) |
|---|---|---|
| Liability limits above which rejection is possible: split limits | $50,000 per person / $100,000 per accident BI and $25,000 PD | $30,000 / $60,000 BI and $20,000 PD |
| Combined single limit | $125,000 per accident | $80,000 per accident |

Header data: policy number, policy effective date, company, producer, applicant/named insured. Body: choose **one split-limit BI option and one PD option, or one CSL option**, each with initials; signature and date of applicant.

Option values extracted (column alignment is lost in the text layer; verify on the PDF):

- Split BI: 50,000/100,000; 100,000/200,000; 100,000/300,000; 100,000/500,000; 250,000/500,000; 300,000/300,000; 500,000/500,000; 500,000/1,000,000; 1,000,000/1,000,000; Other.
- PD: 25,000; 50,000; 100,000; 150,000; 200,000; 250,000; 300,000; 500,000; 750,000; Other.
- CSL (01 25): 125,000; 150,000; 200,000; 220,000; 250,000; 300,000; 350,000; 400,000; 500,000; 600,000; 750,000; 1,000,000; 1,500,000; 2,000,000; 2,500,000; 3,000,000; 5,000,000; 7,500,000; 10,000,000; Other.
- CSL (01 22, OCR): 80,000; 100,000; 125,000; 150,000; 200,000; 220,000; 250,000; 300,000; 350,000; 400,000; 500,000; 600,000; 750,000; 2,500,000; Other.

## 2. IL N 148 07 23 - Virginia UIM election notice

One-page notice. Content: underinsured motorist coverage previously paid damages after crediting the at-fault liability coverage; the law now requires coverage that pays damages **in addition to** the applicable liability coverage; this may change the premium; the insured may **elect to refuse** (decrease) the change, which must be **in writing**; an election by **any one named insured binds all insureds**; a later increase must be requested **in writing**; the insured should weigh the protection lost.

## 3. IL U 004 06 18 - New York SUM notice and selection

| Section | Content |
|---|---|
| A Uninsured Motorists | Mandatory UM in New York at limits of at least $25,000 per person / $50,000 per accident for accidents inside NY, unless SUM is purchased |
| B-C Supplementary UM/UIM (SUM) | Optional higher limits; applies inside and outside NY; covers bodily injury (including death) caused by a negligent driver with no insurance or low limits; limit cannot exceed the policyholder's own third-party liability limits; maximum payable is the SUM limit **reduced (offset) by liability payments** from negligent parties |
| D Examples 1-5 | Worked recoveries: (1) damages 300,000, liability 500,000, SUM 250,000, other 25,000 -> 25,000 + 225,000 = 250,000; (2) damages 100,000, liability/SUM 25,000/25,000, other 25,000 -> 25,000, nothing from SUM; (3) damages 60,000, 100,000/100,000, other 50,000 -> 50,000 + 10,000; (4) damages 150,000, 100,000/100,000, other 25,000, comparative fault 50% -> 75,000 total (25,000 + 50,000), 100% at fault -> 25,000 + 75,000, with limits of 150,000 SUM would be 125,000; (5) CSL 75,000 with multiple injured and one death, other vehicle uninsured -> SUM limit shared; mandatory UM per-person/per-accident limits of 25,000/50,000 (injury) and 50,000/100,000 (death) also apply |
| Selection | Initials; SUM limit as per-person/per-accident amounts **or** per-accident (CSL); signature and date |

## 4. What the forms imply for the system *(inferred)*

| Data element | Likely location in the FronTier model |
|---|---|
| Policy number, effective date, named insured, company, producer | `policy_object` (`policy_number`, `policyeffective_date`, `named_insured`), producer P/O (`producer_po`) and entity links |
| Jurisdiction (VA, NY) selecting the form | `jurisdiction` on `quote_object` / `policy_object`; `lobdocdef_table.jurisdictions` |
| Selected UM/SUM limits | `coverage_object.coverage_limit1/2` for the UM/SUM coverage, with allowed values from `loblimits_table` per jurisdiction |
| Form required at issue or endorsement | `lobdocdef_table` (`mandatory_transactions`, `optional_transactions`, `default_transactions`, `print_on_dec`, `lock_with_policy`, `allow_multiple_per_term`) |
| Signed rejection/selection (initials, signature, date) | Stored as an attachment/document history (`attachment_sc`, `documents_po`, `documenthistory_subpo`) |
| Edition control (01 22 -> 01 25) | `docdef` `docversion`, `effdate`, `expdate`, `form_number` |
| Minimum limit validation per edition and jurisdiction | Validation definitions (`validationdef_sc`) or `loblimits_table` values with rule program |

These mappings are architectural suggestions based on the schema, not statements from the sources.
