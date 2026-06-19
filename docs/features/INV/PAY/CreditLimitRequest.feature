@CreditLimitRequest
Feature: Credit Limit Increase Request

  As a credit card holder
  I want to request a credit limit increase
  So that I can have greater purchasing power

  Background:
    Given the customer has an active credit card account

    @Payment
  Scenario: Approve credit limit increase for an eligible customer
    When the customer requests a credit limit increase with:
      | Current Limit | 5000  |
      | New Limit     | 8000  |
      | Income        | 7000  |
      | Credit Score  | 780   |
    Then the credit limit increase request should be approved
    | datasource |CREDIT_CARD_BY_CUSTOMER_ID.sql|
    And the credit card limit should be updated to "8000"
    And a confirmation email should be sent to the customer

    @Billing
  Scenario: Reject credit limit increase due to low credit score
    When the customer requests a credit limit increase with:
      | Current Limit | 5000  |
      | New Limit     | 10000 |
      | Income        | 7000  |
      | Credit Score  | 600   |
    Then the credit limit increase request should be rejected
    | datasource |CREDIT_CARD_BY_CUSTOMER_ID.sql|
    And the rejection reason should be "Credit score below minimum threshold"

  Scenario Outline: Send credit limit increase request for manual review
    When the customer requests a credit limit increase with:
      | Current Limit | <CurrentLimit> |
      | New Limit     | <NewLimit>     |
      | Income        | <Income>       |
      | Credit Score  | <CreditScore>  |
    Then the credit limit increase request status should be "Pending Review"
    | datasource |CREDIT_CARD_BY_CUSTOMER_ID.sql|
    And the request should be assigned to a credit analyst

    Examples:
      | CurrentLimit | NewLimit | Income | CreditScore |
      | 5000         | 9000     | 4500   | 670         |
      | 6000         | 10000    | 5000   | 660         |
      | 7000         | 12000    | 5500   | 680         |