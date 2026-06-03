# Source Email - Item 027 - Prepping ForeclosureList for Mailing Letters

## Metadata

- Source file: sources/emails/RE_ Task Instructions Item 027_ Prepping ForeclosureList for Mailing Letters.msg
- Subject: RE: Task Instructions Item 027: Prepping ForeclosureList for Mailing Letters
- Sender: Wes Will Buy Your Home
- Sent on: 2026-03-04 12:02
- Date captured: 2026-05-23
- Matched spreadsheet item: True

## Raw Email Body

``text
Make sure new records have a correct value for First day Sent:

1.	Open ForeclosureList.xlsm from local folder not Teams
2.	Go to the PreForeclosure tab
3.	Click on the Data menu, then click on “Clear” from the tool ribbon to clear the filter.
4.	The following steps will filter the records to just those which are ready to mail to but have not had mail sent yet.

	a.	Press F. 
	b.	Alternatively, click on the View menu
	c.	Click on the Macros down arrow from the tool ribbon, far right, top, not the Macros sheet at the bottom.

i. Select “SetFirstDateSent” from the dropdown list

ii. Click Run

	d.	This is what the macro does. If it fails these are the steps that need to be done manually

i. Clears all filters on table ForeclosureList

ii. Filters table to 

			1.	First Date Sent is blank or empty
			2.	File Closed = blank OR empty
			3.	Role = heir OR blank
			4.	MAdd1 NOT blank
			5.	Mail? must NOT equal "Don't Mail"

iii. Calculates the date for Next Tuesday

iv. Sets Next Date Sent to the date for next Tues on all visible rows

5.	There are several reasons for it not to be showing a 1. They are:

	a.	The record is a spouse and spouses do not receive individual letters. [OK]
	b.	There is something wrong with some of the cells that column AA is dependent upon. [Not OK]
	c.	The number of days set until the next mailing is wrong. [Not OK]

i. Find this value on the [Macros] tab

ii. The mail is sent on Tues. If today is Friday, there are 4 days until mailing. 4 should be the value in cell 1B.

iii. Change the value to the number of days until mailing.

Move the Records that are going to be printed to the [Print Envelopes] tab:

1.	This is now handled entirely by the macro BuildPrintEnvelopesBAtch, activated by ,P
2.	Go to the [Print Envelopes] tab
3.	Should the macro fail, these are the steps that need to be done manually. Go to [Print Envelopes] tab. Copy new cells that will be used for selecting the new records.

	a.	Click on the Data menu, then click on “Clear” from the tool ribbon to clear the filter.
	b.	Find the last record copied
	c.	Copy the cells in that record from Columns S, T, U, V, and W to the row below it (in the same columns).
	d.	Change the value in columns S and T to “No” on the line just copied.
	e.	Change the date in column U to the next mailing date on the same line.
	f.	Copy this newly created row to make several hundred new rows below it. It will be 4 or 5 pages of new rows. Starting in Column S, Shift+Page Down, copy and paste. 

4.	Change the values in cell N1 and V1

	a.	V1 is the column for the Print Date value. Make it the date of the next mailing. Enter.
	b.	N1 is the column for the Letter #. Set it to 1. Enter.

5.	Go to the PreForeclosure tab
6.	Click on the Data menu, then click on “Clear” from the tool ribbon to clear the filter.

	a.	Clear no address entries.
	b.	Select the drop down filter on Column AF (Calc Letter)
	c.	Deselect the values for 0, Exceeded, and (blanks)

7.	Copy all the green cells from the Preforeclosure tab to the Print Envelopes tab

	a.	From the Print Envelopes tab, Pre-position the cursor in the Column A, in the first record below the green records. Ctrl+ down arrow
	b.	From the Preforeclosure tab, copy all of the Green highlighted records. Stop selecting when the last record that has text is reached.

i. Start on the first line.

ii. Highlight cells in column N - column AE. This should be First Name – Calc Letter

iii. Highlight down all entries. Ctrl+C

	c.	Go back to Print Envelopes tab, paste these records where the cursor was pre-positioned. Save.

This finishes the prep for the spreadsheet so that it can be used to print the letters.
``

## Suggested SOP Page

- [[SOPs/SOP - Item 027 - Prepping ForeclosureList for Mailing Letters]]
