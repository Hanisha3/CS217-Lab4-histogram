#include <stdio.h>
#define BLOCK_SIZE 512
#define SIZE 4096
__global__ void histo_kernel(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins)
{
	
    /*************************************************************************/
    // INSERT KERNEL CODE HERE
	
	
	  /*************************************************************************/
	int threadId = threadIdx.x;
	int blockId = blockIdx.x;
	int p = (blockId * blockDim.x) + threadId;
	__shared__ unsigned int histo_array[SIZE];

	if(num_bins > BLOCK_SIZE) {
		for(int i = threadId; i < num_bins; i+=BLOCK_SIZE){
			if(i < num_bins){
				histo_array[i] = 0;
					}			
			}
		}
	else{
		if(threadId < num_bins){
		histo_array[threadId] = 0;
	}
	} 
	
	__syncthreads();

	if(p < num_elements) {
		atomicAdd(&(histo_array[input[p]]),1);
 
	}
	__syncthreads();

	if(num_bins > BLOCK_SIZE) {
                for(int i = threadId; i < num_bins; i+=BLOCK_SIZE){
                        if(i < num_bins){
                                atomicAdd(&(bins[i]),histo_array[i]);
                                        }
                        }
                }
        else{
                if(threadId < num_bins){
                atomicAdd(&(bins[threadId]),histo_array[threadId]);
        }
        }

        

}

void histogram(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins) {

	  /*************************************************************************/
    //INSERT CODE HERE


	  /*************************************************************************/
	dim3 threadPerBlock(BLOCK_SIZE,1, 1);
	dim3 blockPerGrid(ceil(num_elements/(float)BLOCK_SIZE),1,1);
	histo_kernel<<<blockPerGrid,threadPerBlock>>>(input, bins, num_elements, num_bins);
}


