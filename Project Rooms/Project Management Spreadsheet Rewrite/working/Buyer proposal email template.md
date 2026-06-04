# Buyer Proposal Email Template

Use this template to generate a buyer-facing Contract for Deed / owner-financed purchase proposal from a project management workbook.

## Source Fields

Pull these values from the workbook:

| Template Field | Workbook Source |
|---|---|
| Buyer name | `Docs` worksheet, `Selling-Buyer` |
| Seller name | `Docs` worksheet, `Selling-Seller` |
| Property address line 1 | `Docs` worksheet, `Address` |
| Property city/state/ZIP | `Docs` worksheet, `City-State` |
| Spanish version flag | `Docs` worksheet, `Spanish`; current workbook stores the flag in `Docs!B5` beside label `Docs!A5` |
| Proposed purchase price | `Amortization` worksheet proposal price, currently `O3` |
| Down payment percent | `Amortization` worksheet down payment percentage, currently `O2` |
| Initial deposit / down payment | `Amortization` worksheet deposit, currently `O4` |
| Amount financed after deposit | `Amortization` worksheet financed balance, currently `O5` |
| Proposed contract start date | `Amortization` worksheet contract date, currently `O10` |
| Financing term | `Amortization` worksheet term, currently `O8` / `P8` |
| Interest rate | `Amortization` worksheet interest rate, currently `O7` |
| Monthly principal and interest payment | `Amortization` worksheet monthly payment, currently `O9` |
| Monthly property insurance escrow | `Amortization` worksheet insurance escrow, currently `T8` |
| Monthly property tax escrow | `Amortization` worksheet tax escrow, currently `T9` |
| Estimated total monthly payment | Principal and interest plus insurance escrow plus tax escrow |

## Sending Rules

- Send only to Wes for review unless Wes explicitly approves sending to the buyer.
- Do not include internal notes, spreadsheet source notes, or uncertainty notes in the buyer-facing version.
- Use an HTML table for the terms. Plain-text spacing does not render cleanly in Outlook.
- If the Spanish version flag is `Yes`, place the full English proposal first, then repeat the buyer-facing proposal in Spanish below the English version.
- The first Spanish iteration must begin with this disclaimer: `Aviso: La version en ingles controla y es la version oficial. La version en espanol se proporciona como un esfuerzo de buena fe para comunicarnos claramente.`
- If sending as Jean/OfficeAssist is blocked, tell Wes the actual sender and do not send externally until the sender path is fixed or Wes explicitly approves the workaround.

## Subject

```text
Proposed Contract for Deed Terms for {{Property Address Line 1}}
```

## HTML Email Template

