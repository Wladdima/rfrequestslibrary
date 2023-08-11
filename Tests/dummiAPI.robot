*** Settings ***
Library    RequestsLibrary

*** Variables ***
${Base_URL} =    https://dummyapi.io/data/v1
${app-id} =    64cc05b3e19eb856065f5806
${firstName} =    Max
${lastName} =    Mustermann
${email} =    maxmustermax123456@mail.com



*** Keywords ***
Get List Of Users
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response} =    GET    url=${Base_URL}/user    headers=${headers}
    Should Be Equal As Strings    200    ${response.status_code}
    [return]    ${response}
    
Get User By ID
    [Arguments]    ${user_id}
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response} =    GET    url=${Base_URL}/user/${user_id}    headers=${headers}
    Should Be Equal As Strings    200    ${response.status_code}
    [return]    ${response}

Create New User
    [Arguments]    ${new_user_first_name}    ${new_user_last_name}    ${new_user_email}
    ${headers}    Create Dictionary    app-id=${app-id}
    ${data}    Create Dictionary    firstName=${new_user_first_name}    lastName=${new_user_last_name}    email=${new_user_email}
    ${response}    POST    url=${Base_URL}/user/create    headers=${headers}    data=${data}
    Should Be Equal As Strings    200    ${response.status_code}
    [return]    ${response}

Check User Name
    [Arguments]    ${username_from_response}    ${should_user_name}
    Should Be Equal As Strings    ${username_from_response}    ${should_user_name}

Delete User By ID
    [Arguments]    ${user_id}
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response}    DELETE    url=${Base_URL}/user/${user_id}    headers=${headers}
    Should Be Equal As Strings    200    ${response.status_code}
    Should Be Equal As Strings    ${response.json()['id']}    ${user_id}

*** Test Cases ***
Test Create New User
    ${new_user_response}    Create New User    new_user_first_name=${firstName}    new_user_last_name=${lastName}    new_user_email=${email}
    Log To Console    ${new_user_response.json()['id']}
    Get User By ID    user_id=${new_user_response.json()['id']}

Test Delete User
    Delete User By ID    user_id=64d69c47e074d010d3fdafb4


    

