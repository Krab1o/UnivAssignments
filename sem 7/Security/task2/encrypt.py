import os

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

def message_to_binary(data_path):
    """
    Перевод текста для шифрования из cp1251 кодировки в бинарный вид
    """
    final_message = ''
    with open(data_path, 'rb') as data:
        message_to_encrypt = data.read()
        for byte in message_to_encrypt:
            for _ in range(8):
                final_message += str(int(bool(byte & 0x80)))
                byte = byte << 1
    return final_message
    
def encrypt_message(dictionary, message_to_encrypt):
    """
    Шифрование бинарного текста в контейнере
    """
    # Установка окружения файлов
    container_sample_path = os.path.join(os.getcwd(), 'container_sample.txt')
    container_path = os.path.join(os.getcwd(), 'container.txt')

    with (
        open(container_sample_path, 'rb') as sample,
        open(container_path, 'wb') as container
    ):
        # Чтение образца
        container_text = bytearray(sample.read())

        # Изменение образца в соответствии с кодированием
        position_message = 0
        for index, char in enumerate(container_text):
            if char in dictionary:
                if message_to_encrypt[position_message] == '1':
                    container_text[index] = dictionary[char]
                position_message += 1
                if position_message == len(message_to_encrypt):
                    break
        container.write(container_text)

if __name__ == "__main__":
    dictionary = dictionary_init()
    data_path = os.path.join(os.getcwd(), 'data.txt')
    binary = message_to_binary(data_path)
    encrypt_message(dictionary, binary)