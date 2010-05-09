Feature: In order to increase revenue
  XeroInvoicer should create invoices on external xero accounting system
  

  Scenario: 
    Given a XeroInvoicer using sandbox xero account
    And database is empty
    And database has a company google
    And John Doe, from google, attends
    When XeroInvoicer invoices
    Then there is an invoice for google having a xero_id field