```html
<html>
<body style="font-family: Calibri, Arial, sans-serif; font-size: 11pt; color: #222;">
<p>Dear {{Buyer Name}},</p>

<p>Thank you for your interest in purchasing {{Property Address Line 1}} in {{Property City}}. Based on the financing structure we have modeled, {{Seller Name}} would be willing to discuss a Contract for Deed / owner-financed purchase using the following proposed terms:</p>

<p><strong>Property:</strong><br>
{{Property Address Line 1}}<br>
{{Property City/State/ZIP}}</p>

<p><strong>Seller:</strong><br>
{{Seller Name}}</p>

<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Calibri, Arial, sans-serif; font-size: 11pt; min-width: 560px;">
  <tr style="background-color: #f2f2f2;">
    <th align="center">Term</th>
    <th align="center">Proposed Amount / Detail</th>
  </tr>
  <tr><td align="right">Proposed purchase price</td><td>{{Proposed Purchase Price}}</td></tr>
  <tr><td align="right">Initial deposit / down payment ({{Down Payment Percent}} of purchase price)</td><td>{{Initial Deposit / Down Payment}}</td></tr>
  <tr><td align="right">Amount financed after deposit</td><td>{{Amount Financed After Deposit}}</td></tr>
  <tr><td align="right">Proposed contract start date</td><td>{{Proposed Contract Start Date}}</td></tr>
  <tr><td align="right">Financing term</td><td>{{Financing Term}}</td></tr>
  <tr><td align="right">Interest rate</td><td>{{Interest Rate}}</td></tr>
  <tr><td align="right">Monthly principal and interest payment</td><td>{{Monthly Principal and Interest Payment}}</td></tr>
  <tr><td align="right">Monthly property insurance escrow</td><td>{{Monthly Property Insurance Escrow}}</td></tr>
  <tr><td align="right">Monthly property tax escrow</td><td>{{Monthly Property Tax Escrow}}</td></tr>
  <tr style="font-weight: bold;"><td align="right">Estimated total monthly payment</td><td>{{Estimated Total Monthly Payment}}</td></tr>
</table>

<p>The monthly escrow items are expected to be collected with the monthly payment.</p>

<p>This proposal is intended to give you a clear starting point for discussion. Final terms would need to be confirmed in writing and would be subject to the final contract documents, any required disclosures, verification of buyer qualifications, and confirmation of how taxes, insurance, maintenance, default rights, and transfer timing will be handled.</p>

<p>If these general terms are workable for you, the next step would be to discuss the structure in more detail and decide whether we should prepare formal paperwork for review.</p>

<p>Sincerely,</p>

<p>Wes Browning</p>

<p>{{Seller Name}}</p>

{{If Spanish Version Flag is Yes}}

<hr>

<p><strong>Aviso:</strong> La version en ingles controla y es la version oficial. La version en espanol se proporciona como un esfuerzo de buena fe para comunicarnos claramente.</p>

<p>Estimado/a {{Buyer Name}},</p>

<p>Gracias por su interes en comprar {{Property Address Line 1}} en {{Property City}}. Segun la estructura de financiamiento que hemos modelado, {{Seller Name}} estaria dispuesto a conversar sobre una compra mediante Contrato de Escritura / financiamiento del propietario bajo los siguientes terminos propuestos:</p>

<p><strong>Propiedad:</strong><br>
{{Property Address Line 1}}<br>
{{Property City/State/ZIP}}</p>

<p><strong>Vendedor:</strong><br>
{{Seller Name}}</p>

<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; font-family: Calibri, Arial, sans-serif; font-size: 11pt; min-width: 560px;">
  <tr style="background-color: #f2f2f2;">
    <th align="center">Termino</th>
    <th align="center">Monto / Detalle Propuesto</th>
  </tr>
  <tr><td align="right">Precio de compra propuesto</td><td>{{Proposed Purchase Price}}</td></tr>
  <tr><td align="right">Deposito inicial / pago inicial ({{Down Payment Percent}} del precio de compra)</td><td>{{Initial Deposit / Down Payment}}</td></tr>
  <tr><td align="right">Monto financiado despues del deposito</td><td>{{Amount Financed After Deposit}}</td></tr>
  <tr><td align="right">Fecha propuesta de inicio del contrato</td><td>{{Proposed Contract Start Date}}</td></tr>
  <tr><td align="right">Plazo de financiamiento</td><td>{{Financing Term}}</td></tr>
  <tr><td align="right">Tasa de interes</td><td>{{Interest Rate}}</td></tr>
  <tr><td align="right">Pago mensual de principal e interes</td><td>{{Monthly Principal and Interest Payment}}</td></tr>
  <tr><td align="right">Deposito mensual para seguro de la propiedad</td><td>{{Monthly Property Insurance Escrow}}</td></tr>
  <tr><td align="right">Deposito mensual para impuestos de la propiedad</td><td>{{Monthly Property Tax Escrow}}</td></tr>
  <tr style="font-weight: bold;"><td align="right">Pago mensual total estimado</td><td>{{Estimated Total Monthly Payment}}</td></tr>
</table>

<p>Se espera que los montos mensuales de reserva para seguro e impuestos se cobren junto con el pago mensual.</p>

<p>Esta propuesta tiene la intencion de darle un punto de partida claro para la conversacion. Los terminos finales tendrian que confirmarse por escrito y estarian sujetos a los documentos finales del contrato, cualquier divulgacion requerida, verificacion de las calificaciones del comprador, y confirmacion de como se manejaran los impuestos, seguro, mantenimiento, derechos en caso de incumplimiento y el momento de la transferencia.</p>

<p>Si estos terminos generales son aceptables para usted, el siguiente paso seria conversar la estructura con mas detalle y decidir si debemos preparar documentacion formal para revision.</p>

<p>Atentamente,</p>

<p>Wes Browning</p>

<p>{{Seller Name}}</p>

{{End If}}
</body>
</html>
```
