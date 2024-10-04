import os
import argparse

# Русский алфавит
upper_alphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
lower_alphabet = upper_alphabet.lower()
alphabet_len = len(upper_alphabet)

# Функция расшифрования
def vigenere_decrypt(cipher_text, key):
    decrypted_text = []
    key = key.upper()
    # cipher_text = cipher_text.upper()
    
    key_length = len(key)
    key_index = 0
    
    for char in cipher_text:
        if char in upper_alphabet:  # Работа с заглавными буквами
            cipher_index = upper_alphabet.index(char)
            key_index_mod = upper_alphabet.index(key[key_index % key_length])
            new_index = (cipher_index - key_index_mod) % alphabet_len
            decrypted_text.append(upper_alphabet[new_index])

        elif char in lower_alphabet:  # Работа с строчными буквами
            cipher_index = lower_alphabet.index(char)
            key_index_mod = upper_alphabet.index(key[key_index % key_length])
            new_index = (cipher_index - key_index_mod) % alphabet_len
            decrypted_text.append(lower_alphabet[new_index])
            
        else:
            # Если символ не в алфавите, просто добавляем его без изменений
            decrypted_text.append(char)

        key_index += 1

    return ''.join(decrypted_text)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()    
    parser.add_argument('--key', help='Ключ для шифрования с помощью метода Вижинера')
    args = parser.parse_args()
    key = args.key

    container_path = os.path.join(os.getcwd(), 'container.txt')
    with open(container_path, 'r') as container:
        encrypted_text = container.read()

    decrypted_text = vigenere_decrypt(encrypted_text, key)

    data_path = os.path.join(os.getcwd(), 'decoded.txt')
    with open(data_path, 'w') as decoded:
        decoded.write(decrypted_text)