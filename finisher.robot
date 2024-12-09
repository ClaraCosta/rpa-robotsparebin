*** Settings ***
Resource   keywords.robot

*** Variables ***
${SCREENSHOT_FILE}    output/sales_summary.png
${PDF_FILE}           output/sales_results.pdf

# Recuperar registros (sucesso e erro - python)
# Gerar relatórios (python)
# Atualizar registros (relatorio criado - python)


*** Keywords ***
Finisher Workflow
    Capture Screenshot    ${SCREENSHOT_FILE}
    Generate PDF Report    ${PDF_FILE}
    Close Browser
