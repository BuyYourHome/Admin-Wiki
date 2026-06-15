# Source Email - Item 022 - Import ForeclosureList to REI

## Metadata

- Source file: Project Rooms/SOPs/sources/emails/Task Instructions Item 022_ Prepare ForeclosureList for Direct Skip.msg
- Subject: Task Instructions Item 022: Prepare ForeclosureList for Direct Skip
- Sender: Akira Brown
- Sent on: 2024-04-17 12:36
- Date captured: 2026-05-23
- Matched spreadsheet item: True

## Raw Email Body

``text
These are the instructions to export the new records from the foreclosure list spreadsheet into REI Blackbook.

1.	Go to Teams folders [All Properties]
2.	Click on the files menu.



3.	and find and open the ForeclosureList.xlsx file with the Open in app option.



4.	Clear Data. Look for the first blank cell in column B [Imported]
5.	Right click on the cell and click on Filter, then Filter by Cell’s value. This filters the reecords to only those which have not yet been exported.



6.	Filter those records out which have no adresses. Left Click on the down arrow of the column header for column S [Address]. Select Text Filters. Choose [does not equal] and leave the value blank on the rightr side. Click OK.



7.	What remains are the record that need to be imported into REI Blackbook. Copy todays’ date into all of the colum B [Imported] for all visble Rows. Type date, press enter. Copy (ctrl+c), highlight cells (shift+arrow), Paste (ctrl+v)
8.	Save the spreadsheet. [Ctrl] S is the shortcut for this.
9.	Save a Copy in the Exported folder(File>Save a Copy>_Letters>Exported) with a name like ForclosureList - imported yy-mm-dd.xlsm. From this screen select [Letters] then [Exported] and name the file consistant with the other names in the list. Save.



10.	The new file can be seen in the Teams folders.



11.	The file that is now open is a copy of the orignal. All records that don’t have today’s date in the Imported column, need to be removed. 

	a.	Clear all the filters from the spreadsheet.



	b.	Use the fileters at the top of Column B [Imported]. Select Date Filters and choose the bottom item in the list, Custom Filters. 



	c.	Use the does not equal item form the dropdown box and enter today’s date to the right



	d.	This leaves only those records that are not being imported today. 

i. Select all visible rows by clicking on the row indicater on the far left of the sheet.

ii. It is best to start at the bottom and select upwards

iii. If you anchor the cursor in the row indicator for the bottom row and then press {Shift}{Ctrl}{home}, all of the rows will be highlighted.

iv. Be sure the top row, with the Column Names in it, have not been selected.

v. Once they are selected, press the {Delete} key

	e.	Verify that the only records that remain are those with today’s date in the Imported column. Clear all of the filters again. See step 11.a



12.	Save the spreadsheet again. {Ctrl} S
13.	Make a new copy of this file as comma delimited file, CSV format. 

	a.	Use the same name and location but select the CSV UTF-8 format from the dropdown list. 
	b.	A dialog box will appear. Dimiss it with the OK button.
	c.	Another box may appear that says. The selected file type does not support… Dismiss it with the OK button.



14.	This completes the export process and starts the import process.
15.	Close the spreadsheet.
16.	Validate, in Teams, that the new CSV file is the newest in the Teams> All Properties>Property>_Letters>Exported folder



17.	Select the file and Download it.



18.	Move to Task 92:Import to Direct Skip

Directions to upload file to REI for manual skip tracing

Open REI Blackbook and got to Contacts. Click on the Add Contact button and select Import Contact.



19.	Select the Choose File button. Navigate to the file in the Downloads folder that you just created. Delect it and click the Open button.
20.	Click on the orange Upload CSV button.
21.	There is a long list of Column Names that need to be matched with the same Field in the Database. Some of the names are already matched and some will need to be selected. Some will not need to be selected. Here is how they should all look.







22.	Click the orange Run Import button. This will bring all the new records selected into REI Blackbook. All new records will have a tag with today’s date on it.
23.	Click on the orage Go To Contacts button to see the new contacts.
``

## Suggested SOP Page

- [[Project Rooms/SOPs/outputs/SOPs/SOP - Item 022 - Import ForeclosureList to REI]]
