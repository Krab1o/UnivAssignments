
from abc import ABCMeta, abstractmethod
import zope.interface
from zope.interface import implementer
import collections.abc


class Automata:
    """
    Определение абстрактного класса автомата
    """
    __metaclass__ = ABCMeta

    def _init__(self):
        self.state_kind = State    # Пременная типа автомата

    @abstractmethod
    def execute_word(self):   # Функция обработки входного слова 'word'
        pass


class State(zope.interface.Interface):
    """ Интерфейсный класс для состояния"""

    @abstractmethod
    def make_trans():        # Функция вычисления перехода для состояния
        pass


class StateCollection(collections.abc.Iterable):
    """
    Класс коллекции состояний типа state_kind с номерами из списка states_num_list
    """
    _states_collection = list()       # Список- коллекция состояний недерминированного автомата

    def __init__(self, states_list):
        self._states_collection = states_list

    def __iter__(self):               # Определения итератора для коллекции состояний
        return StatesIterator(self)

    def trans(self, symbol):
        # Функция обработки перехода для коллекции состояний, в которых находится НКА
        print('Current states collection: ')
        _prom_states = self._states_collection
        print([stt.state_num for stt in _prom_states])
        # Вычисленое нового состояния коллекции, определяемого переходом по входному symbol
        self._states_collection = list()
        for stt in _prom_states:         # ОБъединение переходов по состояниям коллекции
            _stt_trans = stt.make_trans(symbol)
            self.extend_collection(_stt_trans)
        self._states_collection = self.unify_states(self._states_collection)
        print('New States collection ')
        self.print_collection()
        print('_' * 30)
        return self

    def size_collection(self):
        return len(self._states_collection)

    @staticmethod
    def unify_states(collection):
        # Унификация коллекции состояний в коллекцию с состояними с разными именами
        un_num = list()
        lst = list()
        for state in collection:
            if state.state_num not in un_num:
                lst.append(state)
                un_num.append(state.state_num)
        return lst

    def extend_collection(self, collects):
        # Добавление коллекции состояний collects к коллекции states_collection
        self._states_collection.extend(collects.get_states_collection())

    def print_collection(self):
        # Вывод имен состояний коллекции
        print(self.get_collection_nums())

    def get_collection_nums(self):
        return [st.state_num for st in self._states_collection]

    def get_states_collection(self):
        return self._states_collection


class StatesIterator(collections.abc.Iterator):
    """
    Итератор коллекции состояний
    """
    _position = 0

    def __init__(self, concrete_collection):
        self._concrete_collection = concrete_collection

    def __next__(self):
        self.lst = list(self._concrete_collection.get_states_collection())
        if self._position >= len(self.lst):  # if no_elements_to_traverse:
            raise StopIteration
        else:
            item = self.lst[self._position]
            self._position += 1
        return item


