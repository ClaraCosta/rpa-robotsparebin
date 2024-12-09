*** Settings ***
Resource   keywords.robot
Library    utils/utils.py

# Fazer primeiro antes de construir o consumer

*** Variables ***
${URL}         https://robotsparebinindustries.com/
${USERNAME}    maria
${PASSWORD}    thoushallnotpass
${EXCEL_URL}   https://robotsparebinindustries.com/SalesData.xlsx
${EXCEL_FILE}  output/SalesData.xlsx

*** Keywords ***
Producer Workflow 
    Abrir Navegador Chrome    ${URL}
    Login    ${USERNAME}    ${PASSWORD}
    Download Excel File    ${EXCEL_URL}    ${EXCEL_FILE}

*** Tasks ***
Abrir Navegador
    # Producer Workflow
    ${RESULTADO_CONSULTA}    Recover Pending

#mongodb: collection_robot_sparebin
#pymongo para trabalhar com mongodb

# Downlaod Excel
# Realizar leitura do excell (Python)
# Insert no banco - retorno da leitura
