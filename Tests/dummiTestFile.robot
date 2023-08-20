*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
${Base_URL} =    https://dummyapi.io/data/v1
${app-id} =    64cc05b3e19eb856065f5806
${firstName} =    Max
${lastName} =    Mustermann


*** Keywords ***
Create New User
    [Arguments]    ${new_user_first_name}    ${new_user_last_name}    ${new_user_email}
    ${randNumbers}    Generate Random String    length=3    chars=[NUMBERS]
    ${new_email}    Split String    ${new_user_email}    separator=@  
    ${headers}    Create Dictionary    app-id=${app-id}
    ${data}    Create Dictionary    firstName=${new_user_first_name}    lastName=${new_user_last_name}    email=${new_email[0]}${randNumbers}@${new_email[1]}
    ${response}    POST    url=${Base_URL}/user/create    headers=${headers}    data=${data}    expected_status=any
    [return]    ${response}

Delete User By 
    [Arguments]    ${user_id}
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response}    DELETE    url=${Base_URL}/user/${user_id}    headers=${headers}    expected_result=any
    Should Be Equal As Strings    200    ${response.status_code}
    Should Be Equal As Strings    ${response.json()['id']}    ${user_id}

*** Test Cases ***
Test New User Can Be Created
    ${response} =    Create New User    new_user_first_name=${firstName}    new_user_last_name=${lastName}    new_user_email=NewTestEmail@mail.com
    Should Be Equal As Strings    ${response.status_code}    200
