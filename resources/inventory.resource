
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
${PRODUCT_DETAIL_DESCRIPTION}    css:[data-test="inventory-item-desc"]
${PRODUCT_DETAIL_IMAGE}          css:.inventory_details_img
${BACK_TO_PRODUCTS_BUTTON}       id:back-to-products
${DETAIL_ADD_BUTTON}             css:[data-test^="add-to-cart"]
${DETAIL_REMOVE_BUTTON}          css:[data-test^="remove"]
${DETAIL_CART_BADGE}             css:[data-test="shopping-cart-badge"]



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
    Wait Until Location Contains    inventory-item.html
    Wait Until Element Is Visible    ${PRODUCT_DETAIL_NAME}



    
Get Inventory Product Details
    [Documentation]    Captures a product's name, description, price, and image URL.
    [Arguments]    ${product_name}

    ${product_locator}=    Set Variable    xpath://div[contains(concat(" ", normalize-space(@class), " "), " inventory_item ") and .//div[contains(@class,"inventory_item_name") and normalize-space(.)="${product_name}"]]

    ${name}=    Get Text    ${product_locator}//div[contains(@class,"inventory_item_name")]
    ${description}=    Get Text    ${product_locator}//div[@class="inventory_item_desc"]
    ${price}=    Get Text    ${product_locator}//div[contains(@class,"inventory_item_price")]
    ${image}=    Get Element Attribute    ${product_locator}//img    src

    &{details}=    Create Dictionary
    ...    name=${name}
    ...    description=${description}
    ...    price=${price}
    ...    image=${image}

    RETURN    ${details}

Verify Product Details Match Inventory
    [Documentation]    Compares product details against the inventory listing.
    [Arguments]    ${expected_details}

    Wait Until Location Contains    inventory-item.html
    Wait Until Element Is Visible    ${PRODUCT_DETAIL_NAME}

    ${actual_name}=    Wait Until Keyword Succeeds    5s    500ms    Get Text    ${PRODUCT_DETAIL_NAME}
    ${actual_description}=    Get Text    ${PRODUCT_DETAIL_DESCRIPTION}
    ${actual_price}=    Get Text    ${PRODUCT_DETAIL_PRICE}
    ${actual_image}=    Get Element Attribute    ${PRODUCT_DETAIL_IMAGE}    src

    Should Be Equal    ${actual_name}    ${expected_details}[name]
    Should Be Equal    ${actual_description}    ${expected_details}[description]
    Should Be Equal    ${actual_price}    ${expected_details}[price]
    Should Be Equal    ${actual_image}    ${expected_details}[image]

    Element Should Be Visible    ${PRODUCT_DETAIL_IMAGE}


Return To Inventory
    [Documentation]    Clicks Back to Products from the details page.
    Wait Until Element Is Visible    ${BACK_TO_PRODUCTS_BUTTON}
    Click Button    ${BACK_TO_PRODUCTS_BUTTON}


Verify Returned To Inventory
    [Documentation]    Confirms navigation back to the inventory listing.
    Wait Until Location Contains    inventory.html
    Wait Until Element Is Visible    ${INVENTORY_ITEMS}


Add Product From Details
    [Documentation]    Adds a product from its details page and verifies the result.
    Wait Until Element Is Visible    ${DETAIL_ADD_BUTTON}
    Wait Until Keyword Succeeds    5s    500ms    Click Button    ${DETAIL_ADD_BUTTON}
    Wait Until Element Is Visible    ${DETAIL_REMOVE_BUTTON}
    Element Text Should Be    ${DETAIL_CART_BADGE}    1


Remove Product From Details
    [Documentation]    Removes a product from its details page and verifies the result.
    Wait Until Element Is Visible    ${DETAIL_REMOVE_BUTTON}
    Click Button    ${DETAIL_REMOVE_BUTTON}
    Wait Until Element Is Visible    ${DETAIL_ADD_BUTTON}
    Wait Until Element Is Not Visible    ${DETAIL_CART_BADGE}


Get Product Price By Name
    [Documentation]    Returns the price of a specified inventory product.
    [Arguments]    ${product_name}
    ${locator}=    Set Variable    xpath://div[contains(@class,"inventory_item") and .//div[contains(@class,"inventory_item_name") and normalize-space(.)="${product_name}"]]//div[contains(@class,"inventory_item_price")]
    ${price_text}=    Get Text    ${locator}
    ${price_text}=    Remove String    ${price_text}    $
    ${price}=    Convert To Number    ${price_text}
    RETURN    ${price}

