import os

def message_to_binary():
    """
    Перевод текста для шифрования из cp1251 кодировки в бинарный вид
    """
    data_path = os.path.join(os.getcwd(), 'task2/data.txt')
    file_stats = os.stat(data_path)
    final_message = ''
    with open(data_path, 'rb') as data:
        message_to_encrypt = ('_' + str(file_stats.st_size * 8) + '_').encode('cp1251') + data.read()
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
    container_sample_path = os.path.join(os.getcwd(), 'task2/container_sample.txt')
    container_path = os.path.join(os.getcwd(), 'task2/container.txt')
    container_text = None

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

# message = message_init()
# encrypt_message(message)


"""
print(message_to_encrypt)
        # for byte in message_to_encrypt:
        #     print(byte, chr(byte), sep=' = ', end=' = ')
        #     for _ in range(8):
        #         if byte & 0x80:
        #             print("1", end='', sep='')
        #             # pass
        #         else: 
        #             print("0", end='', sep='')
        #             # pass
        #         byte = byte << 1 
        #     print()


    # print(''.join(format(ord(x), 'b') for x in message_to_encrypt))
    # for chunk in iter(partial(data.read, 1), b''):
    #     byte = int.from_bytes(chunk)
    #     print(chunk)
    #     print(ord(chunk))
    #     for bitNumber in range(8):
    #         if byte & 0x80: 
    #             print("1", end='', sep='')
    #             pass
    #         else: 
    #             print("0", end='', sep='')
    #             pass
    #         byte = byte << 1
    #     print()
"""

