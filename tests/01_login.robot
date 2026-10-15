
*** Settings ***
Documentation    Automated login tests for SauceDemo.
Resource    ../resources/common.resource
Resource    ../resources/login.resource

Test Setup       Open SauceDemo Browser
Test Teardown    Close SauceDemo Browser


*** Variables ***
${VALID_USERNAME}        standard_user
${VALID_PASSWORD}        secret_sauce
${LOCKED_USERNAME}       locked_out_user

${INVALID_LOGIN_ERROR}   Epic sadface: Username and password do not match any user in this service
${USERNAME_REQUIRED}     Epic sadface: Username is required
${PASSWORD_REQUIRED}     Epic sadface: Password is required
${LOCKED_USER_ERROR}     Epic sadface: Sorry, this user has been locked out.


*** Test Cases ***
LOGIN-001 User Can Login With Valid Credentials
    [Documentation]    Verify that valid credentials allow access to inventory.
    [Tags]    positive    login    smoke
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Successful Login

LOGIN-002 User Cannot Login With Invalid Password
    [Documentation]    Verify that an incorrect password is rejected.
    [Tags]    negative    login
    Login With Credentials    ${VALID_USERNAME}    wrong_password
    Verify Login Error    ${INVALID_LOGIN_ERROR}

LOGIN-003 User Cannot Login With Invalid Username
    [Documentation]    Verify that an incorrect username is rejected.
    [Tags]    negative    login
    Login With Credentials    invalid_user    ${VALID_PASSWORD}
    Verify Login Error    ${INVALID_LOGIN_ERROR}

LOGIN-004 Login Requires Username
    [Documentation]    Verify that username is a required field.
    [Tags]    negative    validation
    Enter Password    ${VALID_PASSWORD}
    Submit Login Form
    Verify Login Error    ${USERNAME_REQUIRED}

LOGIN-005 Login Requires Password
    [Documentation]    Verify that password is a required field.
    [Tags]    negative    validation
    Enter Username    ${VALID_USERNAME}
    Submit Login Form
    Verify Login Error    ${PASSWORD_REQUIRED}

LOGIN-006 Locked Out User Cannot Login
    [Documentation]    Verify that locked-out accounts cannot access inventory.
    [Tags]    negative    security
    Login With Credentials    ${LOCKED_USERNAME}    ${VALID_PASSWORD}
    Verify Login Error    ${LOCKED_USER_ERROR}

LOGIN-007 User Can Logout Successfully
    [Documentation]    Verify that users can end their session.
    [Tags]    positive    logout
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Successful Login
    Logout From SauceDemo
    Verify Logout Successful