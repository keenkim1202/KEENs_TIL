# 동적 배열 (C언어)

## 1차원 배열
```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 5

int main() {
    srand((unsigned int) time(NULL));

    int *X = (int*)malloc(N * sizeof(int));
 
    if (X == NULL) {
        fprintf(stderr, "Out of memory");
        exit(0);
    }
    
    for (int c = 0; c < N; c++) {
        *(X + N + c) = rand() % 10; // 난수를 생성하여 값으로 할당
    }
    
    for (int c = 0; c < N; c++) {
        printf("%d ", (X + N)[c]);
    }
    printf("\n");
    
    free(X); // deallocate memory
    return 0;
}
```

## 2차원 배열
```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define M 4
#define N 5

int main() {
    srand((unsigned int) time(NULL));
    int *X = (int *)malloc(M * N * sizeof(int));

    if (X == NULL) {
        fprintf(stderr, "Out of memory");
        exit(0);
    }
    
    for (int r = 0; r < M; r++) {
        for (int c = 0; c < N; c++) {
            *(X + r * N + c) = rand() % 100; // 난수를 생성하여 값으로 할당
        }
    }
    
    for (int r = 0; r < M; r++) {
        for (int c = 0; c < N; c++) {
            printf("%d ", (X + r * N)[c]);
        }
        
        printf("\n");
    }

    free(X); // deallocate memory
    return 0;
}
```