class FA(Automata):
    """
    Класс автомата - общего для NFA и e-NFA
    """
    _states_count = 0               # Число состояний автомата
    _ls_states_obj = list()         # Список состояний автомата
    _table = dict()                 # Функция переходов автомата
    current_state = None            # Текущее состояние автомата
    _alphabet = list()              # Входной алфавит автомата. 'e' - epsilon для е-НКА
    _user_data = None

    def __init__(self, data):
        # Определение автомата через ввод из файла
        self._user_data = data
        (self._alphabet, self._states_count, self._table, self.init_state, self.final_states) = \
            self._user_data.get_user_data()
        # Формирование списка состояний автомата
        _states_num_list = list(map(str, range(self._states_count)))
        for num in _states_num_list:  # Добавление нового состояния с номером num
            self._ls_states_obj.append(self.state_kind(num))
        # Установка переходов для объектов-состояний автомата
        for (num, a) in self._table.keys():
            _pr_ls = self._table[(num, a)]
            _trans_lst = [stt for stt in self._ls_states_obj if stt.state_num in _pr_ls]
            st = self._ls_states_obj[int(num)]
            st.transitions[a] = self.set_state(_trans_lst)

    def output_fa(self):
        print(' State"s transition table')
        # Вывод таблицы переходов автомата
        col_width = max(map(len, list(self._table.values())))*2
        line = '    |'
        for a in self._alphabet:
            line += ((' '+str(a)).ljust(col_width) + '|')
        print(line)
        print('----|' + ('-' * col_width+'|') * len(self._alphabet))
        for i in range(self._states_count):
            line = ''
            if str(i) == self.init_state:
                line += '->'
            else:
                line += '  '
            if str(i) in self.final_states:
                line += '*'
            else:
                line += ' '
            line += (str(i)+'|')
            for a in self._alphabet:
                if (str(i), a) in self._table.keys():
                    line += ' '.join((map(str, self._table[(str(i), a)]))).ljust(col_width)+'|'
                else:
                    line += (' '*col_width+'|')
            print(line)

    @staticmethod
    def set_state(st):
        # формирование из списка состояний текущего состояния-коллекции
        return StateCollection(st)

    def get_state_nums(self):
        # Извлечение списка номеров состояний в текущем состоянии-коллекции
        return [num.state_num for num in self.current_state]

    def print_current_state(self):
        # вывод номеров состояний текущего состояния-коллекции автомата
        lst = self.get_state_nums()
        print('Current state of automaton is: ', ' '.join(lst))

    def execute_word(self):
        pass


class NFA(FA):
    """
    Класс конечного (не)детерминированного автомата
    """
    def __init__(self, user_data):
        # Определение автомата
        self.state_kind = StateNFA       # Инициализация типа состояния автомата
        super().__init__(user_data)
        # Установка текущего состояния в коллекцию-состояние в котором есть только начальное состояние
        c_st = list()
        c_st.append(self._ls_states_obj[int(self.init_state)])
        self.current_state = self.set_state(c_st)

    def execute_word(self):
        # Функция обработки автоматом входного слова word
        # Результат: принятие или неприятие слова автоматом
        word = self._user_data.get_user_data_word()
        for a in word:   # Обработка входного слова: переход-замыкание
            self.current_state = self.current_state.trans(a)   # обработка переходов по состояниям автомата
            if self.current_state.size_collection() == 0:      # Прекращение обработки входного слова, если нет перехода
                break
        last_state_nums = self.get_state_nums()                # Номера последнего текущего состояния
        # Есть ли среди номеров последнего состояния номера финальных состояний
        if set(last_state_nums) & set(self.final_states):
            print("the word '", word, "' is accepted")
        else:
            print("the word '", word, "' is not accepted")


class ENFA(FA):
    """
    Класс конечного (не)детерминированного автомата с epsilon-переходами
    """
    def __init__(self, user_data):
        # Определение автомата
        self.state_kind = StateENFA  # Инициализация типа состояния автомата
        super().__init__(user_data)
        # Установка текущего состояния в коллекцию-состояние в котором есть только начальное состояние
        c_st = list()
        c_st.append(self._ls_states_obj[int(self.init_state)])
        self.current_state = self.set_state(c_st)

    def execute_word(self):
        # Функция обработки автоматом входного слова word
        # Результат: принятие или неприятие слова автоматом
        # Для e-NFA перед обработкой слова делается замыкание множества начальных состояний
        word = self._user_data.get_user_data_word()
        print('Processing of the word ', word)
        self.print_current_state()
        c_st = set()
        for stt in self.current_state:
            new_vis = list()
            stt.closer(stt, new_vis)
            c_st = c_st | set(new_vis)
            if len(c_st) != 0:
                self.current_state = self.set_state(c_st)
        # Обработка входного слова: переход-замыкание
        for a in word:
            self.current_state = self.current_state.trans(a)   # обработка переходов по состояниям автомата
            if self.current_state.size_collection() == 0:      # Прекращение обработки входного слова,
                break                                          # если нет перехода
        last_state_nums = self.get_state_nums()                # Номера последнего состояния
        # Есть ли среди номеров последнего состояния номера финальных состояний
        if set(last_state_nums) & set(self.final_states):
            print("the word '", word, "' is accepted")
        else:
            print("the word '", word, "' is not accepted")


