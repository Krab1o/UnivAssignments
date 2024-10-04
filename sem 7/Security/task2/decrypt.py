import os
import re

def dictionary_init():
    """
    Подготовка алфавитов
    """
    # 2 алфавита
    ru_letters = 'аеорсухАВЕКОРСТХ'.encode('cp1251')
    en_letters = 'aeopcyxABEKOPCTX'.encode('cp1251')

    code_rule = {}

    # Составление правил перевода 
    for i in range(len(ru_letters)):
        code_rule[ru_letters[i]] = en_letters[i]
        code_rule[en_letters[i]] = ru_letters[i]
    
    return code_rule

def binary_to_message(binary):
    """
    Записывает раскодированное сообщение из 
    бинарного вида в файл с кодировкой cp1251
    """
    decoded_path = os.path.join(os.getcwd(), 'decoded.txt')
    with open(decoded_path, 'wb') as decoded:
        decoded.write(binary)
        
def decrypt_message(dictionary):
    """
    Расшифровывает полученное сообщение в бинарный вид
    """
    container_path = os.path.join(os.getcwd(), 'container.txt')
    with open(container_path, 'rb') as container:
        message_to_decrypt = ''
        container_text = container.read()
        
        bit_count = 0
        current_symbol = ''
        
        message_to_decrypt = bytearray()
        for char in container_text:
            if char in dictionary:
                # Проверка бита на 0/1
                if char > 128:
                    current_symbol += '0'
                else:
                    current_symbol += '1'
                bit_count += 1

                # Если собрался очередной байт
                if bit_count % 8 == 0:
                    if current_symbol == '00000000':
                        return message_to_decrypt
                    message_to_decrypt += int(current_symbol, base=2).to_bytes(1)
                    current_symbol = ''

if __name__ == "__main__":
    dictionary = dictionary_init()
    binary = decrypt_message(dictionary)
    binary_to_message(binary)

