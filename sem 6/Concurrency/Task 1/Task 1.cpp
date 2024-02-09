#include <iostream>
#include <omp.h>
#include <vector>

#define PI 3.1415926535897932384626433832795
#define INF 1'000'000

using namespace std;

double f(double x)
{
    return 1 / (x * x + 4 * x + 5);
}

void integral(const double a, const double b,
    const double h, double* res)
{
    int i, n;
    double sum;
    double x;
    n = (int)((b - a) / h); 
    sum = 0.0;
#pragma omp parallel for private(x) reduction(+: sum)
    for (i = 0; i < n; i++)
    {
        x = a + i * h + h / 2.0;
        sum += f(x) * h;
    }
    *res = sum;
}

double experiment(double* res)
{
    double stime, ftime; // время начала и конца расчета
    double a = -1.0; // левая граница интегрирования
    double b = INF; // правая граница интегрирования
    double h = 0.001; // шаг интегрирования
    stime = clock();
    integral(a, b, h, res); // вызов функции интегрирования
    ftime = clock();
    return (ftime - stime) / CLOCKS_PER_SEC;
}

int main()
{
    int i; // переменная цикла
    double time; // время проведенного эксперимента
    double res; // значение вычисленного интеграла
    double min_time;
    double max_time;
    double avg_time;
    int numbExp = 10;

    min_time = max_time = avg_time = experiment(&res);
    // оставшиеся запуски
    for (i = 0; i < numbExp - 1; i++)
    {
        time = experiment(&res);
        avg_time += time;
        if (max_time < time) max_time = time;
        if (min_time > time) min_time = time;
    }
    // вывод результатов эксперимента
    cout << "execution time : " << avg_time / numbExp << "; " <<
        min_time << "; " << max_time << endl;
    cout << "integral value : " << res << endl;
    return 0;
}