# HTTP Method

## 📌 GET / POST

- `GET`
    - http request message의 헤더 부분의 URL에 담겨서 전송되며, 바디는 비어있는 상태의 URL 뒤에 데이터를 가져오기 위한 조건이 포함  
    → URL에 조건이 포함되어있기 떄문에 데이터의 제한이 있고, 보안에 위험하다.
- `POST`
    - http request message의 바디 부분에 클라이언트의 요청을 처리하기 위한 데이터가 존재.  
    → URL에 노출되지 않기 떄문에 보안 위험은 없고, 보내는 데이터의 제한이 없다.
```
GET 요청은 캐싱이 된다. 웹서버에 요청이 전달되지 않고, 캐시에서 데이터를 전달해준다.
```


## 📌 PUT/ PATCH

- `PUT`
    - 요청된 자원을 수정할 때 사용하는 메서드로, 필드 전체를 수정할 때 사용한다.
    - 만약 일부만 전달할 경우, 그 외의 필드는 NULL 혹은 초기값으로 처리된다.
- `PATCH`
    - 요청된 자원을 수정할 때, 자원내 필드를 일부 수정할 때 사용한다.


## 📌 DEL

- 제정한 리소스를 삭제한다.
