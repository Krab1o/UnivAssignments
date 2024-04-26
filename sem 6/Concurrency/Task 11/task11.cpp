#include <iostream>
#include <mpi.h>
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
    int i, j, n, m;
    double sum1, sum2; // локальная переменная для подсчета интеграла
    double x, y; // координата точки сетки
    n = (int)((b_x - a_x) / h_x); // количество точек сетки интегрирования
    m = (int)((b_y - a_y) / h_y); // количество точек сетки интегрирования
    sum1 = 0.0;
    sum2 = 0.0;

    int NProc, ProcId;
    MPI_Comm_size(MPI_COMM_WORLD, &NProc);
    MPI_Comm_rank(MPI_COMM_WORLD, &ProcId);

    long long n_x = n / NProc;
    long long n_y = (ProcId + 1) * n_x;
    if (NProc == ProcId + 1) {
        n_y = n;
    }
    long long st = ProcId * n_x;

    for (i = st; i < n_y; i++)
    {
        x = a_x + i * h_x + h_x / 2.0;
        sum2 = 0.0;

        for (j = 0; j < m; j++)
        {
            y = a_y + j * h_y + h_y / 2.0;
            sum2 += f(x, y, a_x, b_x, a_y, b_y) * h_x * h_y;
        }
        sum1 += sum2;
    }
    MPI_Reduce(&sum1, res, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
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
    MPI_Init(NULL, NULL);

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

    int ProcId;
    MPI_Comm_rank(MPI_COMM_WORLD, &ProcId);
    if (ProcId == 0) {
        // вывод результатов эксперимента
        cout << "execution time : " << avg_time / numbExp << "; " <<
            min_time << "; " << max_time << endl;
        cout << "integral value : " << res << endl;
    }
    MPI_Finalize();

    return 0;
}