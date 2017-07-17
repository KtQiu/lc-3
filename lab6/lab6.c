#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

int height[101][101];
int distance[101][101];
int dx[4] = {-1,1,0,0,};
int dy[4] = {0,0,1,-1};   	// the (dx, dy) (0 1) (0 -1) (-1 0) (1 0) 
							// can go to the 4 adjacent points 
int col; // lie
int row; // hang

int dis(int i, int j);

int main() {
	scanf("%d",&row);
	scanf("%d",&col);
	int i = 0;
	int j = 0;
	int temp = 0;
	int result = 0;
	for (i = 0; i < row; ++i){
		for (j = 0; j < col; ++j){
			scanf("%d",&height[i][j]);
		}
	}
	for (i = 0; i < row; ++i){
		for (j = 0; j < col; ++j){
		 temp = dis(i,j);   
		    result = result > temp ? result : temp; 
		}	
	}
	printf("%d", result+1);
	return 0;
}

int dis(int i, int j)
{
	int k = 0;
	int temp = 0;
	if(distance[i][j]) // the res has been caled, direstly return the value   
	       return distance[i][j];   
	   for(k = 0; k < 4; k++){   
	       if(i+dx[k] >= 0 && i+dx[k] < row && j+dy[k] >= 0 && j+dy[k] < col){   
	           if(height[i][j] > height[ i+dx[k] ][ j+dy[k] ]){ 	// if h[i][j] is higher   
	              temp = dis(i+dx[k],j+dy[k]);     
	              distance[i][j] = distance[i][j] > temp ? distance[i][j] : temp + 1;   
	           }   
	       }   
	   }   
	return distance[i][j];
}
