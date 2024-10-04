import encrypt as enc
import decrypt as dec
import sys

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

dictionary = dictionary_init()

# message = enc.message_to_binary()
# enc.encrypt_message(dictionary, message)

decrypted_message = dec.decrypt_message(dictionary)
if decrypted_message is None:
    sys.exit()
dec.write_message(decrypted_message)

