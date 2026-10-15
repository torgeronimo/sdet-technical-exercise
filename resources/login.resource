*** Settings ***
Documentation    Reusable keywords for SauceDemo login functionality.
Library    SeleniumLibrary


*** Variables ***
${USERNAME_FIELD}       id:user-name
${PASSWORD_FIELD}       id:password
${LOGIN_BUTTON}         id:login-button
${LOGIN_ERROR}          css:[data-test="error"]
${INVENTORY_CONTAINER}  id:inventory_container
${MENU_BUTTON}          id:react-burger-menu-btn
${LOGOUT_LINK}          id:logout_sidebar_link


*** Keywords ***


Enter Username
    [Documentation]    Enters a username into the login form.
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${USERNAME_FIELD}
    Input Text    ${USERNAME_FIELD}    ${username}


Enter Password
    [Documentation]    Enters a password into the login form.
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${PASSWORD_FIELD}
    Input Password    ${PASSWORD_FIELD}    ${password}


Submit Login Form
    [Documentation]    Submits the SauceDemo login form.
    Wait Until Element Is Enabled    ${LOGIN_BUTTON}
    Click Button    ${LOGIN_BUTTON}


Login With Credentials
    [Documentation]    Attempts to log in using the provided credentials.
    [Arguments]    ${username}    ${password}
    Enter Username    ${username}
    Enter Password    ${password}
    Submit Login Form

Verify Login Error
    [Documentation]    Verifies that the expected login error is displayed.
    [Arguments]    ${expected_error}
    Wait Until Element Is Visible    ${LOGIN_ERROR}
    Element Text Should Be    ${LOGIN_ERROR}    ${expected_error}

Verify Successful Login
    [Documentation]    Verifies that the product inventory is displayed.
    Wait Until Location Contains    inventory.html
    Wait Until Element Is Visible    ${INVENTORY_CONTAINER}

Logout From SauceDemo
    [Documentation]    Opens the navigation menu and logs out.
    Click Button    ${MENU_BUTTON}
    Wait Until Element Is Visible    ${LOGOUT_LINK}
    Click Element    ${LOGOUT_LINK}

Verify Logout Successful
    [Documentation]    Verifies that logout returns to the login page.
    Wait Until Element Is Visible    ${LOGIN_BUTTON}
    Location Should Be    ${BASE_URL}