*** Settings ***
Resource   keywords.robot

*** Variables ***
${URL}         https://robotsparebinindustries.com/
${USERNAME}    maria
${PASSWORD}    thoushallnotpass
${EXCEL_URL}   https://robotsparebinindustries.com/SalesData.xlsx
${EXCEL_FILE}  output/SalesData.xlsx

*** Keywords ***
Producer Workflow
    Open Browser    ${URL}
    Login    ${USERNAME}    ${PASSWORD}
    Download Excel File    ${EXCEL_URL}    ${EXCEL_FILE}

#mongodb: collection_robot_sparebin
#pymongo para trabalhar com mongodb