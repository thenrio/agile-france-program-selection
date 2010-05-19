Feature: In order to increase revenue
  Mailer should communicate means of payment to invoiced companies

  Scenario: 
    Given a development environment
    And database is empty
    And database has company "mother"
    And "mother" has contact "thierry.henrio@gmail.com"
    And "junio" "hamano" having email "junio.hamano@gmail.com" belongs to "mother"
    And database has invoice with invoicing_system_id "INV-0001"
    And "INV-0001" has an invoiceable "AGF10P70" for
    When mailer mails invoice "INV-0001" using template "xero/how-to-pay.html.haml"
    Then a mail to "thierry.henrio@gmail.com" should be sent, with an attached file "rib-iban.pdf"