# Entity Relationship Chart

Status: review draft, not legal or tax advice.

This chart separates source-backed relationships from user-reported or working-draft relationships.

## Legend

- Solid line: supported by copied estate documents or current project-room summaries.
- Dashed line: user-reported, draft, or needs source confirmation.
- Conflict marker: current sources do not all say the same thing.

## Formal Relationship Diagram

```mermaid
flowchart TB
    Wes["Wesley Dale Browning"]
    Jenny["Jeanette Wilson Hollinger / Jenny"]
    Trust["Browning Family Revocable Trust<br/>dated June 21, 2023"]
    BYH["Buy Your Home, LLC<br/>(BYH)"]
    Heritage["Heritage Management LLC"]
    IS["Investment Services LLC"]
    SYH["Sell Your Home, LLC<br/>(SYH)"]
    BYH401K["BYH 401K LLC"]
    RothHSA["Two Roth accounts + one HSA<br/>(Wes/Jenny)"]
    Solo401K["Wes/Jenny Solo 401K<br/>relationship unclear"]
    RealEstate["Long-term property holdings"]
    Services["Services / management / signing authority<br/>for other entities"]
    Conflict["Ownership conflict to resolve:<br/>Estate matrix says user-reported BYH-owned;<br/>Operating Agreements V02 working facts say<br/>BYH, SYH, Heritage, and BYH 401K each hold 25%."]

    Wes -->|"grantor / initial co-trustee"| Trust
    Jenny -->|"grantor / initial co-trustee"| Trust
    Trust -->|"100% BYH membership interest assigned to Trust"| BYH

    BYH -.->|"reported 100% owner; source docs still needed"| Heritage
    Heritage -.->|"reported long-term property holder"| RealEstate

    RothHSA -.->|"reported owner through retirement / HSA accounts"| SYH
    Solo401K -.->|"relationship unclear; source docs needed"| BYH401K

    BYH -.->|"possible 25% member under IS V02 working facts"| IS
    SYH -.->|"possible 25% member under IS V02 working facts"| IS
    Heritage -.->|"possible 25% member under IS V02 working facts"| IS
    BYH401K -.->|"possible 25% member under IS V02 working facts"| IS

    IS -.->|"reported service / signing / management role"| Services
    IS -.->|"reported trustee / manager role for SYH; documents needed"| SYH
    IS -.-> Conflict

    classDef supported fill:#dff3e3,stroke:#247a3d,stroke-width:2px,color:#102915;
    classDef reported fill:#fff3cd,stroke:#b58100,stroke-width:2px,color:#3b2b00;
    classDef conflict fill:#fde2e1,stroke:#b3261e,stroke-width:2px,color:#3b0907;
    classDef role fill:#e8efff,stroke:#365fbd,stroke-width:2px,color:#0d1b42;

    class Wes,Jenny,Trust,BYH supported;
    class Heritage,SYH,BYH401K,RothHSA,Solo401K,RealEstate reported;
    class IS,Services role;
    class Conflict conflict;
```

## SVG Version

For a shareable graphic file, see:

`C:\Codex\Wiki Files\Project Rooms\Estate Documents\outputs\entity-relationship-chart.svg`

## Source Notes

### Source-backed

- The estate summary says the Buy Your Home, LLC assignment transferred 100% of BYH membership interest from Wes and Jeanette/Jenny to the Browning Family Revocable Trust dated June 21, 2023.
- The estate summary identifies Wes and Jeanette/Jenny as trust grantors and initial co-trustees.

### User-reported / needs confirmation

- Heritage Management LLC is reported as wholly owned by BYH and as holding long-term property.
- Sell Your Home, LLC is reported as owned through two Roth accounts and one HSA belonging to Wes and Jenny.
- BYH 401K LLC is reported as related to Wes and Jenny's Solo 401K, but the ownership direction is unclear.
- Investment Services LLC is reported as providing services, signing authority, and management/trustee functions.

### Conflict to resolve

- `Project Rooms\Estate Documents\outputs\entity-estate-review-matrix.md` records Investment Services LLC as user-reported BYH-owned.
- `Project Rooms\Operating Agreements\working\Investment Services\README.md` records current V02 working facts that Investment Services LLC members are Buy Your Home, LLC; Sell Your Home, LLC; Heritage Management LLC; and BYH 401K LLC, each with 25%.

Before using this chart with an attorney, lender, title company, or CPA, confirm the current operating agreements, membership ledgers, resolutions, account-owned LLC records, beneficiary designations, and signing-authority documents.
