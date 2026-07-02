import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const projectRoot = "C:\\Codex\\Wiki Files\\Project Rooms\\Property Trade Evaluation";
const outputDir = path.join(projectRoot, "outputs");
const outputPath = path.join(outputDir, "Manufactured Home Trade Metrics.xlsx");
const previewPath = path.join(outputDir, "Manufactured Home Trade Metrics Preview.png");

await fs.mkdir(outputDir, { recursive: true });

const workbook = Workbook.create();
const sheet = workbook.worksheets.add("Trade Metrics");
sheet.showGridLines = false;

sheet.getRange("A1:N1").merge();
sheet.getRange("A1").values = [["Manufactured Home Trade Metrics"]];
sheet.getRange("A1").format = {
  fill: "#17324D",
  font: { bold: true, color: "#FFFFFF", size: 16 },
  horizontalAlignment: "center",
  verticalAlignment: "center",
};
sheet.getRange("A2:N2").merge();
sheet.getRange("A2").values = [[
  "Enter estimated property values later. Metrics update from lot rent, tenant payment, and property value inputs.",
]];
sheet.getRange("A2").format = {
  fill: "#EAF1F8",
  font: { color: "#334E68", size: 10 },
  wrapText: true,
};

const headers = [[
  "Property",
  "Home Type",
  "Est. Property Value",
  "Lot Rent / Mo",
  "Tenant Payment / Mo",
  "Monthly Gross Spread",
  "Annual Gross Spread",
  "Lot Rent % of Payment",
  "Spread Margin",
  "Gross Yield on Value",
  "Max Value @ 10%",
  "Max Value @ 12%",
  "Max Value @ 15%",
  "Notes",
]];
sheet.getRange("A5:N5").values = headers;
sheet.getRange("A5:N5").format = {
  fill: "#254F7A",
  font: { bold: true, color: "#FFFFFF", size: 10 },
  horizontalAlignment: "center",
  verticalAlignment: "center",
  wrapText: true,
  borders: { preset: "all", style: "thin", color: "#B8C5D3" },
};

sheet.getRange("A6:E8").values = [
  ["5009 Sunnyfield Dr", "Single wide", null, 782, 1800],
  ["5021 Sunnyfield Dr", "Double wide", null, 782, 1950],
  ["5512 Desert Willow Ln", "Single wide", null, 500, 1600],
];
sheet.getRange("A9:E9").values = [["Total", "", null, null, null]];
sheet.getRange("N6:N8").values = [
  ["Tenant pays $1,800; lot rent is $782."],
  ["Assumed tenant rent is $1,950; lot rent is $782."],
  ["Tenant pays $1,600; lot rent is $500."],
];
sheet.getRange("N9").values = [[""]];

sheet.getRange("F6:M8").formulas = [
  [
    '=IF(OR(D6="",E6=""),"",E6-D6)',
    '=IF(F6="","",F6*12)',
    '=IFERROR(D6/E6,"")',
    '=IFERROR(F6/E6,"")',
    '=IFERROR(G6/C6,"")',
    '=IF(G6="","",G6/10%)',
    '=IF(G6="","",G6/12%)',
    '=IF(G6="","",G6/15%)',
  ],
  [
    '=IF(OR(D7="",E7=""),"",E7-D7)',
    '=IF(F7="","",F7*12)',
    '=IFERROR(D7/E7,"")',
    '=IFERROR(F7/E7,"")',
    '=IFERROR(G7/C7,"")',
    '=IF(G7="","",G7/10%)',
    '=IF(G7="","",G7/12%)',
    '=IF(G7="","",G7/15%)',
  ],
  [
    '=IF(OR(D8="",E8=""),"",E8-D8)',
    '=IF(F8="","",F8*12)',
    '=IFERROR(D8/E8,"")',
    '=IFERROR(F8/E8,"")',
    '=IFERROR(G8/C8,"")',
    '=IF(G8="","",G8/10%)',
    '=IF(G8="","",G8/12%)',
    '=IF(G8="","",G8/15%)',
  ],
];
sheet.getRange("C9:M9").formulas = [[
  "=SUM(C6:C8)",
  "=SUM(D6:D8)",
  "=SUM(E6:E8)",
  "=SUM(F6:F8)",
  "=SUM(G6:G8)",
  '=IFERROR(D9/E9,"")',
  '=IFERROR(F9/E9,"")',
  '=IFERROR(G9/C9,"")',
  '=IF(G9="","",G9/10%)',
  '=IF(G9="","",G9/12%)',
  '=IF(G9="","",G9/15%)',
]];

sheet.getRange("A6:N9").format = {
  fill: "#FFFFFF",
  font: { size: 10, color: "#1F2933" },
  borders: { preset: "all", style: "thin", color: "#D8DEE6" },
  verticalAlignment: "center",
};
sheet.getRange("A6:B9").format.horizontalAlignment = "left";
sheet.getRange("N6:N9").format = { wrapText: true, horizontalAlignment: "left" };
sheet.getRange("C6:G9").format.numberFormat = "$#,##0";
sheet.getRange("H6:J9").format.numberFormat = "0.0%";
sheet.getRange("K6:M9").format.numberFormat = "$#,##0";
sheet.getRange("A9:N9").format = {
  fill: "#EAF1F8",
  font: { bold: true, color: "#17324D", size: 10 },
  borders: { preset: "all", style: "thin", color: "#B8C5D3" },
};

