Feature: In order to increase revenue
  XeroInvoicer should create invoices on external xero accounting system
  

  Scenario: 
    Given a XeroInvoicer using sandbox xero account
    And database is empty
    And database has a company 37signals
    And John Doe, from 37signals, attends
    And wycats, from 37signals, attends as early
    When XeroInvoicer invoices 37signals
    Then there is an invoice for 37signals having invoiceable for john and wycats
