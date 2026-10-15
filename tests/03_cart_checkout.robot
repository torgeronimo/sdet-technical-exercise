
*** Settings ***
Documentation    Automated cart and checkout tests for SauceDemo.
Resource    ../resources/common.resource
Resource    ../resources/login.resource
Resource    ../resources/inventory.resource
Resource    ../resources/checkout.resource

Test Setup       Open Cart Checkout Session
Test Teardown    Close SauceDemo Browser


*** Variables ***
${VALID_USERNAME}           standard_user
${VALID_PASSWORD}           secret_sauce

${PRODUCT_NAME}             Sauce Labs Backpack
${PRODUCT_SLUG}             sauce-labs-backpack

${CUSTOMER_FIRST_NAME}      Victor Geronimo
${CUSTOMER_LAST_NAME}       Dela Cruz
${CUSTOMER_POSTAL_CODE}     4027

${FIRST_NAME_ERROR}         Error: First Name is required
${POSTAL_CODE_ERROR}        Error: Postal Code is required


*** Test Cases ***
CART-001 Add Item Updates Cart Badge
    [Documentation]    Verify that adding an item updates the cart badge to one.
    [Tags]    cart    positive    smoke
    Add Product To Cart    ${PRODUCT_SLUG}
    Verify Cart Badge Count    1

CART-002 Removing Item Clears Cart Badge
    [Documentation]    Verify that removing the only item clears the cart badge.
    [Tags]    cart    positive
    Add Product To Cart    ${PRODUCT_SLUG}
    Verify Cart Badge Count    1
    Remove Product From Cart    ${PRODUCT_SLUG}
    Verify Cart Badge Is Absent

CART-003 Added Item Appears In Cart
    [Documentation]    Verify the selected product and its price appear in the cart.
    [Tags]    cart    validation
    ${inventory_price}=    Get Product Price By Name    ${PRODUCT_NAME}
    Add Product To Cart    ${PRODUCT_SLUG}
    Open Shopping Cart
    Verify Product In Cart    ${PRODUCT_NAME}
    Verify Cart Product Price    ${PRODUCT_NAME}    ${inventory_price}

CART-004 Removing Item From Cart Empties Cart
    [Documentation]    Verify that removing an item from the cart empties it.
    [Tags]    cart    positive
    Add Product To Cart    ${PRODUCT_SLUG}
    Open Shopping Cart
    Verify Product In Cart    ${PRODUCT_NAME}
    Remove Product From Cart    ${PRODUCT_SLUG}
    Verify Cart Is Empty
    Verify Cart Badge Is Absent

CHECKOUT-001 Checkout Requires First Name
    [Documentation]    Verify that checkout rejects an empty first name.
    [Tags]    checkout    negative    validation
    Add Product To Cart    ${PRODUCT_SLUG}
    Open Shopping Cart
    Proceed To Checkout
    Enter Checkout Information    ${EMPTY}    ${CUSTOMER_LAST_NAME}    ${CUSTOMER_POSTAL_CODE}
    Continue Checkout
    Verify Checkout Error    ${FIRST_NAME_ERROR}

CHECKOUT-002 Checkout Requires Postal Code
    [Documentation]    Verify that checkout rejects an empty postal code.
    [Tags]    checkout    negative    validation
    Add Product To Cart    ${PRODUCT_SLUG}
    Open Shopping Cart
    Proceed To Checkout
    Enter Checkout Information    ${CUSTOMER_FIRST_NAME}    ${CUSTOMER_LAST_NAME}    ${EMPTY}
    Continue Checkout
    Verify Checkout Error    ${POSTAL_CODE_ERROR}

CHECKOUT-003 Customer Can Complete Checkout
    [Documentation]    Verify that a customer can successfully complete an order.
    [Tags]    checkout    positive    e2e
    Add Product To Cart    ${PRODUCT_SLUG}
    Verify Cart Badge Count    1
    Open Shopping Cart
    Verify Product In Cart    ${PRODUCT_NAME}
    Proceed To Checkout
    Enter Checkout Information    ${CUSTOMER_FIRST_NAME}    ${CUSTOMER_LAST_NAME}    ${CUSTOMER_POSTAL_CODE}
    Continue Checkout
    Verify Checkout Overview    ${PRODUCT_NAME}
    Finish Checkout
    Verify Order Completed


*** Keywords ***
Open Cart Checkout Session
    [Documentation]    Opens SauceDemo and logs in before each test.
    Open SauceDemo Browser
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Successful Login



Verify Cart Product Price
    [Documentation]    Verifies the price of a specified product in the cart.
    [Arguments]    ${product_name}    ${expected_price}
    ${locator}=    Set Variable    xpath://div[contains(concat(" ", normalize-space(@class), " "), " cart_item ") and .//div[contains(concat(" ", normalize-space(@class), " "), " inventory_item_name ") and normalize-space(.)="${product_name}"]]//div[contains(concat(" ", normalize-space(@class), " "), " inventory_item_price ")]
    Wait Until Element Is Visible    ${locator}
    ${price_text}=    Get Text    ${locator}
    Should Match Regexp    ${price_text}    ^\\$\\d+\\.\\d{2}$
    ${price_text}=    Remove String    ${price_text}    $
    ${actual_price}=    Convert To Number    ${price_text}
    Should Be Equal As Numbers    ${actual_price}    ${expected_price}

