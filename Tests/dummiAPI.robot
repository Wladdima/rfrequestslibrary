*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BaseURL} =    https://dummyapi.io/data/v1/
${app-id} =    64cc05b3e19eb856065f5806
${userID} =    60d0fe4f5311236168a109ca



*** Keywords ***



*** Test Cases ***
Get List Of Users
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response} =    GET    url=${BaseURL}/user    headers=${headers}
    Log To Console    ${response.status_code}
    Should Be Equal As Strings    200    ${response.status_code}

Get User By ID
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response} =    GET    url=${BaseURL}/user/${userID}    headers=${headers}
    Should Be Equal As Strings    200    ${response.status_code}
    Should Be Equal As Strings    Sara    ${response.json()['firstName']}