sheet.getRange("P3:Q3").values = [["Summary", "Value"]];
sheet.getRange("P3:Q3").format = {
  fill: "#254F7A",
  font: { bold: true, color: "#FFFFFF", size: 10 },
  horizontalAlignment: "center",
  borders: { preset: "all", style: "thin", color: "#B8C5D3" },
};
sheet.getRange("P4:P8").values = [
  ["Known Monthly Spread"],
  ["Known Annual Spread"],
  ["Monthly Tenant Payments"],
  ["Monthly Lot Rent"],
  ["Gross Yield on Entered Values"],
];
sheet.getRange("Q4:Q8").formulas = [
  ["=F9"],
  ["=G9"],
  ["=E9"],
  ["=D9"],
  ['=IFERROR(G9/C9,"")'],
];
sheet.getRange("P4:Q8").format = {
  fill: "#F7FAFC",
  borders: { preset: "all", style: "thin", color: "#D8DEE6" },
  font: { size: 10, color: "#1F2933" },
};
sheet.getRange("Q4:Q7").format.numberFormat = "$#,##0";
sheet.getRange("Q8").format.numberFormat = "0.0%";

sheet.getRange("P10:Q10").values = [["Target Yield", "Implied Total Value"]];
sheet.getRange("P10:Q10").format = {
  fill: "#EAF1F8",
  font: { bold: true, color: "#17324D", size: 10 },
  horizontalAlignment: "center",
  borders: { preset: "all", style: "thin", color: "#B8C5D3" },
};
sheet.getRange("P11:P13").values = [["10%"], ["12%"], ["15%"]];
sheet.getRange("Q11:Q13").formulas = [["=IF($Q$5=0,\"\",$Q$5/10%)"], ["=IF($Q$5=0,\"\",$Q$5/12%)"], ["=IF($Q$5=0,\"\",$Q$5/15%)"]];
sheet.getRange("P11:Q13").format = {
  fill: "#FFFFFF",
  borders: { preset: "all", style: "thin", color: "#D8DEE6" },
  font: { size: 10, color: "#1F2933" },
};
sheet.getRange("P11:P13").format.numberFormat = "0%";
sheet.getRange("Q11:Q13").format.numberFormat = "$#,##0";

sheet.getRange("P16:Q19").values = [
  ["Property", "Monthly Spread"],
  ["5009 Sunnyfield Dr", null],
  ["5021 Sunnyfield Dr", null],
  ["5512 Desert Willow Ln", null],
];
sheet.getRange("Q17:Q19").formulas = [["=IF(F6=\"\",0,F6)"], ["=IF(F7=\"\",0,F7)"], ["=IF(F8=\"\",0,F8)"]];
sheet.getRange("P16:Q19").format = {
  fill: "#FFFFFF",
  borders: { preset: "all", style: "thin", color: "#D8DEE6" },
  font: { size: 9, color: "#1F2933" },
};
sheet.getRange("P16:Q16").format = {
  fill: "#EAF1F8",
  font: { bold: true, color: "#17324D", size: 9 },
};
sheet.getRange("Q17:Q19").format.numberFormat = "$#,##0";

const chart = sheet.charts.add("bar", sheet.getRange("P16:Q19"));
chart.title = "Monthly Gross Spread";
chart.hasLegend = false;
chart.xAxis = { axisType: "textAxis" };
chart.yAxis = { numberFormatCode: "$#,##0" };
chart.setPosition("P21", "W36");

sheet.getRange("A12:N14").merge(true);
sheet.getRange("A12").values = [["Notes"]];
sheet.getRange("A13").values = [[
  "Gross spread is tenant payment less lot rent only. It does not include repairs, taxes, insurance, management, vacancy, collections, financing, or other costs.",
]];
sheet.getRange("A14").values = [[
  "Max value columns show what each property could support at simple gross-spread yields of 10%, 12%, and 15% before other expenses.",
]];
sheet.getRange("A12:N14").format = {
  fill: "#F7FAFC",
  font: { size: 10, color: "#334E68" },
  wrapText: true,
  borders: { preset: "outside", style: "thin", color: "#D8DEE6" },
};
sheet.getRange("A12").format = {
  fill: "#EAF1F8",
  font: { bold: true, color: "#17324D", size: 10 },
};

const widths = {
  A: 24, B: 18, C: 16, D: 14, E: 16, F: 17, G: 17, H: 16, I: 14, J: 16, K: 16, L: 16, M: 16, N: 36,
  P: 24, Q: 18,
};
for (const [col, width] of Object.entries(widths)) {
  sheet.getRange(`${col}:${col}`).format.columnWidth = width;
}
sheet.getRange("A1:N1").format.rowHeight = 30;
sheet.getRange("A2:N2").format.rowHeight = 34;
sheet.getRange("A5:N5").format.rowHeight = 38;
sheet.freezePanes.freezeRows(5);

const preview = await workbook.render({
  sheetName: "Trade Metrics",
  range: "A1:W36",
  scale: 1,
  format: "png",
});
await fs.writeFile(previewPath, new Uint8Array(await preview.arrayBuffer()));

const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "formula error scan",
});
console.log(errors.ndjson);

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);
console.log(outputPath);
console.log(previewPath);
