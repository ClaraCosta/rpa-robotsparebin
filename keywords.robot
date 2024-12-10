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
    Sleep    1
    Click Element    xpath=//button[contains(text(), 'Log in')]

Download Excel File
    [Arguments]    ${url}    ${output_path}
    RPA.HTTP.Download    ${url}    overwrite=True    target_file=${output_path}
    Sleep    1


Process Excel File
    [Arguments]    ${file_path}
    Open Workbook    ${file_path}
    ${data}=    Read Worksheet As Table    header=True
    Close Workbook
    [Return]    ${data}


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

Recuperar Registros Pendentes
    [Documentation]     Consulta o MongoDB para obter os registros pendentes.
    ${status}=    utils.recover_pending
    ${has_data}=    Set Variable    ${status}[0]
    ${data}=       Set Variable    ${status}[1]
    Run Keyword If    not ${has_data}    Fail    "Nenhum registro pendente encontrado!"
    Log    Registros pendentes encontrados: ${data}


Preencher Formularios
    [Documentation]     Preenche formulários com os dados recuperados do MongoDB.
    FOR    ${row}    IN    @{data}
        Try
            Fill Form    ${row}
            Atualizar Status no MongoDB    ${row}    ${STATUS_SUCCESS}
        Except Exception as ${err}
            Log    Falha ao processar ${row}: ${err}
            Atualizar Status no MongoDB    ${row}    ${STATUS_ERROR}
    END


Atualizar Status no MongoDB
    [Arguments]    ${row}    ${status}
    Run Keyword    utils.insert_task_status    ${row}    ${status}


Insert Data with Validation
    [Arguments]    ${row}    ${status}
    ${message}=    Evaluate    utils.insert_task_status_with_validation(${row}, "${status}")
    Log    ${message}



Insert Data in MongoDB
    [Arguments]    ${row}    ${status}
    Run Keyword    utils.insert_task_status    ${row}    ${status}



Capture Screenshot
    [Arguments]    ${file_path}
    Capture Page Screenshot    ${file_path}

Generate PDF Report
    [Arguments]    ${file_path}
    ${html}=    Get Element Attribute    css:#sales-results    outerHTML
    HTML To PDF    ${html}    ${file_path}

Fechar Navegador
    [Documentation]     Fecha o navegador após o término do workflow.
    Close Browser