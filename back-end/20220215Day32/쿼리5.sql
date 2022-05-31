SELECT *
 FROM 제품;
 
SELECT *
 FROM 판매;
 
SELECT product.제품명,
		 sales.판매수량
 FROM 제품 product LEFT JOIN 판매 sales 
 		ON product .제품번호= sales.제품번호
ORDER BY sales.판매수량 DESC;


SELECT * FROM 지도교수;
SELECT * FROM 팀프로젝트;
  
-- ('김수현','이종석','박보영','이민호') 
SELECT DISTINCT #중복제거
		 #b.이름,
		 #b.조장,
		 a.지도교수,
		 a.교수명
 FROM 지도교수 a JOIN 팀프로젝트 b
 	ON a.조장 = b.조장#;
WHERE b.이름 IN ('김수현','이종석','박보영','이민호') ;   


SELECT DISTINCT 
		 a.지도교수,
		 a.교수명
 FROM 지도교수 a, 팀프로젝트 b
WHERE a.`조장` =b.`조장` 
		AND b.`이름` IN  ('김수현','이종석','박보영','이민호') ;  #위의 식을 where로 쓰기
		
/*
-- 하의질의: where절의 select문
S
F inline view
W
G sub quary
(H)
O
*/

SELECT * FROM 지도교수;
SELECT * FROM 교수전공;

CREATE VIEW 교수전공 AS   #새로운 참조테이블 만듦
SELECT a.교수명,
		 b.전공명
 FROM 지도교수 a, 전공 b
WHERE a.전공코드=b.`전공코드`;

SELECT*
 FROM 교수전공
WHERE 교수명 = '김철수';



SELECT * FROM 학생평가;

SELECT 이름,
		 조이름,
		 점수
 FROM 학생평가
WHERE 점수 = 96;

SELECT 조이름, MAX(점수) 
	FROM 학생평가
GROUP BY 조이름;

SELECT 조이름,
		 이름,
		 점수
 FROM 학생평가
WHERE 조이름 = 'BIG' AND 점수 = 96;

SELECT a.`조이름`, 
		 a.이름,
		 a.점수
FROM 학생평가 a,(
						SELECT 조이름, MAX(점수) AS 점수
						FROM 학생평가
						GROUP BY 조이름
					  ) b 
WHERE a.조이름 = b.조이름 
  AND a.점수 = b.점수;
  
 
SELECT 조이름, 
		 이름,
		 점수
 FROM 학생평가 
WHERE 점수= ( SELECT MAX(점수)
					FROM 학생평가
				 );
				 
SELECTwhdlfma
SELECT 조이름, 
		 이름,
		 점수
 FROM 학생평가 
WHERE 점수= ( SELECT 96
					FROM 학생평가
					LIMIT 1
				 );
				 
				 
SELECT a.조이름, 
		 a.이름,
		 b.점수
 FROM 학생평가 a, (SELECT MAX(점수) AS 점수
						 FROM 학생평가
 						 ) b
WHERE a.점수 = b.`점수` ;



SELECT * FROM 점수;
SELECT MAX(점수) AS 점수
						 FROM 학생평가;







SELECT a.조이름, a.`이름`, a.`점수`
 FROM 학생평가 a
WHERE a.`점수`=(
						SELECT MAX(b.`점수`)
						 FROM 학생평가 b
						WHERE a.조이름 = b.조이름
				 	 );
	
-- 스칼라 서브 쿼리
SELECT * FROM 판매;
DELETE * FROM 판매 WHERE 판매번호 = 8;

SELECT SUM(판매수량)
 FROM 판매;
 
SELECT 제품번호,
		 판매수량, 
		 89 AS 총판매수량
 FROM 판매;
 
SELECT 제품번호,
		 판매수량,
		 (SELECT SUM(판매수량) FROM 판매) AS 총판매수량
 FROM 판매;
 
SELECT * FROM 지도교수, 전공;
SELECT a.지도교수,
		 a.교수명,
		 a.전공코드,
		 b.전공명
 FROM 지도교수 a, 전공 b 				 				 				 