@implementer(State)
class StateNFA:
    """
    Класс - состояние конечного недетерминированного автомата '
    """

    def __init__(self, name):
        self.state_num = name
        self.transitions = dict()

    def make_trans(self, a):
        # определение состояний в которые переходит состояние по входному символу  'а'
        state_lst = list()
        # print('Make trans from state ', self.state_num, ' on symbol ', a)
        if a in self.transitions.keys():
            state_lst = self.transitions[a]
            print('Transition to states ', state_lst.get_collection_nums(),
                  ' from state ', self.state_num, ' on input symbol ', a)
        else:
            print('No transition from state ', self.state_num, ' on input symbol ', a)
            state_lst = StateCollection(state_lst)
        return state_lst


@implementer(State)
class StateENFA:
    """
    Состояние конечного недетерминированного автомата с е-переходами '
    """

    def __init__(self, name):
        self.state_num = name
        self.transitions = dict()

    def make_trans(self, a):
        # определение состояний в которые переходит состояние по входному символу  'а'
        new_states = list()
        #  Переход по входному символу
        # print('Make trans from state ', self.state_num, ' on symbol ', a)
        if a in self.transitions.keys():
            state_lst = self.transitions[a]
            prom_num_states = state_lst.get_collection_nums()
            print('Transition to states ', prom_num_states,
                 ' from state ', self.state_num, ' on input symbol ', a)
        #  Замыкание множества состояний
            cl_states = set()
            for stt in state_lst:
                new_vis = list()
                self.closer(stt, new_vis)
                cl_states = cl_states | set(new_vis)
            state_lst = StateCollection(list(cl_states))
            print('Closer of states ', prom_num_states,
                    ' is ', state_lst.get_collection_nums())
        else:
            print('No transition from state ', self.state_num, ' on input symbol ', a)
            state_lst = StateCollection(new_states)
        return state_lst

    def closer(self, stt, vis, visited=None):
        # Замыкание состояния по epsilon
        if visited is None:
            visited = list()
        visited.append(stt)
        if stt.state_num not in vis:
            vis.append(stt)
        e_trans = list()
        if 'e' in stt.transitions.keys():
            e_trans = [st for st in stt.transitions['e'] if st not in visited]
        for nt in e_trans:
            self.closer(nt, vis, visited)
        return visited


class UserData:
    _alphabet = None
    _states_count = None
    _table = None
    _init_state = None
    _final_states = None
    _word = None

    def __init__(self, file_name):
        (self._alphabet, self._states_count, self._table, self._init_state, self._final_states) = \
            self.input_from_file(file_name)

    @staticmethod
    def input_from_file(file_name):
        # функция ввода автомата из файла
        with open(file_name, 'r') as file:
            input_lines = [line.strip() for line in file]
            alphabet = input_lines[0].strip(' ').split(' ')
            states_count = int(input_lines[1].strip(' '))
            init_state = input_lines[2].strip(' ')
            final_states = input_lines[3].strip(' ').split(' ')
            table = dict()
            for i in range(4, len(input_lines)):
                trans_state = input_lines[i].strip(' ').split(' ')
                table[(trans_state[0], trans_state[1])] = trans_state[2:]
            return alphabet, states_count, table, init_state, final_states

    def get_user_data(self):
        return self._alphabet, self._states_count, self._table, self._init_state, self._final_states

    def user_data_input(self):
        print('Type input word ')
        self._word = input()

    def get_user_data_word(self):
        return self._word



    # Симулятор автомата

def main():
    #file_title = 'enfa.txt'
    file_title = 'fa.txt'
    user_data = UserData(file_title)
    fa = NFA(user_data)

    fa.output_fa()
    fa.print_current_state()

    user_data.user_data_input()
    fa.execute_word()

    print('Final states: ', fa.final_states, '\n')


if __name__ == '__main__':
    main()
