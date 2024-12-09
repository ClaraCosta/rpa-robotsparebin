*** Settings ***
Library    RPA.Browser.Selenium
Library    RPA.Excel.Files
Library    RPA.HTTP
Library    RPA.PDF

*** Keywords ***
Abrir Navegador Chrome
    [Arguments]    ${url}
    Open Available Browser    ${url}    browser_selection=Chrome

Login
    [Arguments]    ${username}    ${password}
    Input Text    id:username    ${username}
    Input Text    id:password    ${password}
    Click Element    xpath=//button[contains(text(), 'Log in')]

Download Excel File
    [Arguments]    ${url}    ${output_path}
    RPA.HTTP.Download    ${url}    overwrite=True    target_file=${output_path}

Process Excel File
    [Arguments]    ${file_path}
    Open Workbook    ${file_path}
    ${data}=    Read Worksheet As Table    header=True
    Close Workbook
    [Return]    ${data}

*** Keywords ***
Fill Form
    [Arguments]    ${row}
    Wait Until Element Is Visible    id:firstname    timeout=5
    Input Text    id:firstname    ${row["First Name"]}
    Wait Until Element Is Visible    id:lastname    timeout=5
    Input Text    id:lastname    ${row["Last Name"]}
    Wait Until Element Is Visible    id:salestarget    timeout=5
    Select From List By Value    id:salestarget    ${row["Sales Target"]}
    Wait Until Element Is Visible    id:salesresult    timeout=5
    Input Text    id:salesresult    ${row["Sales"]}
    Wait Until Element Is Visible    xpath=//button[text()='Submit']    timeout=5
    Click Button    xpath=//button[text()='Submit']


Capture Screenshot
    [Arguments]    ${file_path}
    Capture Page Screenshot    ${file_path}

Generate PDF Report
    [Arguments]    ${file_path}
    ${html}=    Get Element Attribute    css:#sales-results    outerHTML
    HTML To PDF    ${html}    ${file_path}

Close Browser
    Close All Browsers
