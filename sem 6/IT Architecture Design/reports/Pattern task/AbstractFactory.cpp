#include <iostream>

using namespace std;

enum Language 
{
    English,
    Russian
};

class CinemaFactory;
class Cinema;

//Класс аудиодорожка
class AudioTrack
{
protected:
    string language;
public:
    AudioTrack()
    {
        cout << "[SYSTEM] AudioTrack created!" << endl;
    }
};

//Класс субтитров
class Subtitles
{
protected:
    string language;
public:
    Subtitles()
    {
        cout << "[SYSTEM] Subtitles created!" << endl;
    }
};

//Наследующий класс английской аудиодорожки
class EnglishAudioTrack : public AudioTrack
{
public:
    EnglishAudioTrack()
    {
        this->language = "English";
        cout << "[SYSTEM] English AudioTrack created!" << endl;
    }
};

//Наследующий класс английских субтитров
class EnglishSubtitles : public Subtitles
{
public:
    EnglishSubtitles()
    {
        this->language = "English";
        cout << "[SYSTEM] English Subtitles created!" << endl;
    }
};

//Наследующий класс русской аудиодорожки
class RussianAudioTrack : public AudioTrack
{
public:
    RussianAudioTrack()
    {
        this->language = "Russian";
        cout << "[SYSTEM] Russian AudioTrack created!" << endl;
    }
};

//Наследующий класс русских субтитров
class RussianSubtitles : public Subtitles
{
public:
    RussianSubtitles()
    {
        this->language = "Russian";
        cout << "[SYSTEM] Russian Subtitles created!" << endl;
    }
};

//Класс кино
class Cinema
{
public:
    Cinema(string title, string language, Subtitles subtitles, AudioTrack audioTrack)
    {
        this->title = title;
        this->language = language;
        this->subtitles = subtitles;
        this->audioTrack = audioTrack;
    }
    void printInfo()
    {
        cout << endl << "=FILM INFO=" << endl << title << endl << language << endl << endl;
    }
private:
    string title;
    string language;
    Subtitles subtitles;
    AudioTrack audioTrack;
};

//Интерфейс (абстрактная фабрика)
class CinemaFactory
{
public:
    virtual Cinema createCinema(string title) = 0;
    virtual ~CinemaFactory() {}
protected:
    virtual Subtitles createSubtitles() = 0;
    virtual AudioTrack createAudioTrack() = 0;
};

//Наследующий класс английской абстрактной фабрики
class EnglishCinemaFactory : public CinemaFactory
{
public:
    EnglishCinemaFactory()
    {
        cout << "[SYSTEM] English CinemaFactory created!" << endl;
    }
    Cinema createCinema(string title) override
    {
        return Cinema(
            title,
            "English",
            createSubtitles(),
            createAudioTrack()
        );
    }
private:
    Subtitles createSubtitles() override
    {
        return EnglishSubtitles();
    }
    AudioTrack createAudioTrack() override
    {
        return EnglishAudioTrack();
    }
};

//Наследующий класс русской абстрактной фабрики
class RussianCinemaFactory : public CinemaFactory
{
public:
    RussianCinemaFactory()
    {
        cout << "[SYSTEM] Russian CinemaFactory created!" << endl;
    }
    Cinema createCinema(string title) override
    {
        return Cinema(
            title,
            "Russian",
            createSubtitles(),
            createAudioTrack()
        );
    }
    Subtitles createSubtitles() override
    {
        return RussianSubtitles();
    }
    AudioTrack createAudioTrack() override
    {
        return RussianAudioTrack();
    }
};

//Класс клиента
class Client
{
private:
    CinemaFactory* factory;
public:
    Client(int languageID)
    {
        factory = nullptr;
        changeLanguage(languageID);
    }

    Cinema orderFilm(string title)
    {
        return factory->createCinema(title);
    }
    void changeLanguage(int languageID)
    {
        if (factory != nullptr)
            delete factory;
        if (languageID == English)
            factory = new EnglishCinemaFactory();
        else if (languageID == Russian)
            factory = new RussianCinemaFactory();
        else
            cout << "[SYSTEM] This language is not supported!" << endl;
    }
};

//Примеры использования
int main()
{
    Client cl = Client(English);
    cl.orderFilm("Title1").printInfo();
    cl.changeLanguage(Russian);
    cl.orderFilm("Title1").printInfo();
    cl.orderFilm("Title2").printInfo();
}