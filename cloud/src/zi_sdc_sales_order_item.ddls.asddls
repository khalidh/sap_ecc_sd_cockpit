@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SDC Sales Order Item'
define view entity ZI_SDC_SalesOrderItem
  as select from zsdc_vbap
{
      @UI.lineItem: [{ position: 10 }]
  key vbeln  as SalesOrder,
      @UI.lineItem: [{ position: 20 }]
  key posnr  as SalesOrderItem,
      @UI.lineItem: [{ position: 30 }]
      matnr  as Material,
      @UI.lineItem: [{ position: 40 }]
      arktx  as ItemDescription,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      @UI.lineItem: [{ position: 50 }]
      kwmeng as OrderQuantity,
      vrkme  as OrderQuantityUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @UI.lineItem: [{ position: 60 }]
      netwr  as NetAmount,
      waerk  as TransactionCurrency
}
