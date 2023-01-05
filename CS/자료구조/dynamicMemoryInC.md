# 동적 메모리 할당 (C언어)
 - 동적 메모리가 할당되는 공간은 heap 이라고 한다.
    - heap은 운영체제가 사용되지 않는 메모리 공간을 모아 놓은 곳이다.
    - 필요한 만큼만 할당 받고, 필요할 때 사용하고 반납하기 때문에 메모리를 매우 효율적으로 사용할 수 있다.
    

## 동적메모리 할당 예제     
```c
// 전형적인 동적 메모리 할당 코드

int *p;
p = (int *)malloc(sizeof(int)); // 동적 메모리 할당
*p = 1000; // 동적 메모리 사용
free(p); // 동적 메모리 반납
 ```
 
 - `malloc()` 함수는 `size` 바이트 만큼의 메모리 블록을 할당한다.
    - `sizeof` 키워드는 변수나 타입의 크기를 숫자로 반환한다. 크기의 단위는 바이트가 된다.
    - `malloc()`은 동적 메모리 블록의 시작 주소를 반환한다.
    - 반환되는 주소의 타입은 `void *`이므로 이를 적절한 포인터로 형변환시켜야 한다.
    - 메모리 확보가 불가능하면 `NULL`을 함수의 반환값으로 반환한다.
    - 동적 메모리는 포인터로만 사용할 수 있다.
 - `free()` 함수는 할당된 메모리 블록을 운영체제에게 반환한다.
    - 여기서 주의할 점은 `malloc()` 함수가 반환했던 포인터 값을 잊어버리면 안된다는 것. 포인터값을 잊어버리면 동적 메모리를 반환할 수 없다.
 - `malloc()`은 시스템의 메모리가 부족해서 요구된 메모리를 할당할 수 없으면 `NULL`을 반환한다.
    - 따라서 `malloc()`의 반환값은 항상 `NULL`인지 검사해야 한다.


```c
// 동적 메모리 할당 예제 1
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

#define SIZE 10

int main(void) {
    int *p;
    
    p = (int *)malloc(SIZE * sizeof(int));
    
    if(p == NULL) {
        fprintf(stderr, "메모리 부족. 할당 불가\n");
        exit(1);
    }
    
    for (int i = 0; i < SIZE; i++) {
        p[i] = i;
    }
    
    for (int i = 0; i < SIZE; i++) {
        printf("%d", p[i]);
    }
    
    free(p);
    return 0;
}

```

```c
// 동적 메모리 할당 예제 2
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct studentTag {
    char name[10];
    int age;
    double gpa;
} student;

int main(void) {
    student *s;
    
    s = (student *)malloc(sizeof(student)); // student 구조체를 나타내는 포인터 s 선언
    
    if (s == NULL) {
    fprintf(stderr, "메모리 부족. 할당 불가\n");
    exit(1);
    }
    
    strcpy(s -> name, "Kim");
    s -> age = 20;
    
    free(s);
    return 0;
}
```
- `malloc()` 함수를 이용하여 `Student` 구조체를 동적으로 생성
- `(*s).name` 이라고 표기할 수 있지만 `s -> name` 이 좀 더 편리하여 사용
