*** Settings ***
Resource   keywords.robot
Library    utils/utils.py

*** Variables ***
${URL}         https://robotsparebinindustries.com/
${USERNAME}    maria
${PASSWORD}    thoushallnotpass
${EXCEL_URL}   https://robotsparebinindustries.com/SalesData.xlsx
${EXCEL_FILE}  output/SalesData.xlsx


*** Tasks ***
Producer Workflow
    [Documentation]     Workflow do módulo producer.robot
    Abrir Navegador Chrome    ${URL}
    Login    ${USERNAME}    ${PASSWORD} 
    Download Excel File    ${EXCEL_URL}    ${EXCEL_FILE}
    ${data}=    Process Excel File    ${EXCEL_FILE}
    Process Sales Data    ${data}
    Close Browser



# Quebrar em tasks
# Trablhar validações de duplicidade de registros (python)
# Testar
