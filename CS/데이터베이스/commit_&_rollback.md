# commit과 rollback 이란?

> 커밋(Commit)

: 모든 부분작업이 정상적으로 완료하면 이 변경사항을 한꺼번에 DB에 반영
작성한 쿼리문에서 Update, Delete, Insert를 수행했을 때, 그 쿼리문 수행결과에 대해 확정을 짓겠다는 뜻이다.

> 롤백(Rollback)

: 부분 작업이 실패하면 트랜잭션 실행 전으로 되돌려 쿼리문 수행결과에 대해 번복을 함.  
즉, 쿼리문 수행 이전으로 원상복귀 하겠다는 뜻이다.  
(Commit 하기 전에 사용됨)