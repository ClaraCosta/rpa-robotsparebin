import os

# Estrutura de pastas e arquivos
structure = [
    "core/settings.py",
    "resources/locators.resource",
    "resources/main.resource",
    "utils/utils.py",
    "variables/settings.py",
    ".gitignore",
    "keywords.robot",
    "producer.robot",
    "Pipfile",
    "Pipfile.lock",
    "README.md",
]

def create_project_structure(structure):
    for file in structure:
        # Cria as pastas e os arquivos
        file_path = os.path.join(os.getcwd(), file)  # Usa o diretório atual
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        with open(file_path, "w") as f:
            # Opcional: Adicione conteúdo inicial aos arquivos
            if file.endswith("README.md"):
                f.write("# Event Finder Bot\n\nEstrutura inicial do projeto.")
            elif file.endswith(".gitignore"):
                f.write("# Arquivos a ignorar pelo Git\n")
            else:
                f.write("")

# Criar a estrutura
create_project_structure(structure)
print("Estrutura de pastas e arquivos criada com sucesso!")
