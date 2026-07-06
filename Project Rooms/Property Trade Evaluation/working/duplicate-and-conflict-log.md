# Property Trade Evaluation Duplicate And Conflict Log

| Item | Source(s) | Issue Type | Resolution / Needed Decision |
| --- | --- | --- | --- |
| Historical rendered folders | `working\rendered-*` | generated duplicates | Do not treat rendered previews as independent source facts. Use them only for visual QA of their parent deliverable. |
| Local dependency folder | `working\node_modules` | generated/dependency files | Do not commit as durable source unless Wes explicitly approves a reproducible tool bundle. |

