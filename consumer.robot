*** Settings ***
Resource   keywords.robot

*** Variables ***
${EXCEL_FILE}  output/SalesData.xlsx

*** Keywords ***
Consumer Workflow
    ${data}=    Process Excel File    ${EXCEL_FILE}
    FOR    ${row}    IN    @{data}
        Fill Form    ${row}
    END
