@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SDC Customer'
define view entity ZI_SDC_Customer
  as select from zsdc_kna1
{
  key kunnr as Customer,
      name1 as CustomerName,
      land1 as Country
}
