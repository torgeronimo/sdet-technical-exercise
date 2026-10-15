
*** Settings ***
Documentation    Basic smoke tests for SauceDemo.
Resource    ../resources/common.resource

Test Setup    Open SauceDemo Browser
Test Teardown    Close SauceDemo Browser


*** Test Cases ***
SMOKE-001 SauceDemo Website Loads Successfully
    [Documentation]    Verify that SauceDemo loads with the expected title.
    Title Should Be    Swag Labs
    Page Should Contain Element    id:login-button
