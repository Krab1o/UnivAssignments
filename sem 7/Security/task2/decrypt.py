import os
import re

def write_message(message):
    """
    Записывает раскодированное сообщение из 
    бинарного вида в файл с кодировкой cp1251
    """
    decoded_path = os.path.join(os.getcwd(), 'task2/decoded.txt')
    with open(decoded_path, 'wb') as decoded:
        decoded.write(message)
        
def decrypt_message(dictionary):
    """
    Расшифровывает полученное сообщение в бинарный вид
    """
    container_path = os.path.join(os.getcwd(), 'task2/container.txt')
    with open(container_path, 'rb') as container:
        message_to_decrypt = ''
        container_text = container.read()
        
        bit_count = 0
        bits_to_parse = 0
        metadata_flag = True
        current_symbol = ''
        
        message_to_decrypt = bytearray()
        for index, char in enumerate(container_text):
            if char in dictionary:
                # Проверка бита на 0/1
                if char > 128:
                    current_symbol += '0'
                else:
                    current_symbol += '1'
                bit_count += 1

                # Если собрался очередной байт
                if bit_count % 8 == 0:
                    message_to_decrypt += int(current_symbol, base=2).to_bytes(1)
                    current_symbol = ''
                # Проверяем, что получена метаинформация о количестве бит
                    if metadata_flag and re.compile(b'_[0-9]+_').match(message_to_decrypt):
                        bits_to_parse = int(message_to_decrypt[1:-1])
                        bit_count = 0
                        message_to_decrypt = b''
                        metadata_flag = False
                
                # Проверяем, что собрали все нужные биты
                if not metadata_flag and bit_count == bits_to_parse:
                    return message_to_decrypt
