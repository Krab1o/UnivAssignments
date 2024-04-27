v#include <iostream>
#include <omp.h>
#include <vector>
#include <cmath>

#define PI 3.1415926535897932384626433832795
#define INF 1'000'000

using namespace std;

double f(double x, double y, const double& a_x, const double& b_x, const double& a_y, const double& b_y)
{
    return (exp(sin(PI * x) * cos(PI * y)) + 1) / ((b_x - a_x) * (b_y - a_y));
}

void integral(const double a_x, const double b_x, const double a_y, const double b_y,
    const double h_x, const double h_y, double* res)
{
    long long int i_x, i_y;
    double x, y;
    const long long int n_x = (long long int)((b_x - a_x) / h_x);
    const long long int n_y = (long long int)((b_y - a_y) / h_y);
    double sum = 0.0;

#pragma omp parallel for private(i_x, x) reduction (+: sum)
    for (i_x = 0; i_x < n_x; i_x++)
    {
        x = a_x + i_x * h_x + h_x / 2.0;
#pragma omp parallel for private (i_y, y)
        for (i_y = 0; i_y < n_y; i_y++)
        {
            y = a_y + i_y * h_y + h_y / 2.0;
            sum += f(x, y, a_x, b_x, a_y, b_y) * h_x * h_y;
        }
    }
    *res = sum;
}

double experiment(double* res)
{
    double stime, ftime; // время начала и конца расчета
    double a_x = 0; // левая граница интегрирования по x
    double b_x = 16; // правая граница интегрирования по y
    double a_y = 0; // левая граница интегрирования по x
    double b_y = 16; // правая граница интегрирования по y
    //long long int n = 1'000'000'000;
    double h_x = 0.001; // шаг интегрирования по x
    double h_y = 0.001; // шаг интегрирования по y
    stime = clock();
    integral(a_x, b_x, a_y, b_y, h_x, h_y, res); // вызов функции интегрирования
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