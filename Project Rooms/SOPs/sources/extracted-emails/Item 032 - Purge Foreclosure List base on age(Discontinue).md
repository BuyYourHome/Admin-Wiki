# Source Email - Item 032 - Purge Foreclosure List base on age(Discontinue)

## Metadata

- Source file: Project Rooms/SOPs/sources/emails/Task Instructions Item 032_ (Discontinued) Purge Foreclosure List Based on Status.msg
- Subject: Task Instructions Item 032: (Discontinued) Purge Foreclosure List Based on Status
- Sender: Akira Brown
- Sent on: 2024-04-17 12:06
- Date captured: 2026-05-23
- Matched spreadsheet item: True

## Raw Email Body

``text
Task 90 will replace this

______________________________

Task Instructions Item 32: Purge Foreclosure List Based on Status

*	Find Foreclosure list in teams: All Properties> Files> ForeclosureList.xlsm
*	Click on 3 dots next to the modified date
*	Select ‘copy to’
*	Save a copy in ‘Letters> Archived’
*	Rename copy in format ‘(todays date)PreForeclosure Archived’
*	Go back to master list: All Properties> Files> ForeclosureList.xlsm and click on the 3 dots next to the modified date again
*	Select ‘copy to’ and save in All Properties> Files. It will ask you if you want to replace existing file or keep both copies. Select ‘Keep both copies’
*	It will save the copy as ‘ForeclosureList1.xlsm’. Open this file in the app
*	Go to ‘Find and Replace’, search for ‘spouse’
*	Go through each ‘spouse’ cell by using the ‘find next’ button in the find and replace window. Make sure that the spouses connected to closed files have a ‘cs’ in column K ‘status’. This should populate column G with ‘closed’
*	Clear and filters
*	Filter column G to only cells with ‘closed’. Click down arrow next to ‘File Closed’, deselect every box besides ‘closed’ at the bottom, click ok. This leaves only the ones that have been labeled ‘closed’ in column G.
*	Go through records to make sure that each one has a ‘cs’ in column K. Add value if missing.
*	If this action creates a #REF in column P, copy formula in cell above it and paste into cell with #REF
*	Clear filters
*	Filter column K to only cells with ‘cs’. Click down arrow next to ‘Status’, deselect every box except ‘cs’ at the bottom, click ok. This leaves only the ones that have been labeled ‘cs’ in column K.
*	Go through to make sure all the records with ‘cs’ in column K have ‘closed’ in column G. Add value if missing.
*	If this action creates a #REF in column P, copy formula in cell above it and paste into cell with #REF
*	Once all records have ‘Closed’ in column G and ‘cs’ in column K select all records, right click, delete row. This deletes all the records that have been closed.
*	Clear filters
*	Go to print envelope tab at the bottom
*	Filter by ‘First Date sent’ in column N, Oldest to newest
*	Select all rows that contain any date with a year older than the current
*	Delete rows
*	Save locally in downloads file on computer. Rename file to ‘ForeclosureList.xlsm’
*	Open Teams, All Properties, Files and drag file into window to save in Teams
``

## Suggested SOP Page

- [[Project Rooms/SOPs/outputs/SOPs/SOP - Item 032 - Purge Foreclosure List base on age(Discontinue)]]
