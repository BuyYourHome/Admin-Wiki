# Doc Scan Packets

This folder is the normal drop location for structured scanned-invoice and scanned-receipt packets handed off by Doc Scan.

Each packet should follow `..\..\working\invoice-packet-schema.md` and should point to the filed invoice or receipt PDF already saved in the correct Teams/project folder.

The heartbeat `invoice-entry-to-projects-backup-heartbeat` checks this project room hourly as a backup monitor. Direct Doc Scan follow-up messages remain the primary trigger for Template to Project work.

