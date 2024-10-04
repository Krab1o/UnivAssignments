import os
import argparse

# Русский алфавит
upper_alphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
lower_alphabet = upper_alphabet.lower()
alphabet_len = len(upper_alphabet)

# Функция шифрования
def vigenere_encrypt(plain_text, key):
    encrypted_text = []
    key = key.upper()
    # plain_text = plain_text.upper()
    
    key_length = len(key)
    key_index = 0
    
    for char in plain_text:
        if char in upper_alphabet:  # Работа с заглавными буквами
            # Находим индексы букв в алфавите
            plain_index = upper_alphabet.index(char)
            key_index_mod = upper_alphabet.index(key[key_index % key_length])
            # Производим сдвиг с учетом ключа (используем цикличность)
            new_index = (plain_index + key_index_mod) % alphabet_len
            encrypted_text.append(upper_alphabet[new_index])

        elif char in lower_alphabet:  # Работа с строчными буквами
            plain_index = lower_alphabet.index(char)
            key_index_mod = upper_alphabet.index(key[key_index % key_length])
            new_index = (plain_index + key_index_mod) % alphabet_len
            encrypted_text.append(lower_alphabet[new_index])
            
        else:
            # Если символ не в алфавите, просто добавляем его без изменений
            encrypted_text.append(char)

        # Сдвиг ключа
        key_index += 1
    
    return ''.join(encrypted_text)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()    
    parser.add_argument('--key', help='Ключ для шифрования с помощью метода Вижинера')
    args = parser.parse_args()
    key = args.key

    data_path = os.path.join(os.getcwd(), 'data.txt')
    with open(data_path, 'r') as data:
        plain_text = data.read()

    encrypted_text = vigenere_encrypt(plain_text, key)

    container_path = os.path.join(os.getcwd(), 'container.txt')
    with open(container_path, 'w') as container:
        container.write(encrypted_text)