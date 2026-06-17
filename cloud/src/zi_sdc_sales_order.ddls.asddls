@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SDC Sales Order'
define root view entity ZI_SDC_SalesOrder
  as select from zsdc_vbak
  association [0..1] to ZI_SDC_Customer       as _Customer
    on $projection.Customer = _Customer.Customer
  association [0..*] to ZI_SDC_SalesOrderItem as _Item
    on $projection.SalesOrder = _Item.SalesOrder
  association [0..*] to ZI_SDC_DocumentFlow   as _DocumentFlow
    on $projection.SalesOrder = _DocumentFlow.PrecedingDocument
{
  key vbeln as SalesOrder,
      audat as SalesOrderDate,
      kunnr as Customer,
      _Customer.CustomerName as CustomerName,
      vkorg as SalesOrganization,
      vtweg as DistributionChannel,
      spart as Division,
      auart as SalesOrderType,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      netwr as NetAmount,
      waerk as TransactionCurrency,
      lfstk as DeliveryStatus,
      fkstk as BillingStatus,
      _Customer,
      _Item,
      _DocumentFlow
}
