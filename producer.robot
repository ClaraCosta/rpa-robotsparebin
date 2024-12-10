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
Abrir Navegador
    [Documentation]     Abre o navegador e acessa a URL inicial.
    Abrir Navegador Chrome    ${URL}

Realizar Login
    [Documentation]     Realiza login no site com as credenciais fornecidas.
    Login    ${USERNAME}    ${PASSWORD}

Baixar Arquivo Excel
    [Documentation]     Faz o download do arquivo Excel a partir do site.
    Download Excel File    ${EXCEL_URL}    ${EXCEL_FILE}

Processar Arquivo Excel
    [Documentation]     Lê e processa os dados do arquivo Excel baixado.
    ${data}=    Process Excel File    ${EXCEL_FILE}

Processar Dados de Vendas
    [Documentation]     Processa os dados do Excel e realiza as operações necessárias.
    ${data}=    Process Excel File    ${EXCEL_FILE}
    FOR    ${row}    IN    @{data}
        Insert Data with Validation    ${row}    pending
    END

Fechar Navegador
    [Documentation]     Fecha o navegador aberto durante o workflow.
    Close Browser



# Testar duplicidade - apagar registros do banco
# Adicioonar set next task