*** Settings ***
Library    SeleniumLibrary
Variables    ../variables/config.py


*** Keywords ***
Open SauceDemo Browser
    [Documentation]    Opens SauceDemo in the configured browser.
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Close SauceDemo Browser
    [Documentation]    Closes all browsers opened by Selenium.
    Close All Browsers
