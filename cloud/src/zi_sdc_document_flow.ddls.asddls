@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SDC Document Flow'
define view entity ZI_SDC_DocumentFlow
  as select from zsdc_vbfa
{
      @UI.lineItem: [{ position: 10 }]
  key vbelv   as PrecedingDocument,
      @UI.lineItem: [{ position: 20 }]
  key posnv   as PrecedingItem,
      @UI.lineItem: [{ position: 30 }]
  key vbeln   as SubsequentDocument,
      @UI.lineItem: [{ position: 40 }]
  key posnn   as SubsequentItem,
      @UI.lineItem: [{ position: 50 }]
      vbtyp_n as SubsequentCategory,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @UI.lineItem: [{ position: 60 }]
      rfmng   as ReferencedQuantity,
      meins   as BaseUnit
}
