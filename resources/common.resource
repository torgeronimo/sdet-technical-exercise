*** Settings ***
Library    SeleniumLibrary
Variables    ../variables/config.py


*** Keywords ***
Open SauceDemo Browser
    [Documentation]    Opens SauceDemo in the configured browser.
    # Updated to disable the password leak detection popup
    Open Browser    ${BASE_URL}    ${BROWSER}    options=add_experimental_option("prefs", {"profile.password_manager_leak_detection": False})
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Close SauceDemo Browser
    [Documentation]    Closes all browsers opened by Selenium.
    Close All Browsers
