@Payment
Feature: Credit Card Application Approval

  As a customer
  I want to apply for a credit card
  So that I can access a line of credit

  Background:
    Given the customer is on the credit card application page

  Scenario: Approve application for an eligible customer
    When the customer submits an application with:
      | Age          | 30      |
      | Income       | 5000    |
      | Credit Score | 750     |
    Then the application should be approved
    | datasource | CREDIT_CARD_BY_CUSTOMER |
    And a credit card account should be created
    And a welcome email should be sent to the customer

  Scenario: Reject application due to low credit score
    When the customer submits an application with:
      | Age          | 30      |
      | Income       | 5000    |
      | Credit Score | 550     |
    Then the application should be rejected
    | datasource | CREDIT_CARD_BY_CUSTOMER |
    And the rejection reason should be "Credit score below minimum threshold"

  Scenario Outline: Send application for manual review
    When the customer submits an application with:
      | Age          | <Age>         |
      | Income       | <Income>      |
      | Credit Score | <CreditScore> |
    Then the application status should be "Pending Review"
    | datasource | CREDIT_CARD_BY_CUSTOMER |
    And the application should be assigned to a credit analyst

    Examples:
      | Age | Income | CreditScore |
      | 25  | 2500   | 650         |
      | 30  | 2800   | 620         |
      | 40  | 3000   | 640         |
