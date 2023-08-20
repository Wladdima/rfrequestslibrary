*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
${Base_URL} =    https://dummyapi.io/data/v1
${app-id} =    64cc05b3e19eb856065f5806
${firstName} =    Max
${lastName} =    Mustermann
${email} =    maxmuster1max@mail.com



*** Keywords ***
Get List Of Users
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response} =    GET    url=${Base_URL}/user    headers=${headers}    expected_status=any
    Should Be Equal As Strings    200    ${response.status_code}
    [return]    ${response}
    
Get User By ID
    [Arguments]    ${user_id}
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response} =    GET    url=${Base_URL}/user/${user_id}    headers=${headers}    expected_status=any
    [return]    ${response}

Create New User
    [Arguments]    ${new_user_first_name}    ${new_user_last_name}    ${new_user_email}
    ${randNumbers}    Generate Random String    length=3    chars=[NUMBERS]
    ${new_email}    Split String    ${new_user_email}    separator=@  
    ${headers}    Create Dictionary    app-id=${app-id}
    ${data}    Create Dictionary    firstName=${new_user_first_name}    lastName=${new_user_last_name}    email=${new_email[0]}${randNumbers}@${new_email[1]}
    ${response}    POST    url=${Base_URL}/user/create    headers=${headers}    data=${data}    expected_status=any
    [return]    ${response}

Check User Name
    [Arguments]    ${username_from_response}    ${should_user_name}
    Should Be Equal As Strings    ${username_from_response}    ${should_user_name}

Delete User By ID
    [Arguments]    ${user_id}
    ${headers}    Create Dictionary    app-id=${app-id}
    ${response}    DELETE    url=${Base_URL}/user/${user_id}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    200    ${response.status_code}
    Should Be Equal As Strings    ${response.json()['id']}    ${user_id}

*** Test Cases ***
Test Create New User
    ${new_user_response}    Create New User    new_user_first_name=${firstName}    new_user_last_name=${lastName}    new_user_email=${email}
    Should Be Equal As Strings    ${new_user_response.status_code}    200
    ${response}    Get User By ID    user_id=${new_user_response.json()['id']}
    Should Be Equal As Strings    ${response.status_code}    200

Test Delete User
    ${new_user_response}    Create New User    new_user_first_name=${firstName}    new_user_last_name=${lastName}    new_user_email=${email}
    Delete User By ID    user_id=${new_user_response.json()['id']}


Test Get User By Invalid ID
    ${user}    Get User By Id    user_id=hhhh
    Should Be Equal As Strings    ${user.status_code}    400
    Should Be Equal As Strings    ${user.json()['error']}    PARAMS_NOT_VALID


#    TRY
#        ${user}    Get User By ID    user_id=hhhh
#    EXCEPT   HTTPError: 400 Client Error: Bad Request for url:
#        Log To Console    UPS FEHLER!
#       Should Be Equal As Strings    ${user.status_code}    400    
#    END
    



    

