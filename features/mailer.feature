@mail
Feature: In order to save customer time

  Scenario: 
    Given mail uses "development" environment
      And database is empty
      And speaker thierry has email thierry.henrio@gmail.com
      And speaker thierry has two scheduled sessions
    When speaker thierry is mailed
    Then thierry should receive one mail with two sessions

  Scenario:
    Given mail uses "development" environment
      And database is empty
      And participant thierry has email thierry.henrio@gmail.com
    When participant thierry is mailed
    Then participant thierry should receive one mail    