WHERE a.`전공코드` =b.`전공코드`;

SELECT a.지도교수, 
		 a.교수명,
		 a.전공코드,
		 (SELECT b.전공명 FROM 전공 b WHERE a.`전공코드` =b.`전공코드`)
 FROM 지도교수 a;
 
 
 
 
 
 
 
 #n 등 뽑기
 SELECT * FROM 학생;
 
 SELECT 점수, 이름, 학번, RANK() over (ORDER BY 점수 DESC) RANK 등수
 FROM 학생;
 
 #case구문 RC표준파일 
 SELECT 이름, 
 			 case when 점수 >= 90 
			 then 'A' 
			 when 점수 >= 80 
			 then 'B' 
			 ELSE 'C' 
			 END 등급, 점수 FROM 학생;

 
 
 SELECT table_name 
 FROM information_schema.TABLES
 WHERE table_schema = 'SampleDB';
 
 SELECT * FROM 성적2;
 
 SELECT * 
 FROM TABLES
 WHERE table_schema = 'information_schema';
 

 
 
 
 
 
SELECT * FROM world;

DESC 학생평가;

SELECT * FROM 학생평가;
DESC 학생평가1;


SELECT * FROM 학생평가
WHERE 점수 %3=0;

SELECT COUNT(*) FROM world;

#DROP TABLE world;

DESC world;








  SELECT * 
 FROM columns
 WHERE table_schema = 'information_schema';
 
 
 
 SELECT * FROM information_schema.`TABLES`
 WHERE table_schema = 'blog';

CREATE TABLE blog.world as SELECT * FROM SampleDB.world;
SELECT * FROM blog.world;

ALTER TABLE world RENAME TO intro_world;

INSERT INTO intro_intro(NAMES,hobby) VALUES('이순재','서든');
INSERT INTO intro_intro(NAMES,hobby) VALUES('지병규','GTA');
INSERT INTO intro_intro(NAMES,hobby) VALUES('황성욱','롤');
INSERT INTO intro_intro(NAMES,hobby) VALUES('정인모','서든');
INSERT INTO intro_intro(NAMES,hobby) VALUES('이강욱','서든');





SELECT * FROM intro_intro;

UPDATE intro_intro SET pic = '1.jpg' WHERE id = 1;
UPDATE intro_intro SET pic = '2.jpg' WHERE id = 2;
UPDATE intro_intro SET pic = '3.jpg' WHERE id = 3;
UPDATE intro_intro SET pic = '4.jpg' WHERE id = 4;
UPDATE intro_intro SET pic = '5.jpg' WHERE id = 5;

SELECT * FROM intro_intro WHERE NAMES='이강욱';

select names, hobby, CONCAT('static/img/',pic) as pic from intro_intro where names = '{name}';
blog

CREATE TABLE blog.charge;



SELECT* FROM aaa;

CREATE TABLE charge(
   addr   VARCHAR(255)   NOT NULL,
   chargeTp   VARCHAR(1)   NOT NULL,
   cpId   VARCHAR(12)   NOT NULL,
   cpNm   VARCHAR(20)   NOT NULL,
   cpStat VARCHAR(2)   NOT NULL,
   cpTp   VARCHAR(2)   NOT NULL,
   csId VARCHAR(12)   NOT NULL,
   csNm   VARCHAR(50)   NOT NULL,
   lat   VARCHAR(20)   NOT NULL,
   longi   VARCHAR(20)   NOT NULL,
   statUpdateDatetime VARCHAR(20)   NOT NULL
   
   )	DEFAULT CHARSET=utf8;
   
INSERT INTO charge (addr, chargeTp, cpId, cpNm, cpStat, cpTp, csId, csNm, lat, longi, statUpdateDatetime)
				VALUES ('Jeonllanamdo', 2, 13, 'fast01', 1, 8, 9, 'home(naju)', 35.02636975, 126.7844551, '2017-02-22 13:02:22');
			
				
				
SELECT * FROM charge;