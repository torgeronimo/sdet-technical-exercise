
*** Settings ***
Documentation    Automated inventory tests for SauceDemo.
Resource    ../resources/common.resource
Resource    ../resources/login.resource
Resource    ../resources/inventory.resource

Test Setup       Open Inventory Page
Test Teardown    Close SauceDemo Browser


*** Variables ***
${VALID_USERNAME}       standard_user
${VALID_PASSWORD}       secret_sauce

${SORT_NAME_ASC}         Name (A to Z)
${SORT_NAME_DESC}        Name (Z to A)
${SORT_PRICE_ASC}        Price (low to high)
${SORT_PRICE_DESC}       Price (high to low)

${TEST_PRODUCT}          Sauce Labs Backpack


*** Test Cases ***
INV-001 Inventory Page Displays Products
    [Documentation]    Verify that inventory loads and displays products.
    [Tags]    inventory    smoke    positive
    Verify Inventory Products Are Displayed

INV-002 Products Display Complete Information
    [Documentation]    Verify that all products have names, descriptions, and valid prices.
    [Tags]    inventory    validation
    Verify Product Information

INV-003 Products Can Be Sorted By Name A To Z
    [Documentation]    Verify alphabetical ascending product sorting.
    [Tags]    inventory    sorting
    Sort Products By    ${SORT_NAME_ASC}
    Verify Products Sorted By Name

INV-004 Products Can Be Sorted By Name Z To A
    [Documentation]    Verify alphabetical descending product sorting.
    [Tags]    inventory    sorting
    Sort Products By    ${SORT_NAME_DESC}
    Verify Products Sorted By Name    descending=${True}

INV-005 Products Can Be Sorted By Price Low To High
    [Documentation]    Verify ascending numeric price sorting.
    [Tags]    inventory    sorting
    Sort Products By    ${SORT_PRICE_ASC}
    Verify Products Sorted By Price

INV-006 Products Can Be Sorted By Price High To Low
    [Documentation]    Verify descending numeric price sorting.
    [Tags]    inventory    sorting
    Sort Products By    ${SORT_PRICE_DESC}
    Verify Products Sorted By Price    descending=${True}

INV-007 User Can View Product Details
    [Documentation]    Verify that product details match the inventory listing.
    [Tags]    inventory    details
    ${product_name}=    Set Variable    ${TEST_PRODUCT}
    ${product_price}=    Get Product Price By Name    ${product_name}
    Open Product Details    ${product_name}
    Verify Product Details    ${product_name}    ${product_price}


*** Keywords ***
Open Inventory Page
    [Documentation]    Opens SauceDemo and logs in before each inventory test.
    Open SauceDemo Browser
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Successful Login
