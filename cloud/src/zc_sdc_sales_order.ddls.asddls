@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Cockpit Sales Orders'
@Metadata.allowExtensions: true
@UI.headerInfo: {
  typeName: 'Sales Order',
  typeNamePlural: 'Sales Orders',
  title: { type: #STANDARD, value: 'SalesOrder' },
  description: { value: 'CustomerName' }
}
@UI.presentationVariant: [{
  sortOrder: [{ by: 'SalesOrderDate', direction: #DESC }]
}]
define root view entity ZC_SDC_SalesOrder
  as projection on ZI_SDC_SalesOrder
{
      @UI.facet: [
        { id: 'General', type: #IDENTIFICATION_REFERENCE, label: 'General', position: 10 },
        { id: 'Items', type: #LINEITEM_REFERENCE, label: 'Items', position: 20, targetElement: '_Item' },
        { id: 'DocumentFlow', type: #LINEITEM_REFERENCE, label: 'Document Flow', position: 30, targetElement: '_DocumentFlow' }
      ]
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
  key SalesOrder,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 10 }]
      SalesOrderDate,

      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      @UI.identification: [{ position: 30 }]
      @UI.selectionField: [{ position: 20 }]
      Customer,

      @UI.lineItem: [{ position: 40, importance: #HIGH }]
      @UI.identification: [{ position: 40 }]
      CustomerName,

      @UI.lineItem: [{ position: 50 }]
      @UI.selectionField: [{ position: 30 }]
      SalesOrganization,

      @UI.lineItem: [{ position: 60 }]
      DistributionChannel,

      @UI.lineItem: [{ position: 70 }]
      Division,

      @UI.lineItem: [{ position: 80 }]
      SalesOrderType,

      @UI.lineItem: [{ position: 90, importance: #HIGH }]
      @UI.identification: [{ position: 50 }]
      NetAmount,

      TransactionCurrency,

      @UI.lineItem: [{ position: 100 }]
      @UI.selectionField: [{ position: 40 }]
      DeliveryStatus,

      @UI.lineItem: [{ position: 110 }]
      @UI.selectionField: [{ position: 50 }]
      BillingStatus,

      _Customer,
      _Item,
      _DocumentFlow
}
