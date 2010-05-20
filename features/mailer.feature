Feature: In order to increase revenue
  Mailer should communicate means of payment to invoiced companies

  Scenario: 
    Given mail uses "development" environment
      And database is empty
      And company "mother" has email "thierry.henrio@gmail.com"
      And user "junio" with email "junio.hamano@gmail.com" belongs to "mother"
      And company "mother" has invoice "INV-0001"
      And invoice "INV-0001" has an invoiceable "AGF10P70" for "junio"
    When invoice "INV-0001" is mailed using template "xero/how-to-pay.html.haml"
    Then company should received a mail with attached file "rib-iban.pdf"