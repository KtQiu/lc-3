#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

typedef struct Node professor ; 

typedef struct Node
{
	professor *next;
	char firstName[17];
	char lastName[17];
	char room[17];
}Data;

typedef struct  test tPro ;
typedef struct test
{
	tPro *next;
	char testname[20];
	int offset[1005][1005];
	int count ;
}testPro;

Data* initData(int numOfPeople);
testPro* initTestData(int testNum);
void search(Data* inputData, testPro* testData,int num2, int num1);
void print(Data *inputData, testPro *testData,int testNum, int numOfPeople);


int main() {
	int numOfPeople;
	int testNum;
	int i;
	scanf("%d",&numOfPeople);
	Data *head;
	Data *inputData = (Data*)malloc(sizeof(Data));
	head = inputData;
	for (i = 0; i < numOfPeople; ++i)
	 {
	 	inputData->next = (Data*)malloc(sizeof(Data));
	 	scanf("%s",inputData->firstName);
		scanf("%s",inputData->lastName);
		scanf("%s",inputData->room);
		inputData = inputData->next;
		inputData->next = NULL;
	 } 
	inputData = head;
	scanf("%d",&testNum);
	testPro *testData;
	testData = (testPro*)malloc(sizeof(testPro));
	testPro *head2 = testData;
	for (i = 0; i < testNum; ++i)
	{
		testData->next = (testPro*)malloc(sizeof(testPro));
		scanf("%s",testData->testname);
		memset(testData->offset, 0, 1005*1005*sizeof(int));
		testData->count = 0;
		testData = testData->next;
		testData->next = NULL;
	}
	testData = head2;
	search(inputData, testData,numOfPeople,testNum);
	print(inputData, testData,testNum,numOfPeople);
	printf("\n");
	free(testData);
	free(inputData);
	//dont forget to free  
    return 0;
}


void search(Data* inputData, testPro* testData,int num1, int num2){
	Data *p = inputData;
	testPro *q = testData;
	int location = 0;
	int i = 0;
	int j = 0;
	while(j < num2){
		while(i < num1){
			if((!strcmp(inputData->firstName, testData->testname))||(!(strcmp(inputData->lastName, testData->testname)))){
				testData->offset[j][testData->count] = location;
				(testData->count)++;
			}
			location++;
			inputData = inputData->next;
			i++;
		}
		testData = testData->next;
		location = 0;
		inputData = p;
		i = 0;
		j++;
	}
	inputData  = p;
	testData = q;
	return ;
}

void print(Data *inputData, testPro *testData,int testNum,int numOfPeople){
	testPro *q = testData;
	Data *p = inputData;
	int i = 0;
	int j = 0;
	int k = 0;
		for(j = 0; j < testNum ; j++){
			printf("%d\n", q->count);
			while(q->count != 0 && i < q->count){
				if(i != 0){ 
				for(k = 0; k < (q->offset[j][i] - q->offset[j][i-1]); k++){
						p = p->next;
					}
				}else{
					for(k = 0; k < q->offset[j][i]; k++){
						p = p->next;
					}
				}
				printf("%s %s %s\n", p->lastName, p->firstName, p->room);
				i++;
			}
			i = 0;
			p = inputData;
			q = q->next;  
		}
	return ;
}
