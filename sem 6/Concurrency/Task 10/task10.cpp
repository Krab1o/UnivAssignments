#include "mpi.h"
#include <iostream>

using namespace std;

//  pi
#define PI 3.1415926535897932384626433832795

double f(double x) {
    return 1 / (x * x + 4 * x + 5);
}

void simp(const double a, const double b, double h, double* res)
{
    long long int i, n;
    double sum1, sum2, sum11, sum22; //     
    double x; //   
    n = (int)((b - a) / h); //    

    sum1 = 0.0;
    sum2 = 0.0;

    h = (b - a) / (2 * n);

    int NProc, ProcId;
    MPI_Comm_size(MPI_COMM_WORLD, &NProc);
    MPI_Comm_rank(MPI_COMM_WORLD, &ProcId);

    long long n1 = n / NProc;

    long long n2 = (ProcId + 1) * n1;
    if (NProc == ProcId + 1) {
        n2 = n;
    }
    long long st = ProcId * n1;
    if (ProcId == 0) st++;

    for (i = st; i <= n2; i++)
    {
        sum1 += f(a + (2 * i - 1) * h);
    }

    MPI_Reduce(&sum1, &sum11, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    for (i = st; i < n2; i++)
    {
        sum2 += f(a + 2 * i * h);
    }

    MPI_Reduce(&sum2, &sum22, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    *res = h / 3 * (f(a) + f(b) + 4 * sum11 + 2 * sum22);

}

void integral(const double a, const double b,
    const double h, double* res)
{
    long long i, n;
    double sum; //     
    double x; //   
    n = (int)((b - a) / h); //    
    int NProc, ProcId;
    MPI_Comm_size(MPI_COMM_WORLD, &NProc);
    MPI_Comm_rank(MPI_COMM_WORLD, &ProcId);
    long long n1 = n / NProc;
    sum = 0.0;
    long long n2 = (ProcId + 1) * n1;
    if (NProc == ProcId + 1) {
        n2 = n;
    }
    for (i = ProcId * n1; i < n2; i++)
    {
        x = a + i * h + h / 2.0;
        sum += f(x) * h;
    }
    MPI_Reduce(&sum, res, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
}


double experiment(double* res)
{
    double stime, ftime; //      
    long double a = -1.0; //    
    long double b = 1000000.0; //   

    double h = 0.1; //  
    stime = clock();
    simp(a, b, h, res); //   
    ftime = clock();
    return (ftime - stime) / CLOCKS_PER_SEC;
}

int main()
{
    MPI_Init(NULL, NULL);
    int i; //  
    double time; //   
    double res;  //    
    double min_time; //   
    double max_time; //   
    double avg_time; //   
    int numbExp = 10; //   
    //  
    min_time = max_time = avg_time = experiment(&res);
    //  
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
        //   
        cout << "execution time : " << avg_time / numbExp << "; " <<
            min_time << "; " << max_time << endl;
        cout.precision(8);
        cout << "integral value : " << res << endl;
    }
    MPI_Finalize();
    return 0;
}
