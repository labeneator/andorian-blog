/*
 * =====================================================================================
 *
 *       Filename:  recursion.c
 *
 *    Description:  A simple foray into the world of recursion
 *
 *        Version:  1.0
 *        Created:  18/02/11 17:16:20
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Laban Mwangi (lmwangi), lmwangi@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include <stdio.h>

int factorial(int n);
int tail_factorial(int n, int a);


int main()
{
	int result = 0;
	int factor = 5;

	result = factorial(factor);

	printf("Factorial %d\n", result);

	result = tail_factorial(factor, 1);

	printf("Tail Factorial %d\n", result);

	return 0;
}

int factorial(int n)
{
	if (n < 0){
		return 0;
	}
	else if (n == 0){
		return 0;
	}
	else if (n == 1){
		return 1;
	}
	else {
		return n * factorial(n-1);
	}

}

int tail_factorial(int n, int a)
{

	if (n < 0){
		return 0;
	}
	else if (n == 0){
		return 1;
	}
	else if (n == 1){
		return a;
	}
	else {
		return tail_factorial(n-1, n * a);
	}
}


