from RPA.Excel.Files import Files
from RPA.PDF import PDF

def read_excel_data(filepath):
    excel = Files()
    excel.open_workbook(filepath)
    data = excel.read_worksheet_as_table("data", header=True)
    excel.close_workbook()
    return data

def export_to_pdf(html_content, output_path):
    pdf = PDF()
    pdf.html_to_pdf(html_content, output_path)
