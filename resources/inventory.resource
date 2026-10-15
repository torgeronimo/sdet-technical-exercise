
*** Settings ***
Documentation    Reusable keywords for SauceDemo inventory functionality.
Library    SeleniumLibrary
Library    Collections
Library    String


*** Variables ***
${INVENTORY_ITEMS}          css:.inventory_item
${PRODUCT_NAMES}            css:.inventory_item_name
${PRODUCT_DESCRIPTIONS}     css:.inventory_item_desc
${PRODUCT_PRICES}           css:.inventory_item_price
${SORT_DROPDOWN}            css:[data-test="product-sort-container"]

${PRODUCT_DETAIL_NAME}      css:[data-test="inventory-item-name"]
${PRODUCT_DETAIL_PRICE}     css:[data-test="inventory-item-price"]


*** Keywords ***
Get Product Names
    [Documentation]    Returns all product names in their displayed order.
    @{names}=    Create List
    @{elements}=    Get WebElements    ${PRODUCT_NAMES}
    FOR    ${element}    IN    @{elements}
        ${name}=    Get Text    ${element}
        Append To List    ${names}    ${name}
    END
    RETURN    ${names}

Get Product Prices
    [Documentation]    Returns all product prices as numbers.
    @{prices}=    Create List
    @{elements}=    Get WebElements    ${PRODUCT_PRICES}
    FOR    ${element}    IN    @{elements}
        ${price_text}=    Get Text    ${element}
        ${price_text}=    Remove String    ${price_text}    $
        ${price}=    Convert To Number    ${price_text}
        Append To List    ${prices}    ${price}
    END
    RETURN    ${prices}

Verify Inventory Products Are Displayed
    [Documentation]    Verifies that the inventory contains visible products.
    Wait Until Element Is Visible    ${INVENTORY_ITEMS}
    ${count}=    Get Element Count    ${INVENTORY_ITEMS}
    Should Be True    ${count} > 0



Verify Product Information
    [Documentation]    Verifies every product card has a name, description, and valid price.
    ${count}=    Get Element Count    ${INVENTORY_ITEMS}
    Should Be True    ${count} > 0

    FOR    ${index}    IN RANGE    1    ${count + 1}
        ${name_locator}=    Set Variable    css:.inventory_item:nth-child(${index}) .inventory_item_name
        ${description_locator}=    Set Variable    css:.inventory_item:nth-child(${index}) .inventory_item_desc
        ${price_locator}=    Set Variable    css:.inventory_item:nth-child(${index}) .inventory_item_price

        ${name}=    Get Text    ${name_locator}
        ${description}=    Get Text    ${description_locator}
        ${price_text}=    Get Text    ${price_locator}

        Should Not Be Empty    ${name}
        Should Not Be Empty    ${description}
        Should Match Regexp    ${price_text}    ^\\$\\d+\\.\\d{2}$

        ${numeric_price}=    Remove String    ${price_text}    $
        ${numeric_price}=    Convert To Number    ${numeric_price}
        Should Be True    ${numeric_price} >= 0
    END



Sort Products By
    [Documentation]    Selects a sorting option by its visible label.
    [Arguments]    ${sort_option}
    Select From List By Label    ${SORT_DROPDOWN}    ${sort_option}

Verify Products Sorted By Name
    [Documentation]    Verifies product names are sorted in the expected direction.
    [Arguments]    ${descending}=${False}
    ${actual}=    Get Product Names
    ${expected}=    Copy List    ${actual}
    Sort List    ${expected}
    IF    ${descending}
        Reverse List    ${expected}
    END
    Lists Should Be Equal    ${actual}    ${expected}

Verify Products Sorted By Price
    [Documentation]    Verifies prices are sorted numerically.
    [Arguments]    ${descending}=${False}
    ${actual}=    Get Product Prices
    ${expected}=    Copy List    ${actual}
    Sort List    ${expected}
    IF    ${descending}
        Reverse List    ${expected}
    END
    Lists Should Be Equal    ${actual}    ${expected}

Open Product Details
    [Documentation]    Opens the details page for a specified product.
    [Arguments]    ${product_name}
    Click Element    xpath://div[contains(@class,"inventory_item_name") and normalize-space(.)="${product_name}"]

Verify Product Details
    [Documentation]    Verifies product name and price on the details page.
    [Arguments]    ${expected_name}    ${expected_price}
    Wait Until Element Is Visible    ${PRODUCT_DETAIL_NAME}
    Element Text Should Be    ${PRODUCT_DETAIL_NAME}    ${expected_name}
    ${price_text}=    Get Text    ${PRODUCT_DETAIL_PRICE}
    ${price_text}=    Remove String    ${price_text}    $
    ${actual_price}=    Convert To Number    ${price_text}
    Should Be Equal As Numbers    ${actual_price}    ${expected_price}


Get Product Price By Name
    [Documentation]    Returns the price of a specified inventory product.
    [Arguments]    ${product_name}
    ${locator}=    Set Variable    xpath://div[contains(@class,"inventory_item") and .//div[contains(@class,"inventory_item_name") and normalize-space(.)="${product_name}"]]//div[contains(@class,"inventory_item_price")]
    ${price_text}=    Get Text    ${locator}
    ${price_text}=    Remove String    ${price_text}    $
    ${price}=    Convert To Number    ${price_text}
    RETURN    ${price}
