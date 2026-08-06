window.PROJECT_ROOMS_UPDATED = '2026-08-06 08:42';
window.PROJECT_ROOMS_HASH = '75B694FAA484AE18CBB37A014258DD1A9D64D1E8C58589E1D515404212516375';
window.PROJECT_ROOM_GROUPS = [
    {
        "name":  "Intake \u0026 Coordination",
        "basis":  "Receives requests, routes work, creates Project Rooms, or provides an operating overview across workflows."
    },
    {
        "name":  "Document Intake",
        "basis":  "Receives, identifies, organizes, or maintains source documents and operating procedures before downstream processing."
    },
    {
        "name":  "Accounting \u0026 Project Data",
        "basis":  "Maintains financial calculations, invoice processing, project workbooks, templates, or structured project data."
    },
    {
        "name":  "Real Estate Transactions",
        "basis":  "Supports property acquisition, valuation, buyer qualification, seller financing, transaction packaging, or project setup."
    },
    {
        "name":  "Legal \u0026 Entity",
        "basis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work."
    },
    {
        "name":  "Publishing \u0026 Public Work",
        "basis":  "Develops books, drawings, voice/media assets, websites, or other public-facing content."
    },
    {
        "name":  "Systems \u0026 Maintenance",
        "basis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health."
    },
    {
        "name":  "Other",
        "basis":  "Used when a Project Room does not yet have a supported assignment to one of the defined functional groups."
    }
];
window.DASHBOARD_ACTIONS = {
    "jeansVoice":  {
                       "displayName":  "Jean\u0027s Voice",
                       "taskId":  "019fbe57-fcd9-7c83-be74-e377c7b9c4d0",
                       "href":  "codex://threads/019fbe57-fcd9-7c83-be74-e377c7b9c4d0"
                   },
    "modeActions":  {
                        "Create PR":  {
                                          "Diagram":  {
                                                          "type":  "open-url",
                                                          "label":  "Open Project Room Relationship Diagram",
                                                          "href":  "../../Create%20PR/outputs/Project%20Room%20Relationship%20Diagram.svg"
                                                      }
                                      }
                    },
    "modePanels":  {
                       "Dashboard":  {
                                         "Bridge Test":  {
                                                             "title":  "Dashboard Bridge Test",
                                                             "intro":  "Use this helper to prove the Dashboard-to-Create-PR bridge path without browser popups, manual paste, or any delegated Project Room work.",
                                                             "stateText":  "Bridge Test loaded. Record one local request, then review the returned status here.",
                                                             "controls":  [
                                                                              {
                                                                                  "type":  "dashboard-bridge-test",
                                                                                  "label":  "Prepare bridge test request",
                                                                                  "availability":  "local-only",
                                                                                  "description":  "The full local Dashboard host can record one bridge-test request for Create PR. LAN views can only review the current state."
                                                                              }
                                                                          ]
                                                         },
                                         "Mode Map":  {
                                                          "title":  "Mode Map",
                                                          "intro":  "Use this helper when Wes wants a Dashboard mode mapping in plain English. The blocks below are the canonical structures Dashboard should derive from the request.",
                                                          "stateText":  "Mode Map helper loaded. Use the patterns below to define a single mode action or a full multi-control mode panel.",
                                                          "controls":  [
                                                                           {
                                                                               "type":  "message",
                                                                               "label":  "Plain-English interpretation rule",
                                                                               "text":  "If Wes describes one target to open, treat it as a keyed mode action. If Wes describes several buttons, helper notes, or side-panel controls for one mode, treat it as a keyed mode panel."
                                                                           },
                                                                           {
                                                                               "type":  "template",
                                                                               "label":  "Single mode action pattern",
                                                                               "text":  "Key mode action\nProject Room: \u003cexact room name\u003e\nMode: \u003cexact mode name\u003e\nType: open-url\nTarget: \u003cfull local path or exact URL\u003e\nAvailability: \u003clan-readonly | local-only\u003e\nLabel: \u003coptional label\u003e"
                                                                           },
                                                                           {
                                                                               "type":  "template",
                                                                               "label":  "Mode panel pattern",
                                                                               "text":  "Key mode panel\nProject Room: \u003cexact room name\u003e\nMode: \u003cexact mode name\u003e\nControls:\n- Type: open-url\n  Label: \u003cbutton label\u003e\n  Target: \u003cfull local path or exact URL\u003e\n  Availability: \u003clan-readonly | local-only\u003e\n- Type: message\n  Label: \u003csection label\u003e\n  Text: \u003chelper text\u003e\n  Availability: \u003clan-readonly | local-only\u003e"
                                                                           },
                                                                           {
                                                                               "type":  "message",
                                                                               "label":  "Normalization rules",
                                                                               "text":  "Use the exact Project Room name and exact documented mode name from the Dashboard. Default availability to lan-readonly unless Wes clearly wants the control to stay local-only on the host machine."
                                                                           },
                                                                           {
                                                                               "type":  "open-url",
                                                                               "label":  "Open Dashboard README",
                                                                               "href":  "../../Dashboard/README.md",
                                                                               "availability":  "lan-readonly",
                                                                               "description":  "Open the Dashboard README, which now includes the canonical Mode Map rules."
                                                                           }
                                                                       ]
                                                      }
                                     },
                       "Manager":  {
                                       "Tasks":  {
                                                     "title":  "Manager Tasks",
                                                     "intro":  "Open Manager tasks are sourced from the canonical Manager task register. Status edits stay limited to the full local Dashboard on WesStudio.",
                                                     "stateText":  "Manager Tasks loaded. Open tasks are shown from the canonical Manager register.",
                                                     "controls":  [
                                                                      {
                                                                          "type":  "task-list",
                                                                          "label":  "Open Manager tasks",
                                                                          "availability":  "lan-readonly",
                                                                          "emptyText":  "No open Manager tasks are currently recorded."
                                                                      },
                                                                      {
                                                                          "type":  "task-status-editor",
                                                                          "label":  "Update selected task status",
                                                                          "availability":  "local-only",
                                                                          "description":  "Status changes write back to the canonical Manager task register from the full local Dashboard only."
                                                                      }
                                                                  ]
                                                 }
                                   },
                       "Invoice Entry":  {
                                             "Reconcile":  {
                                                               "title":  "Invoice Entry Reconcile",
                                                               "intro":  "Choose a property, then prepare the Reconcile request for Invoice Entry.",
                                                               "stateText":  "Invoice Entry Reconcile loaded. Select an active project, then prepare the paste-ready request and follow the visible next-step card.",
                                                               "controls":  [
                                                                                {
                                                                                    "type":  "project-select",
                                                                                    "label":  "What Property",
                                                                                    "availability":  "lan-readonly",
                                                                                    "emptyText":  "No current active projects were found in the Invoice Entry workbook register."
                                                                                },
                                                                                {
                                                                                    "type":  "invoice-entry-reconcile-request",
                                                                                    "label":  "Reconcile",
                                                                                    "availability":  "local-only",
                                                                                    "description":  "Prepares the exact Invoice Entry Reconcile request, tries to copy it, and tries to open the Invoice Entry task on WesStudio for paste-in activation."
                                                                                }
                                                                            ]
                                                           }
                                         }
                   }
};
window.PROJECT_ROOMS = [
    {
        "name":  "Admin Wiki Maintenance",
        "purpose":  "Use this room for Admin wiki maintenance work such as branch cleanup notes, repository hygiene reviews, rule consolidation, and cross-project operating-system maintenance that does not belong to a more specific Project Room.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Other",
        "groupBasis":  "Used when a Project Room does not yet have a supported assignment to one of the defined functional groups.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Admin%20Wiki%20Maintenance/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "AIOS",
        "purpose":  "This project room is for AIOS planning, source review, drafting, and related administrative work.",
        "status":  "Status not recorded",
        "skill":  "aios",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\aios\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [

                  ],
        "readmeUrl":  "../../AIOS/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Amortization",
        "purpose":  "Own the reusable Amortization generator that creates buyer-facing 12-month amortization chart PDFs from project spreadsheets for Contract for Deed and other seller-financing workflows.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Accounting \u0026 Project Data",
        "groupBasis":  "Maintains financial calculations, invoice processing, project workbooks, templates, or structured project data.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Amortization/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Brynda Suit",
        "purpose":  "This Project Room holds source material, working notes, open questions, and review-ready outputs for the Brynda Suit workflow. Use this room when Wes asks Codex to organize, analyze, draft, or maintain materials specifically tied to Brynda Suit.",
        "status":  "draft",
        "skill":  "brynda-suit",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\brynda-suit\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Legal \u0026 Entity",
        "groupBasis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work.",
        "modes":  [
                      "OfficeAssist Routed Email Response"
                  ],
        "readmeUrl":  "../../Brynda%20Suit/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "CMA Report",
        "purpose":  "Create a repeatable project-room workflow for preparing a comparative market analysis (CMA) for a single-family property, using 4121 Tensity Dr, Raleigh, NC 27604 as the prototype property.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Real Estate Transactions",
        "groupBasis":  "Supports property acquisition, valuation, buyer qualification, seller financing, transaction packaging, or project setup.",
        "modes":  [

                  ],
        "readmeUrl":  "../../CMA%20Report/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "CMA Report - 5021 Sunnyfield Dr",
        "purpose":  "Prepare a preliminary CMA for the manufactured home at 5021 Sunnyfield Dr, Raleigh, NC 27610.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Other",
        "groupBasis":  "Used when a Project Room does not yet have a supported assignment to one of the defined functional groups.",
        "modes":  [

                  ],
        "readmeUrl":  "../../CMA%20Report%20-%205021%20Sunnyfield%20Dr/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Codex Environment",
        "purpose":  "This Project Room owns the workflow for preparing other authorized computers to replicate the Codex working environment from WesStudio. Use this room when Wes asks Codex to remote into a computer, inspect what is missing, install required apps, configure the Admin wiki/Codex working environment, or verify that the target computer can run the same Admin wiki workflows as WesStudio.",
        "status":  "`Wes-VideoEditor` core Admin wiki environment and Codex Desktop project connection installed and verified on 2026-07-22; connector sign-ins, plugin cache, and live workflow execution remain unverified",
        "skill":  "codex-environment",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\codex-environment\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [
                      "Update Codex Environment"
                  ],
        "readmeUrl":  "../../Codex%20Environment/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Computers",
        "purpose":  "This Project Room keeps track of Buy Your Home business computers, including each computer\u0027s owner or primary user, hardware specifications, operating system, installed business applications, security and remote-access posture, Codex/Admin wiki readiness, and configuration notes. Use this room when Wes asks to inventory a business computer, compare computer specs, document configuration, track app installation status, record remote-access readiness, or maintain the current list of company machines.",
        "status":  "draft",
        "skill":  "computers",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\computers\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Computers/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Confidential",
        "purpose":  "Keep confidential source notes, working analysis, open questions, and review-ready outputs separated from other Admin wiki work. - Preserve source context before drafting final outputs. - Track privacy concerns and unsupported claims before any material is shared outside the Admin wiki.",
        "status":  "Status not recorded",
        "skill":  "confidential",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\confidential\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Legal \u0026 Entity",
        "groupBasis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Confidential/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Contract for Deed",
        "purpose":  "Create contract-for-deed sale document packages, currently focused on selling 320 Rose in the same manner that Cool Springs was sold.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "019ecba7-f1cc-7ac1-aaf7-d89a3f21b582",
        "attention":  null,
        "group":  "Real Estate Transactions",
        "groupBasis":  "Supports property acquisition, valuation, buyer qualification, seller financing, transaction packaging, or project setup.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Contract%20for%20Deed/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Create PR",
        "purpose":  "This Project Room defines the repeatable workflow for creating a new Buy Your Home Project Room, matching Codex skill, and dedicated startup chat. Use this room when Wes asks to create a new PR, Project Room, room-specific skill, or room-specific chat for a recurring body of work.",
        "status":  "active",
        "skill":  "create-pr",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\create-pr\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Intake \u0026 Coordination",
        "groupBasis":  "Receives requests, routes work, creates Project Rooms, or provides an operating overview across workflows.",
        "modes":  [
                      "Diagram"
                  ],
        "readmeUrl":  "../../Create%20PR/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Credit Worthiness Evaluator",
        "purpose":  "Develop a repeatable process for evaluating whether a tenant-buyer is financially suitable for a Contract for Deed purchase and for documenting the decision in a way that supports Dodd-Frank / Regulation Z compliance review.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Real Estate Transactions",
        "groupBasis":  "Supports property acquisition, valuation, buyer qualification, seller financing, transaction packaging, or project setup.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Credit%20Worthiness%20Evaluator/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Dashboard",
        "purpose":  "Build and maintain a locally hosted dashboard showing Buy Your Home Project Rooms and the functionality each room owns.",
        "status":  "active initial design",
        "skill":  "dashboard",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\dashboard\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Intake \u0026 Coordination",
        "groupBasis":  "Receives requests, routes work, creates Project Rooms, or provides an operating overview across workflows.",
        "modes":  [
                      "Mode Map",
                      "Bridge Test"
                  ],
        "readmeUrl":  "../../Dashboard/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Doc Scan",
        "purpose":  "Keep Doc Scan workflow development separate from general Admin Operations. - Preserve the current authoritative workflow documents and skill source. - Track routing rules, automation behavior, open questions, and review-ready handoffs in one place.",
        "status":  "Status not recorded",
        "skill":  "doc-scan",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\doc-scan\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019ecc0d-02b4-73a3-9c20-dacda5d811d0",
        "attention":  null,
        "group":  "Document Intake",
        "groupBasis":  "Receives, identifies, organizes, or maintains source documents and operating procedures before downstream processing.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Doc%20Scan/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Email Monitor",
        "purpose":  "Keep Email Monitor development separate from the general Admin Operations chat. - Preserve the active automation id: officeassist-morning-email-summary-and-instruction-monitor. - Keep the canonical workflow source in C:\\Codex\\Wiki Files\\skills\\email-monitor\\SKILL.md.",
        "status":  "Status not recorded",
        "skill":  "email-monitor",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\email-monitor\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019f8274-5b7e-7170-a051-f7944954de82",
        "attention":  null,
        "group":  "Intake \u0026 Coordination",
        "groupBasis":  "Receives requests, routes work, creates Project Rooms, or provides an operating overview across workflows.",
        "modes":  [
                      "Email Summary",
                      "Health Check",
                      "Task Health",
                      "Email Routing",
                      "Email Delivery",
                      "Organize"
                  ],
        "readmeUrl":  "../../Email%20Monitor/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Entity Relationship",
        "purpose":  "Maintain Buy Your Home entity relationship materials, including charts, source notes, ownership/management relationship summaries, and review-ready diagrams.",
        "status":  "active planning",
        "skill":  "entity-relationship",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\entity-relationship\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Legal \u0026 Entity",
        "groupBasis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Entity%20Relationship/README.md",
        "quickActions":  [
                             {
                                 "label":  "Open relationship diagram",
                                 "href":  "../../Entity%20Relationship/outputs/entity-relationship-chart.svg"
                             }
                         ]
    },
    {
        "name":  "Estate Documents",
        "purpose":  "Create a dedicated Project Room for Wes\u0027s estate documents so source files, working notes, and answers to future estate-related questions are kept together and reviewed from a clean source inventory.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Legal \u0026 Entity",
        "groupBasis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Estate%20Documents/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Geico Insurance Claim",
        "purpose":  "Organize source documents, correspondence, notes, and review-ready outputs for the Geico insurance claim.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Legal \u0026 Entity",
        "groupBasis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Geico%20Insurance%20Claim/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Gracious Millionaire",
        "purpose":  "This project room gathers source material for a book called *Gracious Millionaire*. The separate emails in sources/email/ are early chapter starts, fragments, and seed ideas. They should be treated as source material for a book manuscript, not as ordinary correspondence.",
        "status":  "Status not recorded",
        "skill":  "gracious-millionaire",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\gracious-millionaire\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019ecba7-f1cc-7ac1-aaf7-d89a3f21b582",
        "attention":  null,
        "group":  "Publishing \u0026 Public Work",
        "groupBasis":  "Develops books, drawings, voice/media assets, websites, or other public-facing content.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Gracious%20Millionaire/README.md",
        "quickActions":  [
                             {
                                 "label":  "Open GraciousMillionaire.com",
                                 "href":  "https://graciousmillionaire.com"
                             }
                         ]
    },
    {
        "name":  "Investigate Computer",
        "purpose":  "Investigate Computer is the project room for repeatable computer-security diagnostics, incident evidence, cleanup notes, and report outputs for Wes\u0027s Windows computer.",
        "status":  "Status not recorded",
        "skill":  "investigate-computer",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\investigate-computer\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Investigate%20Computer/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Invoice Entry",
        "purpose":  "Invoice Entry owns operational processing after a structured invoice, receipt, statement-line, routed vendor-invoice, or routed Time Card source reaches this Project Room. It resolves the correct active project-management workbook, checks duplicates, determines approved row placement, performs authorized insertion, validates the workbook, and records the outcome. Invoice Entry does not redesign workbook templates, approve or pay invoices, monitor mailboxes, perform scan OCR, or make unsupported accounting decisions.",
        "status":  "Status not recorded",
        "skill":  "invoice-entry",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\invoice-entry\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019fbf4f-c629-7dd1-a3f6-0de33de0ed8f",
        "attention":  null,
        "group":  "Accounting \u0026 Project Data",
        "groupBasis":  "Maintains financial calculations, invoice processing, project workbooks, templates, or structured project data.",
        "modes":  [
                      "Standard Packet Processing",
                      "Create Vendor Invoice",
                      "Time Card",
                      "Statement Processing",
                      "Reconcile",
                      "Vendor Tabs"
                  ],
        "readmeUrl":  "../../Invoice%20Entry/README.md",
        "quickActions":  [

                         ],
        "invoiceEntryProjects":  [
                                     {
                                         "project":  "07-BYH - 3325 Banks Rd",
                                         "workbookPath":  "Property/07_Project Management - 3325 Banks Rd.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "13-SYH - 5008 Larchmont Dr",
                                         "workbookPath":  "Property/13_Project Management - 5008 Larchmont Dr.xlsx",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "15-BYH - 6004 Sandy Run",
                                         "workbookPath":  "Property/15_Project Management - 6004 Sandy Run.xlsx",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "16-BYH - 3021 Pearces Rd",
                                         "workbookPath":  "Property/16_Project Management - 3021 Pearces Rd.xlsx",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "17-SYH - 3413 Pinetree Ln",
                                         "workbookPath":  "Property/17_Project Management - 3413 Pinetree Ln.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "18-HM - 1426 Pleasant Garden Ln",
                                         "workbookPath":  "Property/18_Project Management - 1426 Pleasant Garden Ln.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "19-BYH - 8225 Burgwyn Ln",
                                         "workbookPath":  "Property/19_Project Management - 8225 Burgwyn Ln.xlsx",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "20-HM - 115 Rosebrooks Dr",
                                         "workbookPath":  "Property/20_Project Management - 115 Rosebrooks Dr.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "21-SYH - 1343 Old Buckhorn Rd",
                                         "workbookPath":  "Property/21_Project Management - 1343 Old Buckhorn Rd.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "22-HM - 2325 Cool Springs Rd",
                                         "workbookPath":  "Property/22_Project Management - 2325 Cool Springs Rd 4.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "23-SYH - 6316 Willowdell Dr",
                                         "workbookPath":  "Property/23_Project Management - 6316 Willowdell Dr 4.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "24-HM - 4121 Tensity Dr",
                                         "workbookPath":  "Property/24_Project Management - 4121 Tensity Dr 2.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "25-401K - 612 Britton Ct",
                                         "workbookPath":  "Property/25_Project Management - 612 Britton Ct.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "26-BYH - 908 Pond St",
                                         "workbookPath":  "Property/26_Project Management - 908 Pond St 3.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "27-HM - 7001 Outrigger Dr",
                                         "workbookPath":  "Property/27_Project Management - 7001 Outrigger Dr.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "28-SYH - 320 Rose Pl",
                                         "workbookPath":  "Property/28_Project Management - 320 Rose Pl.xlsm",
                                         "status":  "Current"
                                     },
                                     {
                                         "project":  "Mom - 18804 Hwy 41 Lutz",
                                         "workbookPath":  "Property/Mom_Project Management - 18804 Hwy 41 Lutz, 33549 US.xlsm",
                                         "status":  "Current"
                                     }
                                 ]
    },
    {
        "name":  "Jean Wright",
        "purpose":  "This Project Room is the durable operating room for Jean Wright / Office Assistant. Use this room for rules, operating notes, source inventories, review questions, and future improvements that affect Jean\u0027s general office-assistant role across Buy Your Home admin work.",
        "status":  "Status not recorded",
        "skill":  "jean-wright",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\jean-wright\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019fbe57-fcd9-7c83-be74-e377c7b9c4d0",
        "attention":  null,
        "group":  "Intake \u0026 Coordination",
        "groupBasis":  "Receives requests, routes work, creates Project Rooms, or provides an operating overview across workflows.",
        "modes":  [
                      "Start PR",
                      "Commit",
                      "Push",
                      "Dispatcher",
                      "General Delegation Default",
                      "Jean\u0027s Voice Intake"
                  ],
        "readmeUrl":  "../../Jean%20Wright/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Jennys Drawings",
        "purpose":  "This Project Room holds source material, working notes, open questions, and review-ready outputs for the Jennys Drawings workflow. Use this room when Wes asks Codex to organize, review, describe, prepare, or maintain materials specifically tied to Jennys Drawings.",
        "status":  "active review draft",
        "skill":  "jennys-drawings",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\jennys-drawings\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019ecba7-f1cc-7ac1-aaf7-d89a3f21b582",
        "attention":  null,
        "group":  "Publishing \u0026 Public Work",
        "groupBasis":  "Develops books, drawings, voice/media assets, websites, or other public-facing content.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Jennys%20Drawings/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "LD Evans",
        "purpose":  "This Project Room holds source material, working notes, open questions, and review-ready outputs for the LD Evans workflow. Use this room when Wes asks Codex to organize, analyze, draft, or maintain materials specifically tied to LD Evans.",
        "status":  "active manuscript development",
        "skill":  "ld-evans",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\ld-evans\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019ecba7-f1cc-7ac1-aaf7-d89a3f21b582",
        "attention":  null,
        "group":  "Publishing \u0026 Public Work",
        "groupBasis":  "Develops books, drawings, voice/media assets, websites, or other public-facing content.",
        "modes":  [

                  ],
        "readmeUrl":  "../../LD%20Evans/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Lowes Order",
        "purpose":  "This Project Room holds the repeatable workflow for Buy Your Home Lowe\u0027s order work. Use this room when Wes asks Codex to plan, organize, review, or document Lowe\u0027s ordering tasks, including source notes, order requirements, follow-up decisions, cart-filling from email instructions, and review-ready outputs.",
        "status":  "draft",
        "skill":  "lowes-order",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\lowes-order\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Lowes%20Order/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Manager",
        "purpose":  "This Project Room holds source material, working notes, open questions, and review-ready outputs for the Manager workflow. Use this room when Wes asks Codex to organize, define, draft, review, or maintain materials specifically routed to Manager.",
        "status":  "active draft",
        "skill":  "manager",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\manager\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019ecba7-f1cc-7ac1-aaf7-d89a3f21b582",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [
                      "Tasks",
                      "Time Card"
                  ],
        "readmeUrl":  "../../Manager/README.md",
        "quickActions":  [

                         ],
        "managerTasks":  [
                             {
                                 "taskId":  "MGR-20260724-001",
                                 "received":  "2026-07-24T13:49:47Z",
                                 "requester":  "Wes Will Buy Your Home \u003cWesWill@BuyYourHomeLLC.com\u003e",
                                 "task":  "Review the active project spreadsheets for proper automated entries of invoices and Lowes statement items.",
                                 "priority":  "Normal",
                                 "status":  "New",
                                 "due":  "",
                                 "delivered":  "",
                                 "lastUpdated":  "2026-07-24T14:02:19Z",
                                 "notes":  "Source: `sources\\email\\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested."
                             },
                             {
                                 "taskId":  "MGR-20260724-002",
                                 "received":  "2026-07-24T13:49:47Z",
                                 "requester":  "Wes Will Buy Your Home \u003cWesWill@BuyYourHomeLLC.com\u003e",
                                 "task":  "Prepare the next computer for Codex installation.",
                                 "priority":  "Normal",
                                 "status":  "New",
                                 "due":  "",
                                 "delivered":  "",
                                 "lastUpdated":  "2026-07-24T14:02:19Z",
                                 "notes":  "Source: `sources\\email\\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested."
                             },
                             {
                                 "taskId":  "MGR-20260724-003",
                                 "received":  "2026-07-24T13:49:47Z",
                                 "requester":  "Wes Will Buy Your Home \u003cWesWill@BuyYourHomeLLC.com\u003e",
                                 "task":  "Finish the Tensity project.",
                                 "priority":  "Normal",
                                 "status":  "New",
                                 "due":  "",
                                 "delivered":  "",
                                 "lastUpdated":  "2026-07-24T14:02:19Z",
                                 "notes":  "Source: `sources\\email\\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested."
                             },
                             {
                                 "taskId":  "MGR-20260724-004",
                                 "received":  "2026-07-24T13:49:47Z",
                                 "requester":  "Wes Will Buy Your Home \u003cWesWill@BuyYourHomeLLC.com\u003e",
                                 "task":  "Spend time working closely with Tim Flemming on the Pond project.",
                                 "priority":  "Normal",
                                 "status":  "New",
                                 "due":  "",
                                 "delivered":  "",
                                 "lastUpdated":  "2026-07-24T14:02:19Z",
                                 "notes":  "Source: `sources\\email\\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested."
                             },
                             {
                                 "taskId":  "MGR-20260724-005",
                                 "received":  "2026-07-24T13:49:47Z",
                                 "requester":  "Wes Will Buy Your Home \u003cWesWill@BuyYourHomeLLC.com\u003e",
                                 "task":  "See Jenny about anything that needs scanning.",
                                 "priority":  "Normal",
                                 "status":  "New",
                                 "due":  "",
                                 "delivered":  "",
                                 "lastUpdated":  "2026-07-24T14:02:19Z",
                                 "notes":  "Source: `sources\\email\\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested."
                             }
                         ]
    },
    {
        "name":  "Marketplace",
        "purpose":  "This Project Room owns the Facebook Marketplace tools workflow: finding tool listings, evaluating buy price versus likely resale value, calculating a safe offer, using Facebook Messenger to make and negotiate that offer when authorized, and notifying Wes by email when a seller reaches an agreement. Use this room when Wes asks Codex to search Facebook Marketplace for tools, evaluate a listing for resale profit, prepare or send an offer through Messenger, continue a seller conversation, or report Marketplace opportunities.",
        "status":  "paused by Wes as of 2026-08-05",
        "skill":  "marketplace",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\marketplace\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Systems \u0026 Maintenance",
        "groupBasis":  "Maintains computers, Codex operations, management support, purchasing tools, marketplace work, or system health.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Marketplace/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "New Project",
        "purpose":  "Capture the project purpose once Wes defines it. - Keep sources, working notes, and review-ready outputs separated from other Admin wiki work. - Preserve source materials and track open questions before drafting final outputs.",
        "status":  "Status not recorded",
        "skill":  "new-project",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\new-project\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Real Estate Transactions",
        "groupBasis":  "Supports property acquisition, valuation, buyer qualification, seller financing, transaction packaging, or project setup.",
        "modes":  [

                  ],
        "readmeUrl":  "../../New%20Project/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Operating Agreements",
        "purpose":  "Create a dedicated Project Room for operating agreements so entity governance documents, amendments, notes, and future agreement-related questions are reviewed from a clean source inventory.",
        "status":  "Status not recorded",
        "skill":  "",
        "skillPath":  "",
        "skillState":  "not-applicable",
        "taskId":  "",
        "attention":  null,
        "group":  "Legal \u0026 Entity",
        "groupBasis":  "Maintains litigation, confidential legal material, entity governance, ownership relationships, estate, or claim work.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Operating%20Agreements/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Project Management Spreadsheet Rewrite",
        "purpose":  "Rewrite and improve the Project Management spreadsheet used by Buy Your Home for real estate projects. The current workbook has a new instance for each real estate project, so the redesign must support repeatable project-level use without losing property-specific flexibility.",
        "status":  "Status not recorded",
        "skill":  "template-to-project",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\template-to-project\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Accounting \u0026 Project Data",
        "groupBasis":  "Maintains financial calculations, invoice processing, project workbooks, templates, or structured project data.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Project%20Management%20Spreadsheet%20Rewrite/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Property Trade Evaluation",
        "purpose":  "Maintain analyses, term sheets, valuation notes, and supporting materials for property trade and transaction-structure evaluations.",
        "status":  "active",
        "skill":  "property-trade-evaluation",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\property-trade-evaluation\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Real Estate Transactions",
        "groupBasis":  "Supports property acquisition, valuation, buyer qualification, seller financing, transaction packaging, or project setup.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Property%20Trade%20Evaluation/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "REI BlackBook",
        "purpose":  "Canonical Project Room; open its README for current responsibilities.",
        "status":  "started 2026-07-09",
        "skill":  "rei-blackbook",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\rei-blackbook\\SKILL.md",
        "skillState":  "available",
        "taskId":  "019ecba7-f1cc-7ac1-aaf7-d89a3f21b582",
        "attention":  null,
        "group":  "Publishing \u0026 Public Work",
        "groupBasis":  "Develops books, drawings, voice/media assets, websites, or other public-facing content.",
        "modes":  [

                  ],
        "readmeUrl":  "../../REI%20BlackBook/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "SOPs",
        "purpose":  "This Project Room is the canonical workspace for Buy Your Home SOP source material, SOP drafts, SOP review questions, and SOP maintenance outputs. Use this room when creating, reconciling, reviewing, or updating SOPs from task instruction emails, the SOP spreadsheet, or operating-rule updates.",
        "status":  "active",
        "skill":  "sops",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\sops\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Document Intake",
        "groupBasis":  "Receives, identifies, organizes, or maintains source documents and operating procedures before downstream processing.",
        "modes":  [

                  ],
        "readmeUrl":  "../../SOPs/README.md",
        "quickActions":  [

                         ],
        "sopEntries":  [
                           {
                               "label":  "Item 001 - Pay Bills - Truist",
                               "category":  "Accounting",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20001%20-%20Pay%20Bills%20-%20Truist.md"
                           },
                           {
                               "label":  "Item 009 - Assemble Teams folder for Property",
                               "category":  "Acquisition",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20009%20-%20Assemble%20Teams%20folder%20for%20Property.md"
                           },
                           {
                               "label":  "Item 021 - VCAP to ForeclosureList",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20021%20-%20VCAP%20to%20ForeclosureList.md"
                           },
                           {
                               "label":  "Item 022 - Import ForeclosureList to REI",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20022%20-%20Import%20ForeclosureList%20to%20REI.md"
                           },
                           {
                               "label":  "Item 023 - Skip Trace new REI Contacts (Discontinued, see Task 93)",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20023%20-%20Skip%20Trace%20new%20REI%20Contacts%20(Discontinued%2C%20see%20Task%2093).md"
                           },
                           {
                               "label":  "Item 024 - Validate Test Text Campaign",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20024%20-%20Validate%20Test%20Text%20Campaign.md"
                           },
                           {
                               "label":  "Item 025 - Respond to remove request in REI",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20025%20-%20Respond%20to%20remove%20request%20in%20REI.md"
                           },
                           {
                               "label":  "Item 026 - Exporting Closed Contacts from REI to ForeclosureList",
                               "category":  "Marketing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20026%20-%20Exporting%20Closed%20Contacts%20from%20REI%20to%20ForeclosureList.md"
                           },
                           {
                               "label":  "Item 027 - Prepping ForeclosureList for Mailing Letters",
                               "category":  "Marketing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20027%20-%20Prepping%20ForeclosureList%20for%20Mailing%20Letters.md"
                           },
                           {
                               "label":  "Item 028 - Printing Letters",
                               "category":  "Marketing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20028%20-%20Printing%20Letters.md"
                           },
                           {
                               "label":  "Item 032 - Purge Foreclosure List base on age(Discontinue)",
                               "category":  "Marketing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20032%20-%20Purge%20Foreclosure%20List%20base%20on%20age(Discontinue).md"
                           },
                           {
                               "label":  "Item 066 - Add Insurance",
                               "category":  "Property Rehab",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20066%20-%20Add%20Insurance.md"
                           },
                           {
                               "label":  "Item 067 - Start Electrical, Water \u0026 Gas Service",
                               "category":  "Property Rehab",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20067%20-%20Start%20Electrical%2C%20Water%20%26%20Gas%20Service.md"
                           },
                           {
                               "label":  "Item 075 - Add property to Our Website",
                               "category":  "Property Rehab",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20075%20-%20Add%20property%20to%20Our%20Website.md"
                           },
                           {
                               "label":  "Item 085 - REI Help Desk",
                               "category":  "Technical",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20085%20-%20REI%20Help%20Desk.md"
                           },
                           {
                               "label":  "Item 091 - Potential Property Visit Binder",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20091%20-%20Potential%20Property%20Visit%20Binder.md"
                           },
                           {
                               "label":  "Item 092 - Import to Direct Skip",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20092%20-%20Import%20to%20Direct%20Skip.md"
                           },
                           {
                               "label":  "Item 093 - Direct Skip to REI",
                               "category":  "Lead Sourcing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20093%20-%20Direct%20Skip%20to%20REI.md"
                           },
                           {
                               "label":  "Item 094 - Graphic \u0026 Web Design",
                               "category":  "Marketing",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20094%20-%20Graphic%20%26%20Web%20Design.md"
                           },
                           {
                               "label":  "Item 097 - Tracking Project Management Worksheet",
                               "category":  "Rehab",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20097%20-%20Tracking%20Project%20Management%20Worksheet.md"
                           },
                           {
                               "label":  "Item 098 - Reconnect Quickbook Connections",
                               "category":  "Accounting",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20098%20-%20Reconnect%20Quickbook%20Connections.md"
                           },
                           {
                               "label":  "Item 104 - Update Transactions into QuickBooks from Receipts",
                               "category":  "Accounting",
                               "href":  "../../SOPs/outputs/SOPs/SOP%20-%20Item%20104%20-%20Update%20Transactions%20into%20QuickBooks%20from%20Receipts.md"
                           }
                       ]
    },
    {
        "name":  "Template to Project",
        "purpose":  "This project room owns the process of moving approved worksheet, workbook, and mode designs from a prototype workbook into the active Buy Your Home project-management spreadsheets. Use this room for template development, worksheet-mode rules, active-project target lists, workbook migration plans, rollback/validation procedures, lessons learned, and rollout logs. This room began with the Pinetree-to-Pond conversion and the later project-management spreadsheet redesign work. Keep that history as source material, but treat the current room purpose as template-to-active-project migration and controlled workbook design rollout.",
        "status":  "Status not recorded",
        "skill":  "template-to-project",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\template-to-project\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Accounting \u0026 Project Data",
        "groupBasis":  "Maintains financial calculations, invoice processing, project workbooks, templates, or structured project data.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Template%20to%20Project/README.md",
        "quickActions":  [

                         ]
    },
    {
        "name":  "Voices",
        "purpose":  "Develop a practical, permissioned system so Wes\u0027s audible voice can be used to read text aloud, with an optional video avatar path for situations where a visual presenter is useful.",
        "status":  "Status not recorded",
        "skill":  "voices",
        "skillPath":  "C:\\Codex\\Wiki Files\\skills\\voices\\SKILL.md",
        "skillState":  "available",
        "taskId":  "",
        "attention":  null,
        "group":  "Publishing \u0026 Public Work",
        "groupBasis":  "Develops books, drawings, voice/media assets, websites, or other public-facing content.",
        "modes":  [

                  ],
        "readmeUrl":  "../../Voices/README.md",
        "quickActions":  [

                         ]
    }
];
