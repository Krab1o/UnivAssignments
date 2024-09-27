# # slide 2

# class MyClass:
#     pass  # Заглушка, указывающая на отсутствие содержимого

# obj = MyClass()  # Создание экземпляра класса MyClass

# class MyClass2:
#     def __init__(self, text): # Конструктор класса
#         print(text) # Вывод текста, переданного в конструктор

# obj2 = MyClass2("Hello world") 

# # slide 3

# class Dog:
#     # Атрибут класса (общий для всех объектов)
#     species = "Canis lupus"
    
#     def __init__(self, name, age):
#         # Атрибуты экземпляра (уникальны для каждого объекта)
#         self.name = name
#         self.age = age

# # Создание экземпляров класса Dog
# dog1 = Dog("Buddy", 3)
# dog2 = Dog("Lucy", 5)

# print(dog1.name)  # Вывод: Buddy
# print(dog2.age)   # Вывод: 5
# print(dog1.species)  # Вывод: Canis lupus (атрибут класса)

# # slide 4

# class Example:
#     class_var = 10  # Поле класса

#     def __init__(self, value):
#         self.instance_var = value  # Поле объекта

# # Создание экземпляра
# ex = Example(5)

# # Доступ к полю класса
# print(Example.class_var)  # Вывод: 10

# # Доступ к полю объекта
# print(ex.instance_var)  # Вывод: 5

# # Изменение поля класса через экземпляр
# ex.class_var = 20  # Создаёт новое поле объекта
# print(ex.class_var)  # Вывод: 20 (теперь это поле объекта)
# print(Example.class_var)  # Вывод: 10 (поле класса не изменилось)

# # Изменение поля класса через класс
# Example.class_var = 30
# print(Example.class_var)  # Вывод: 30 (поле класса изменилось)
# print(ex.class_var)  # Вывод: 20 (поле объекта осталось прежним)

# # slide 5

# class Circle:
#     pi = 3.14159

#     def __init__(self, radius):
#         self.radius = radius

#     # Метод экземпляра
#     def area(self):
#         return Circle.pi * (self.radius ** 2)

#     # Метод класса
#     @classmethod
#     def from_diameter(cls, diameter):
#         radius = diameter / 2
#         return cls(radius)

#     # Статический метод
#     @staticmethod
#     def is_valid_radius(radius):
#         return radius > 0

# # Использование методов
# circle1 = Circle(10)
# print(circle1.area())  # Вывод: 314.159

# circle2 = Circle.from_diameter(20)  # Создание объекта из диаметра
# print(circle2.radius)  # Вывод: 10

# circle3 = circle2.from_diameter(36)
# print(circle3.radius)

# print(Circle.is_valid_radius(5))  # Вывод: True (статический метод)

# # slide 6

# class Person:
#     def __init__(self, name, age):
#         self.name = name  # Публичный атрибут
#         self._age = age   # Защищённый атрибут
#         self.__password = "1234"  # Приватный атрибут

#     def get_password(self):
#         return self.__password  # Доступ к приватному атрибуту через метод

# person = Person("John", 30)
# print(person.name)       # Вывод: John (публичный атрибут)
# print(person._age)       # Вывод: 30 (можно, но не рекомендуется)
# # print(person.__password)  # Ошибка: нет такого атрибута
# print(person.get_password())  # Вывод: 1234

# # slide 7

# class Animal:
#     def __init__(self, name):
#         self.name = name

#     def speak(self):
#         pass

# class Dog(Animal):
#     def speak(self):
#         return f"{self.name} говорит: Гав!"

# class Cat(Animal):
#     def speak(self):
#         return f"{self.name} говорит: Мяу!"

# # Создание объектов
# dog = Dog("Бобик")
# cat = Cat("Мурзик")

# print(dog.speak())  # Вывод: Бобик говорит: Гав!
# print(cat.speak())  # Вывод: Мурзик говорит: Мяу!

# # # slide 8

# class Animal:
#     def speak(self):
#         print("Животное издаёт звук")

# class Dog(Animal):
#     def speak(self):
#         # Вызов метода speak() 
#         # из родительского класса Animal
#         super().speak()  
#         print("Собака лает")

# dog = Dog()
# dog.speak()

# # slide 9

# class Animal:
#     def __init__(self, name):
#         self.name = name
#         print(f"Животное {self.name} создано")

# class Dog(Animal):
#     def __init__(self, name, breed):
#         # Вызов конструктора 
#         # родительского класса
#         super().__init__(name)  
#         self.breed = breed
#         print(f"Собака породы {self.breed} создана")

# dog = Dog("Бобик", "Дворняга")


# # slide 10

# class Bird:
#     def fly(self):
#         print("Птица летает")

# class Airplane:
#     def fly(self):
#         print("Самолет летает")

# def take_off(flying_object):
#     flying_object.fly() # Передаём привет утиной
#                         # типизации :)

# bird = Bird()
# airplane = Airplane()

# take_off(bird)      # Вывод: Птица летает
# take_off(airplane)  # Вывод: Самолет летает

# # slide 11

# from abc import ABC, abstractmethod

# class Vehicle(ABC):
#     @abstractmethod
#     def start_engine(self):
#         pass

# class Car(Vehicle):
#     def start_engine(self):
#         print("Двигатель машины заведен")

# class Motocycle(Vehicle):
#     pass

# car = Car()
# car.start_engine()  # Вывод: Двигатель машины заведен
# moto = Motocycle()  # Ошибка времени выполнения: 
#                     # не реализован абстрактный метод

# # slide 12

# class A:
#     pass

# class B(A):
#     pass

# class C(A):
#     pass

# class D(B, C):
#     pass

# print(D.__mro__)  
# # (<class '__main__.D'>, <class '__main__.B'>, 
# # <class '__main__.C'>, <class '__main__.A'>, <class 'object'>)
# print(D.mro())    
# # [<class '__main__.D'>, <class '__main__.B'>, 
# # <class '__main__.C'>, <class '__main__.A'>, <class 'object'>]

# # slide 13

# class Animal:
#     pass

# class Dog(Animal):
#     pass

# dog = Dog()

# print(isinstance(dog, Dog))      # True
# print(isinstance(dog, Animal))   # True
# print(issubclass(Dog, Animal))   # True
# print(issubclass(Animal, Dog))   # False

# # slide 14

# def multiply(a, b):
#     """
#     Умножает два числа.

#     Args:
#         a (int, float): Первое число.
#         b (int, float): Второе число.

#     Returns:
#         int, float: Произведение чисел.
#     """
#     return a * b

# print(multiply.__doc__)
