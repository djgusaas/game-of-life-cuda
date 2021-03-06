#include <stdio.h>
#include <stdlib.h>

#define NUM_THREADS 256

#define min(a, b) (((a) < (b)) ? (a) : (b))

__global__ void cell_kernel(int univ[], int h, int w, int new_univ[])
{
	int id = __mul24(blockIdx.x, blockDim.x) + threadIdx.x;
	int size = h * w;

	for (id; id < size; id += blockDim.x * gridDim.x) 
	{
		// Neighbor positions
		unsigned x = id % w;
		unsigned y = id - x;
		unsigned x_l = (x + w - 1) % w;
		unsigned x_r = (x_p + 1) % w;
		unsigned y_u = (y + size - w) % size;
		unsigned y_d = (y + size) % size;
		
		// Calculate number of alive neighbors
		int alive = univ[x_l + y_u] + univ[x + y_u] + univ[x_r + y_u] + univ[x_l + y] + univ[x_r + y] + univ[x_l + y_u] + univ[x + y_d] + univ[x_r + y_d];

		new_univ[x_pos + y_pos] = alive == 3 || (alive == 2 && univ[x_pos + y_pos]) ? 1 : 0;
	}
}

void print_array(int arr[], int size)
{	
	printf("\n");

	for (int i = 0; i < size; i++)
	{
		printf("%d", arr[i]);
	}

	printf("\n");
}

void generate(int g, int h, int w)
{
	// Number of cells in universe
	int size = h * w;

	// Host(CPU) arrays
	int h_univ[size];
	int h_new_univ[size];

	// Devide(GPU) arrays
	int d_univ[size];
	int d_new_univ[size]

	// Randomly seed universe
	for (int i = 0; i < size; i++) 
	{
		h_univ[i] = rand() % 2;
	}

	while(g > 0)
	{
		size_t t = (size) / NUM_THREADS;
		unsigned blocks_count = (unsigned)min((size_t)32768, t);

		cell_kernel<<<blocks_count, t>>>(d_univ, h, w, d_new_univ);

		// Perform some sort memory copying from GPU to CPU

		//memcpy(h_new_univ, h_univ, size);
		print_array(h_univ, size);
		g--;
	}
	// Release memory? 
}

int main()
{
	int g, h, w;

	printf("Enter desired number of generations:\n");
	scanf("%d", &g);

	printf("Enter desired height of universe:\n");
	scanf("%d", &h);

	printf("Enter desired width of universe:\n");
	scanf("%d", &w);

	generate(g, h, w);

	return 0;
}
