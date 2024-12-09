from RPA.Excel.Files import Files
from RPA.PDF import PDF
from pymongo import MongoClient
import dotenv, os
from typing import List, Dict, Tuple
dotenv.load_dotenv()

DB_NAME = os.getenv('DB_NAME')
COLLECTION_NAME = os.getenv('COLLECTION_NAME')
COLLECTION_NAME_INFO_EVENTS = os.getenv('COLLECTION_NAME_INFO_EVENTS')
MONGO_URI = os.getenv('MONGO_URI')


def recover_pending() ->Tuple[bool, list]:
    try:
        control_bool = False
        client = MongoClient(MONGO_URI)
        db = client[DB_NAME]

        result_filter = list(db[COLLECTION_NAME].find({}))

        if len(result_filter) > 0:
            result_filter = result_filter[0]
            control_bool = True

    except Exception as e:
        return (False, e)
    
    return (control_bool, result_filter)


def save_records(list_extract: List[Dict]) ->Tuple[bool, str]:
    try:
        client = MongoClient()
        db = client[DB_NAME]

        for iterator in list_extract:
            result_filter = list(db[COLLECTION_NAME_INFO_EVENTS].find({'event_title':iterator['event_title']}))

            if len(result_filter) == 0:
                db[COLLECTION_NAME_INFO_EVENTS].insert_one(iterator)

    except Exception as e:
        return (False, e)
    
    return (True, 'Salvo com sucesso')

def read_excel_data(filepath):
    excel = Files()
    excel.open_workbook(filepath)
    data = excel.read_worksheet_as_table("data", header=True)
    excel.close_workbook()
    return data

def export_to_pdf(html_content, output_path):
    pdf = PDF()
    pdf.html_to_pdf(html_content, output_path)
