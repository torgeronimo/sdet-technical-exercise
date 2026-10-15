
*** Settings ***
Documentation    Reusable keywords for SauceDemo cart and checkout functionality.
Library    SeleniumLibrary
Library    String


*** Variables ***
${CART_LINK}                 css:[data-test="shopping-cart-link"]
${CART_BADGE}                css:[data-test="shopping-cart-badge"]
${CART_ITEMS}                css:.cart_item
${CART_PRODUCT_NAMES}        css:.cart_item .inventory_item_name
${CART_PRODUCT_PRICES}       css:.cart_item .inventory_item_price

${CHECKOUT_BUTTON}           css:[data-test="checkout"]
${FIRST_NAME_FIELD}          id:first-name
${LAST_NAME_FIELD}           id:last-name
${POSTAL_CODE_FIELD}         id:postal-code
${CONTINUE_BUTTON}           id:continue
${CHECKOUT_ERROR}            css:[data-test="error"]

${OVERVIEW_ITEMS}            css:.cart_item
${FINISH_BUTTON}             id:finish
${COMPLETE_HEADER}           css:[data-test="complete-header"]


*** Keywords ***
Add Product To Cart
    [Documentation]    Adds a specified product to the shopping cart.
    [Arguments]    ${product_slug}
    ${locator}=    Set Variable    id:add-to-cart-${product_slug}
    Wait Until Element Is Visible    ${locator}
    Click Button    ${locator}

Remove Product From Cart
    [Documentation]    Removes a specified product from the current page.
    [Arguments]    ${product_slug}
    ${locator}=    Set Variable    id:remove-${product_slug}
    Wait Until Element Is Visible    ${locator}
    Click Button    ${locator}

Verify Cart Badge Count
    [Documentation]    Verifies the number displayed on the shopping cart badge.
    [Arguments]    ${expected_count}
    Wait Until Element Is Visible    ${CART_BADGE}
    Element Text Should Be    ${CART_BADGE}    ${expected_count}

Verify Cart Badge Is Absent
    [Documentation]    Verifies that no cart badge is displayed.
    Wait Until Element Is Not Visible    ${CART_BADGE}

Open Shopping Cart
    [Documentation]    Navigates to the shopping cart page.
    Wait Until Element Is Visible    ${CART_LINK}
    Click Element    ${CART_LINK}
    Wait Until Location Contains    cart.html
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}


Verify Product In Cart
    [Documentation]    Verifies that the expected product exists in the displayed cart items.
    [Arguments]    ${product_name}

    Wait Until Element Is Visible    ${CART_ITEMS}

    @{elements}=    Get WebElements    ${CART_PRODUCT_NAMES}
    @{actual_names}=    Create List

    FOR    ${element}    IN    @{elements}
        ${name}=    Get Text    ${element}
        Append To List    ${actual_names}    ${name}
    END

    List Should Contain Value    ${actual_names}    ${product_name}


Verify Cart Is Empty
    [Documentation]    Verifies that no cart items remain.
    Wait Until Element Is Not Visible    ${CART_ITEMS}
    ${count}=    Get Element Count    ${CART_ITEMS}
    Should Be Equal As Integers    ${count}    0

Proceed To Checkout
    [Documentation]    Opens the checkout information page from the cart.
    Wait Until Location Contains    cart.html
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}
    Click Button    ${CHECKOUT_BUTTON}
    Wait Until Location Contains    checkout-step-one.html
    Wait Until Element Is Visible    ${FIRST_NAME_FIELD}

Enter Checkout Information
    [Documentation]    Enters customer information in the checkout form.
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Input Text    ${FIRST_NAME_FIELD}    ${first_name}
    Input Text    ${LAST_NAME_FIELD}    ${last_name}
    Input Text    ${POSTAL_CODE_FIELD}    ${postal_code}

Continue Checkout
    [Documentation]    Submits the checkout information form.
    Wait Until Element Is Enabled    ${CONTINUE_BUTTON}
    Click Button    ${CONTINUE_BUTTON}

Verify Checkout Error
    [Documentation]    Verifies the expected checkout validation error.
    [Arguments]    ${expected_error}
    Wait Until Element Is Visible    ${CHECKOUT_ERROR}
    Element Text Should Be    ${CHECKOUT_ERROR}    ${expected_error}
    Location Should Contain    checkout-step-one.html


Verify Checkout Overview
    [Documentation]    Verifies the checkout overview and its expected product.
    [Arguments]    ${expected_product}

    Wait Until Location Contains    checkout-step-two.html
    Wait Until Element Is Visible    ${FINISH_BUTTON}
    Page Should Contain Element    ${OVERVIEW_ITEMS}
    Verify Product In Cart    ${expected_product}


Finish Checkout
    [Documentation]    Completes checkout from the overview page.
    Wait Until Location Contains    checkout-step-two.html
    Wait Until Element Is Visible    ${FINISH_BUTTON}
    Click Button    ${FINISH_BUTTON}

Verify Order Completed
    [Documentation]    Verifies successful order completion.
    Wait Until Location Contains    checkout-complete.html
    Wait Until Element Is Visible    ${COMPLETE_HEADER}
    Element Text Should Be    ${COMPLETE_HEADER}    Thank you for your order!


