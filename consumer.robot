*** Settings ***
Resource   keywords.robot
Library    utils/utils.py

*** Variables ***
${URL}         https://robotsparebinindustries.com/
${USERNAME}    maria
${PASSWORD}    thoushallnotpass
${EXCEL_FILE}    output/SalesData.xlsx
${STATUS_SUCCESS}    success
${STATUS_ERROR}    error

*** Tasks ***
Abrir Navegador
    [Documentation]     Abre o navegador e acessa a URL inicial.
    Abrir Navegador Chrome    ${URL}

Realizar Login
    [Documentation]     Realiza login no site com as credenciais fornecidas.
    Login    ${USERNAME}    ${PASSWORD}

Recuperar Registros Pendentes
    [Documentation]     Testa recuperação de registros pendentes do banco de dados.
    ${status}=    utils.recover_pending
    ${has_data}=    Set Variable    ${status}[0]  # Definir 
    ${data}=       Set Variable    ${status}[1]
    Run Keyword If    not ${has_data}    Fail    "Nenhum registro pendente encontrado!"
    Log    Registros pendentes encontrados: ${data}

Preencher Formularios
    [Documentation]     Preenche formulários com os dados recuperados do MongoDB.
    FOR    ${row}    IN    @{data}
        Run Keyword And Ignore Error    Fill Form    ${row}
        ${status}=    Run Keyword If    '${row}' != None    Set Variable    ${STATUS_SUCCESS}    ELSE    Set Variable    ${STATUS_ERROR}
        Atualizar Status no MongoDB    ${row}    ${status}
    END

Fechar Navegador
    [Documentation]     Fecha o navegador após o término do workflow.
    Close Browser

*** Keywords ***
Atualizar Status no MongoDB
    [Arguments]    ${row}    ${status}
    Call Method    utils.insert_task_status    ${row}    ${status}