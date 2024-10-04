# Русский алфавит
alphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
alphabet_len = len(alphabet)

# Функция шифрования
def vigenere_encrypt(plain_text, key):
    encrypted_text = []
    key = key.upper()
    plain_text = plain_text.upper()
    
    key_length = len(key)
    key_index = 0
    
    for char in plain_text:
        if char in alphabet:
            # Находим индексы букв в алфавите
            plain_index = alphabet.index(char)
            key_index_mod = alphabet.index(key[key_index % key_length])
            # Производим сдвиг с учетом ключа (используем цикличность)
            new_index = (plain_index + key_index_mod) % alphabet_len
            encrypted_text.append(alphabet[new_index])
            
            # Сдвиг ключа
            key_index += 1
        else:
            # Если символ не в алфавите, просто добавляем его без изменений
            encrypted_text.append(char)
    
    return ''.join(encrypted_text)

# Функция расшифрования
def vigenere_decrypt(cipher_text, key):
    decrypted_text = []
    key = key.upper()
    cipher_text = cipher_text.upper()
    
    key_length = len(key)
    key_index = 0
    
    for char in cipher_text:
        if char in alphabet:
            # Находим индексы букв в алфавите
            cipher_index = alphabet.index(char)
            key_index_mod = alphabet.index(key[key_index % key_length])
            # Производим сдвиг в обратную сторону
            new_index = (cipher_index - key_index_mod) % alphabet_len
            decrypted_text.append(alphabet[new_index])
            
            # Сдвиг ключа
            key_index += 1
        else:
            # Если символ не в алфавите, просто добавляем его без изменений
            decrypted_text.append(char)
    
    return ''.join(decrypted_text)

# Пример использования
print('Введите шифруемое сообщение: ', end='')
plain_text = str(input())
print('Введите используемый для шифрования ключ: ', end='')
key = str(input())

encrypted = vigenere_encrypt(plain_text, key)
print(f"Зашифрованное сообщение: {encrypted}")

decrypted = vigenere_decrypt(encrypted, key)
print(f"Расшифрованное сообщение: {decrypted}")
