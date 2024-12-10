from RPA.Excel.Files import Files
from RPA.PDF import PDF
from pymongo import MongoClient
import dotenv, os
from typing import List, Dict, Tuple
from datetime import datetime
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


def is_duplicate(record: Dict) -> bool:
    try:
        client = MongoClient(MONGO_URI)
        db = client[DB_NAME]
        collection = db[COLLECTION_NAME]

        # Define os critérios de duplicidade (ajuste os campos conforme necessário)
        filter_query = {
            "first_name": record["First Name"],
            "last_name": record["Last Name"],
            "sales": record["Sales"],
            "sales_target": record["Sales Target"]
        }

        existing_record = collection.find_one(filter_query)
        return existing_record is not None

    except Exception as e:
        print(f"Erro ao verificar duplicidade: {e}")
        return False

def insert_task_status_with_validation(row, status):
    """
    Insere o status de um registro no MongoDB, validando duplicidade.
    """
    try:
        client = MongoClient(MONGO_URI)
        db = client[DB_NAME]
        collection = db[COLLECTION_NAME]

        # Verifica se o registro já existe no banco de dados
        existing_record = collection.find_one({
            "first_name": row["First Name"],
            "last_name": row["Last Name"],
            "sales": row["Sales"],
            "sales_target": row["Sales Target"]
        })

        if existing_record:
            return f"Registro duplicado: {row['First Name']} {row['Last Name']} não foi inserido."

        # Insere o registro se não for duplicado
        document = {
            "first_name": row["First Name"],
            "last_name": row["Last Name"],
            "sales": row["Sales"],
            "sales_target": row["Sales Target"],
            "status": status,
            "timestamp": datetime.now()
        }
        collection.insert_one(document)
        return f"Registro inserido com sucesso: {row['First Name']} {row['Last Name']}."
    except Exception as e:
        return f"Erro ao inserir registro: {str(e)}"
    

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


def insert_task_status(row, status):
    try:
        client = MongoClient(MONGO_URI)
        db = client[DB_NAME]
        collection = db[COLLECTION_NAME]  

        document = {
            "first_name": row["First Name"],
            "last_name": row["Last Name"],
            "sales": row["Sales"],
            "sales_target": row["Sales Target"],
            "status": status,
            "timestamp": datetime.now()
        }
        collection.insert_one(document)
        print(f"Registro inserido com sucesso: {document}")
    except Exception as e:
        print(f"Erro ao inserir registro no MongoDB: {str(e)}")
