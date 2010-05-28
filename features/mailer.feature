@mail
Feature: In order to save customer time

  @speaker
  Scenario: 
    Given mail uses "development" environment
      And database is empty
      And speaker thierry has email thierry.henrio@gmail.com
      And speaker thierry has two scheduled sessions
    When speaker thierry is mailed
    Then thierry should receive one mail with two sessions

  @attendee
  Scenario:
    Given mail uses "development" environment
      And database is empty
      And attendee thierry has email thierry.henrio@gmail.com
    When attendee thierry is mailed
    Then attendee thierry should receive a mail    