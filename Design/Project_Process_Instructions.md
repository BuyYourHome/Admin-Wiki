# 3325 Banks Rd Project Process Instructions

These instructions control how project files should be handled during future updates.

---

# Active Project Folder

Use this folder as the active project folder:

```text
C:\Codex\Design
```

Do not update the old Teams/SharePoint folder unless specifically requested.

---

# PowerPoint Handling

Keep the current pitch deck in the main project folder using this static filename:

```text
C:\Codex\Design\3325_Banks_Rd_CoLiving_Pitch_Deck.pptx
```

Before creating a new current deck:

1. Create this folder if it does not already exist:

```text
C:\Codex\Design\powerpoint_versions
```

2. Move the prior current deck into `powerpoint_versions`.
3. Rename the archived deck with a timestamp or version suffix.
4. Save the updated deck in the main folder using the static filename above.

Older versioned decks should not accumulate in the main project folder.

---

# Excel Handling

Use this workbook as the active model:

```text
C:\Codex\Design\3325_Banks_Rd_Investor_ROI.xlsx
```

Before material workbook changes:

1. Save a backup in:

```text
C:\Codex\Design\excel_versions
```

2. Use commas in currency-style values.
3. Do not use dollar signs unless specifically requested.
4. Preserve user formatting where practical, especially on the Waterfall tab.
5. Verify formulas after changes.

---

# STR Experimental Workbook Handling

The STR workbook is a separate experimental model:

```text
C:\Codex\Design\3325_Banks_Rd_Investor_ROI-STR.xlsx
```

Do not apply STR workbook changes back to the base investor ROI workbook unless specifically requested.

The STR workbook should have its own markdown files. Do not revise the base markdown files to describe STR assumptions unless the STR scenario is adopted into the base underwriting.

Base markdown files stay synced to:

```text
C:\Codex\Design\3325_Banks_Rd_Investor_ROI.xlsx
```

STR markdown files stay synced to:

```text
C:\Codex\Design\3325_Banks_Rd_Investor_ROI-STR.xlsx
```

Use this naming convention for STR markdown:

```text
STR_01_Project_Program_and_Market.md
STR_02_Financial_Capitalization_and_Returns.md
STR_04_STR_Operating_Scenarios.md
```

Each STR markdown file should clearly say that it is experimental and should not be treated as the controlling base-case underwriting unless adopted.

Preserve the user's formatting on the `STR Scenarios` tab:

* The scenario selector is on rows 7-9 with three option buttons.
* A duplicate selector block also exists on the `Waterfall` tab, anchored at `V3`, matching `STR Scenarios!A6:J10`.
* The Waterfall duplicate option buttons link back to the master STR selector helper at `'STR Scenarios'!$H$4`.
* The selected scenario display is on row 4.
* Do not use a dropdown for scenario selection on the STR workbook.
* The option buttons must be one mutually exclusive group and all must link to cell `H4`.
* Cell `D4` should display the selected scenario name from `B7:B9`.
* Cell `H4` should hold the numeric selected scenario id: `1`, `2`, or `3`.
* The named range `SelectedOperatingScenario` currently points to:

```text
'STR Scenarios'!$D$4
```

* The numeric option-button helper is named `SelectedOperatingScenarioId` and currently points to:

```text
'STR Scenarios'!$H$4
```

* Keep the selected scenario display in column D and the option helper in column H unless the user asks to move them.
* With option 1 selected, the STR workbook Annual Model should match the base investor ROI workbook for the base co-living / medium-term case.
* Input assumptions use the left label column with Low / Medium / High cases arranged to the right.
* The STR output table is named `STRScenarioTable`.
* Keep the annual scenario output table at the lower section of the `STR Scenarios` tab.
* Preserve comma number formats and percent formats.
* Do not collapse the layout back to the original generated spacing if the user has widened, moved, or reformatted sections.

STR scenario logic currently supports:

* Base Co-Living / Medium-Term
* One Floor STR + One Floor Co-Living
* Whole Building STR

When making future STR changes, verify that changing each option button updates the Annual Model gross potential rent without formula errors and that only one option can be selected at a time.

The `Participant Return Comparison by Rent Option` table on the `Waterfall` tab is formula-driven. It uses a hidden Excel data-table block on the `STR Scenarios` tab in columns `AA:AN` to calculate all three operating scenarios side by side while preserving the currently selected operating scenario. Do not delete or overwrite hidden columns `AA:AN` on the `STR Scenarios` tab unless replacing this comparison mechanism.

The visible comparison table currently references that hidden block so it can show Base, One-Floor STR, and Whole-Building STR results at the same time. The live `Returns Summary` still responds to the selected option button.

---

# Markdown Handling

Keep markdown files synchronized with the Excel workbook when changes affect:

* rents,
* revenue,
* expenses,
* capitalization,
* project costs,
* debt payoff,
* investor returns,
* waterfall logic,
* sponsor economics,
* or project program assumptions.

Before material markdown edits:

1. Save snapshots in:

```text
C:\Codex\Design\markdown_versions
```

2. Update all relevant markdown files, not only the file that first appears related.
3. Remove stale values when workbook assumptions change.

---

# Current Presentation Rules

PowerPoint and markdown should reflect the current project status:

* Building area: **6,000 SF**
* First floor: **2 premium suites + 2 co-living suites**
* Second floor: **2 premium suites + 2 co-living suites**
* Rent schedule should be displayed by effective year.
* Do not present average rent as the underwriting basis.
* Possible marketing scenario: one floor may be rented as a short-term rental, subject to confirmation.
* Floor plan exhibits should preserve scale.
* Do not mention visible Year 0 in the PowerPoint.

---

# Current Waterfall Description

Describe the current waterfall in this order:

1. Existing debt is paid from refinance or sale proceeds where applicable; do not describe this as blocking all operating waterfall distributions before refinance.
2. Repairs and maintenance reserve is funded before waterfall distributions.
3. Class A capital is returned.
4. Class B capital is returned.
5. Accrued Class A preferred return is paid.
6. Remaining residual is split according to current workbook assumptions.

Residual shares should be read from the workbook, not hard-coded from memory.

---

# Sync Rule

When the Excel workbook, markdown files, and PowerPoint differ, use this priority:

1. Confirm the current workbook values.
2. Update markdown to match the workbook.
3. Recreate the current PowerPoint from the workbook and markdown status.
