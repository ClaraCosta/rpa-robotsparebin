*** Settings ***
Resource   keywords.robot
Resource   resources/main.resource
Library    utils/utils.py

# *** Tasks ***
# Obter registros pendentes (também pode ser em python)
# Abrir navegador 
# realizar login e acessar tela de formualrio
# preencher formulario 
# baixar arquivos (só é executada enquano não existirem registros pendentes)
# realizar update do banco de dados (python) - Chamar novamente "Obter Registros Pendentes"

*** Variables ***
${URL}         https://robotsparebinindustries.com/
${USERNAME}    maria
${PASSWORD}    thoushallnotpass
${EXCEL_FILE}  output/SalesData.xlsx

*** Keywords ***
    [Arguments]    ${task_id}    ${status}
    Call Method    mongo_integration.insert_task_status    ${task_id}    ${status}

*** Tasks ***
Obter Registros pendentes
    [Documentation]   Testa recuperação de registros pendentes do banco de dados
    ${status}=    utils.recover_pending
    Log    Status na recuperação: ${status}
    Set Next Task    Abrir Navegador
Abrir Navegador
    Abrir Navegador Chrome    ${URL} 
    Login    ${USERNAME}    ${PASSWORD}

Preencher Formulario Com Registros Pendentes
    ${status}    utils.recover_pending
    ${has_data}=    Set Variable    ${status}[0]
    ${data}=    Set Variable    ${status}[1]



# Consumer Workflow
#     ${data}=    Process Excel File    ${EXCEL_FILE}
#     FOR    ${row}    IN    @{data}
#         Fill Form    ${row}
#     END
