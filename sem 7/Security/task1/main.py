import os
import struct

HASH_FILE_NAME = "hashes.txt"

def calculate_hash(file_path):
    """Вычисляет хэш-сумму файла по описанному алгоритму."""
    hash_value = 0
    try:
        with open(file_path, 'rb') as file:
            while chunk := file.read(2):  # Читаем файл по 2 байта (16 бит)
                if len(chunk) < 2:
                    chunk = chunk.ljust(2, b'\0')  # Дополняем нулями, если не хватает
                value = struct.unpack('H', chunk)[0]  # Преобразуем в 16-битное значение
                hash_value ^= value  # Складываем по XOR
    except IOError as e:
        print(f"Ошибка чтения файла {file_path}: {e}")
    return hash_value

def save_hashes(directory):
    """Сохраняет хэш-суммы всех файлов в указанном каталоге."""
    hashes = {}
    for root, _, files in os.walk(directory):
        for file_name in files:
            if file_name == HASH_FILE_NAME:
                continue  # Пропускаем файл с хэш-суммами
            file_path = os.path.join(root, file_name)
            file_hash = calculate_hash(file_path)
            relative_path = os.path.relpath(file_path, directory)
            hashes[relative_path] = file_hash

    # Сохраняем хэш-суммы в файл
    with open(os.path.join(directory, HASH_FILE_NAME), 'w') as hash_file:
        for file_path, file_hash in hashes.items():
            hash_file.write(f"{file_path}:{file_hash}\n")

def check_integrity(directory):
    """Проверяет целостность файлов в указанном каталоге."""
    hash_file_path = os.path.join(directory, HASH_FILE_NAME)
    if not os.path.exists(hash_file_path):
        print("Файл с хэш-суммами не найден.")
        return

    # Загружаем сохраненные хэш-суммы
    saved_hashes = {}
    with open(hash_file_path, 'r') as hash_file:
        for line in hash_file:
            file_path, file_hash = line.strip().split(':')
            saved_hashes[file_path] = int(file_hash)

    # Проверяем текущие хэш-суммы
    for root, _, files in os.walk(directory):
        for file_name in files:
            if file_name == HASH_FILE_NAME:
                continue  # Пропускаем файл с хэш-суммами
            file_path = os.path.join(root, file_name)
            relative_path = os.path.relpath(file_path, directory)
            current_hash = calculate_hash(file_path)

            if relative_path not in saved_hashes:
                print(f"Новый файл обнаружен: {relative_path}")
            elif current_hash != saved_hashes[relative_path]:
                print(f"Файл изменен: {relative_path}")
                print(f"  Старый хэш: {saved_hashes[relative_path]}, Новый хэш: {current_hash}")
    
    # Проверяем удаленные файлы
    for saved_file in saved_hashes:
        if not os.path.exists(os.path.join(directory, saved_file)):
            print(f"Файл удален: {saved_file}")

# Пример использования
# directory = "/path/to/your/directory"
# save_hashes(directory)  # Сохраняем хэш-суммы
# check_integrity(directory)  # Проверяем целостность