유지현.sql



SELECT basics
1
SELECT population FROM world
  WHERE name = 'Germany'
2
SELECT name, population FROM world
  WHERE name IN ( 'Sweden', 'Norway','Denmark');
3
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000



SELECT from world
1
SELECT name, continent, population FROM world
2
SELECT name FROM world
WHERE population >= 200000000
3
SELECT name, gdp/population
FROM world
WHERE population >= 200000000
4
SELECT name, population/1000000
FROM world
WHERE continent = 'South America'
5
SELECT name, population FROM world
WHERE name in ('France', 'Germany', 'Italy');
6
SELECT name FROM world
WHERE name like '%United%'
7
SELECT name, population, area 
FROM world
WHERE area >= 3000000 or population >= 250000000
8
SELECT name, population, area 
FROM world
WHERE (area >= 3000000 or population >= 250000000) and (area <= 3000000 or population <= 250000000) 
9
SELECT name, ROUND(population/1000000,2), ROUND(gdp/1000000000,2)
FROM world
WHERE continent = 'South America'  
10
SELECT name, round(gdp/population,-3)
FROM world
WHERE gdp >= 1000000000000  
11
SELECT name, capital
  FROM world
 WHERE  LENGTH(name)=LENGTH(capital)
12
 SELECT name, capital
FROM world
where LEFT(name,1)=LEFT(capital,1) and name<>capital
13
SELECT name
   FROM world
WHERE name LIKE '%a%'
 and name LIKE '%e%'
 and name LIKE '%i%'
 and name LIKE '%o%'
 and name LIKE '%u%'
  AND name NOT LIKE '% %'



SELECT from nobel
1
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950
2
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'
3
SELECT yr, subject 
  FROM nobel
 WHERE winner = 'Albert Einstein'
4
SELECT winner
  FROM nobel
 WHERE yr >= 2000
   AND subject = 'Peace'
5
SELECT yr, subject, winner
  FROM nobel
 WHERE yr >= 1980 and yr <= 1989
   AND subject = 'Literature'
6
SELECT yr, subject, winner FROM nobel
 WHERE yr >= 1906 and yr <= 2009
  AND winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter',
                    'Barack Obama')
7
SELECT winner FROM nobel
 WHERE winner like 'John%'
7-1*
select winner from nobel
substr(winner,1,instr(winner,'')-1) = 'John'
8
SELECT yr, subject, winner FROM nobel
 WHERE (yr =1980 and subject = 'Physics') 
or (yr =1984 and subject = 'Chemistry')
8-1
SELECT yr, subject, winner FROM nobel
 WHERE yr =1980 and subject = 'Physics') 
 union
 SELECT yr, subject, winner FROM nobel
 WHERE yr =1984 and subject = 'Chemistry' 
9
SELECT yr, subject, winner FROM nobel
 WHERE yr =1980 
 and subject in ('Economics', 'Literature','Peace','Physics')
 #not in 해도 됨
10
SELECT yr, subject, winner FROM nobel
 WHERE (subject='Medicine' and yr < 1910) 
or (subject='Literature' and yr >= 2004) 
11
SELECT yr, subject, winner FROM nobel
 WHERE winner='PETER GRÜNBERG'
12
SELECT yr, subject, winner FROM nobel
 WHERE winner like 'EUGENE O%'
 # ''해도 됨
13
SELECT winner, yr, subject FROM nobel
 WHERE winner like 'Sir%'
 order by yr desc, winner asc
14
SELECT winner, subject
  FROM nobel
 WHERE yr=1984 
 ORDER BY subject IN ('Physics','Chemistry')=1,subject, winner
 # =1없어도 됨
 14-1
 SELECT winner, subject
  FROM nobel
  (SELECT winner, subject, subject IN ('Physics','Chemistry') as subject2
  FROM nobel WHERE yr=1984 ) a
 order by a.subject2, a.subject, a.winner


SELECT in SELECT
 1
 SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')
2
 SELECT name FROM world
  WHERE gdp/population > 
     (SELECT gdp/population FROM world
      WHERE name='United Kingdom')
and continent='Europe'
3
SELECT name, continent FROM world
where continent in ('South America','Oceania')
order by name
3-1
SELECT name, continent FROM world
where continent in (select continent from world where name 
							in ('Argentina','Austrailia'))
order by name
4
SELECT name, population FROM world
WHERE population >
     (SELECT population FROM world
      WHERE name='Canada') and 
      population <
     (SELECT population FROM world
      WHERE name='Poland')
5
SELECT name, 
       CONCAT(Round(100*population/(SELECT population 
                                   FROM world
                               WHERE name='Germany'))
,'%') as percentage
FROM world
where 
 continent = 'Europe'
5-1
inline view
6
SELECT name FROM world 
WHERE gdp >= 
     (SELECT max(gdp) FROM world
      WHERE continent = 'Europe'and gdp>0)
7
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)
7-1
select a.continent, b.name as name, a.name
from
(SELECT continent, name, max(area) as area FROM world
group by continent) a, world b
where b.area = a.area
8*
SELECT DISTINCT continent, name FROM world x 
  WHERE name >= ALL
    (SELECT name FROM world y
        WHERE y.continent=x.continent
          GROUP BY name, continent
            ORDER BY name asc)
8-1
SELECT DISTINCT continent, min(name) FROM world
group by continent
#DISTINCT 생략가능
9*
SELECT name, continent, population FROM world  
  WHERE population <= 25000000
GROUP BY name, continent, population
9-1 #sub quary
SELECT name, continent, population FROM world  
  WHERE continent in (select continent from world 
                      group by continent
                      having max(population) <= 25000000)
#where조건에는 group by가 들어갈 수 없다. 그룹이 먼저 적용되기 때문이다.
9-2 #inline view
SELECT a.name, a.continent, a.population
FROM world a, (SELECT continent from world
              group by continent
              having max(population) <= 25000000) b
where a.continent = b.continent
10*
select name, continent
from world x
where 
population > ALL
(SELECT min(population)*3 FROM world y
        WHERE y.continent=x.continent
         GROUP BY continent ) #밑에 그룹이 안됨. 대륙별 어떻게 모을까.
10-1
#대륙별 제일 큰 나라를 선택
#대륙별 두번째 큰 나라를 선택
#그 둘을 비교
select a.name, 
       a.continent
from world a, (select b.continent, b.population
                from (select 
                           continent, 
                           max(population) as population
                       from (select a.continent,
                                    a.population
                             from world a,
(select continent, max(population) as population
 from world
group by continent) b 
where a.continent = b.continent 
  and a.population <> b.population) a
group by continent) a, (select continent, max(population) as population
 from world
group by continent) b
where b.population >= a.population*3 
  and b.continent = a.continent) b
where a.continent = b.continent
  and a.population = b.population;


SUM and COUNT
1
SELECT SUM(population)
FROM world
2
SELECT continent
FROM world
group by continent
2-1
SELECT distinct continent
FROM world
3
SELECT sum(gdp)
FROM world
where continent = 'Africa'
3-1
SELECT sum(gdp)
FROM world
group by continent
having continent = 'Africa'
4
SELECT count(area)
FROM world
where area >= 1000000
5
SELECT sum(population)
FROM world
where name in ('Estonia', 'Latvia', 'Lithuania')
6
SELECT continent, count(name)
FROM world
group by continent
7
SELECT continent, count(*)
FROM world
where population > 10000000
group by continent
8
SELECT continent
FROM world
group by continent
having sum(population) > 100000000



JOIN
1
SELECT matchid, player FROM goal 
  WHERE teamid LIKE '%GER'
2
SELECT id,stadium,team1,team2
  FROM game
WHERE id = '1012'
3
SELECT player,teamid,stadium,mdate
  FROM game JOIN goal ON (id=goal.matchid)
WHERE teamid like 'GER'
3-1
SELECT b.player,b.teamid,a.stadium,a.mdate
  FROM game a, goal b 
  where b.teamid='GER' and a.id=b.matchid
4
SELECT team1,team2, player
  FROM game JOIN goal ON (id=goal.matchid)
WHERE player LIKE 'Mario%'
4-1
SELECT b.team1,b.team2, a.player
  FROM goal a, game b 
  where player like 'Mario%' and a.matchid = b.id
5
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam on teamid=id
 WHERE gtime<=10
5-1
SELECT a.player, a.teamid, b.coach, a.gtime
  FROM goal a, eteam b 
  where a.teamid = b.id and a.gtime <= 10; 
6
SELECT mdate, teamname
  FROM game JOIN eteam ON (team1=eteam.id) 
 WHERE coach = 'Fernando Santos'
6-1
select b.mdate, a.teamname from eteam a, game b
where a.id=b.team1 and a.coach='Fernando Santos'
7*

7-1
SELECT a.player from game b, goal a 
where b.id = a.matchid and b.stadium = 'National Stadium, Warsaw'
8*
SELECT player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' AND team2='GRE') and gtime>1
8-1
SELECT DISTINCT player  FROM goal
where matchid i (select id from game
                  where team1 'GER'= or team2 = 'GRE')
and teanid <> 'GER'
8-2
SELECT DISTINCT b.player from game a, goal b
where (a.team1 = 'GER' or a.team2 = 'GRE')
and a.id = b.matchid
and b.teamid <> 'GER'
9

9-1
SELECT b.teamname, a.cnt 
from (select teamid, count(teamid) as cnt from goal
      group by teamid) a, eteam b b
where a.teamid = b.id 
order by b.teamname 
#join으로 뽑기 숙제
10

10-1
select a.stadium, sum(a.cnt)
from(
SELECT b.stadium, a.cnt
from
(SELECT matchid, count(*) as cnt from goal 
group by matchid) a, game b 
where a.matchid = b.id
)a
group by a.stadium 
11

11-1
SELECT a.matchid, a.mdate, count(*) 
from(
SELECT b.matchid, a.mdate from game a, goal b 
where a.id = b.matchid 
  and(a.team1 = 'POL' or a.team2 = 'POL') 
) a
group by a.matchid, a.mdate
12

12-1
SELECT a.matchid, b.mdate, a.cnt
from(
SELECT matchid, count(*) as cnt from goal
where matchid in (
                  SELECT id from game
                  where team1 = 'GER' or team2 = 'GER')
    and teamid = 'GER'
group by matchid
) a, game b
where a.matchid = b.id
13

13-1
select a.matchid, 
       a.teamid as team1,
       a.cnt,
       b.teamid as team2,
       b.cnt
from 
(select a.matchid, a.teamid, count(*) as cnt
from (select a.matchid, a.teamid
 from goal a, game b
where a.matchid = b.id and a.teamid = b.team1) a
group by a.matchid, a.teamid) a,
(select a.matchid, a.teamid, count(*) as cnt
from (select a.matchid, a.teamid
 from goal a, game b
where a.matchid = b.id and a.teamid = b.team2) a
group by a.matchid, a.teamid) b
where a.matchid = b.matchid;
13-2
select a.mdate, 
       a.team1, 
     a.score, 
     b.team2, 
     b.score
FROM (select mdate, team1, sum(score) as score
       FROM (select a.mdate, 
                    ifnull(b.teamid, a.team1) as team1,
                    case when
                    b.teamid is not null
                    then 
                     1
                    else
                      0
                    end score
              from game a left outer join goal b
               on a.id = b.matchid and b.teamid = a.team1) a
      group by a.mdate, a.team1) a,
      (select mdate, team2, sum(score) as score
        FROM (select a.mdate, 
                     ifnull(b.teamid, a.team2) as team2,
                     case when
                     b.teamid is not null
                     then 
                      1
                     else
                      0
                     end score
               from game a left outer join goal b
                   on a.id = b.matchid and b.teamid = a.team2) a
      group by a.mdate, a.team2) b, game c
where a.mdate = b.mdate 
  AND c.mdate = a.mdate 
  AND c.team1 = a.team1
  AND c.team2 = b.team2
ORDER BY a.mdate, c.id;



More JOIN
1
SELECT id, title
 FROM movie
 WHERE yr=1962
2
SELECT yr
 FROM movie
where title = 'Citizen Kane'
3
SELECT id, title, yr FROM movie 
where title like 'Star Trek%'
order by yr
4
SELECT distinct b.id FROM movie a, actor b
where b.name = 'Glenn Close'
5
SELECT distinct a.id FROM movie a, actor b
where a.title like 'Casablanca'
6
SELECT b.name FROM casting a, actor b
where a.movieid = '11768' and a.actorid=b.id
6-1
select b.actorid from movie a, casting b, actor c
where a.title like '%Casablanca%'
  and a.id = b.movieid and b.actorid = c.id
7
SELECT distinct b.name from movie a, actor b, casting c
where a.title='Alien'and a.id=c.movieid and b.id=c.actorid
#distinct 없어도 됨 
8
SELECT distinct a.title from movie a, actor b, casting c
where b.name='Harrison Ford'and a.id=c.movieid and b.id=c.actorid
9
SELECT distinct a.title from movie a, actor b, casting c
where b.name='Harrison Ford'and a.id=c.movieid and b.id=c.actorid 
  and c.ord<>'1'
10
SELECT title, name from 
casting JOIN movie ON movie.id=movieid
        JOIN actor ON actor.id=actorid
where yr='1962'and ord='1'
11
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2
11-1
SELECT c.yr, count(*) from actor a, casting b, movie c 
where a.name like '%Rock Hudson%' 
  and b.actorid=a.id and b.movieid = c.id 
group by c.yr 
having count(*) >=1
12*
select a.title, b.name
from(
SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Julie Andrews') a, actor b, movie c)
where a.movieid=c.id



select a.title, b.name from movie a, actor b, casting c 
WHERE b.id = c.actorid and a.id = c.movieid and ord = '1' 
join
select a.title, b.name from movie a, actor b, casting c 
where b.name = 'Julie Andrews'



SELECT title, name FROM
  casting JOIN movie ON movie.id=movieid
          JOIN actor   ON actorid=actor.id
WHERE ord = '1' 
union
SELECT title, name FROM
  casting JOIN movie ON movie.id=movieid
          JOIN actor   ON actorid=actor.id
WHERE name = 'Julie Andrews' 
order by title, name



12-1
select title, name
from movie join casting 
           on(movieid=movie.id AND ord=1) 
           join actor 
           on(actorid=actor.id) 
where movie.id
in(
SELECT movieid FROM casting
WHERE actorid IN (
                  SELECT id FROM actor
                  WHERE name='Julie Andrews')) 
12-2
SELECT distinct d.title, f.name
from(SELECT b.id, b.title from actor a, casting c, movie b
    where a.name='Julie Andrews' and a.id=c.actorid and c.movieid=b.id
     ) d, casting e, actor f 
where d.id=e.movieid and e.actorid=f.id and e.ord=1  
#중복이유 찾기 


#select 는 마지막에 세로로 자름 
#having은 group by 에 대한 조건식
#where은 from 테이블에 대한 조건식; 가로로자름
#SFWGHOL 순서



Using NULL
1
select name from teacher
where
dept IS NULL
2
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept  #없는것은 안 골라온다 = 이너조인
           ON (teacher.dept=dept.id)
2-1
select a.name, b.name from teacher a, dept b 
where a.dept = b.id 
3

3-1
select a.name, b.name from teacher a  
left outer join dept on a.dept = b.id 
4

4-1
select b.name, a.name from dept a  
left outer join teacher b on b.dept = a.id 
4-2
select a.name, b.name from teacher a  
right outer join dept on a.dept = b.id 
5

5-1
SELECT name, COALESCE(mobile, '07986 444 2266') from teacher
#coalesce 대신 ifnull써도 됨 
6

6-1
select a.name, infull(b.name, 'None') from teacher a  
left outer join dept b on a.dept = b.id 
7

7-1
SELECT count(id), count(mobile) from teacher
8

8-1
SELECT a.name, count(b.name) from dept a  
left outer join teacher b on a.id = b.dept
group by a.name
9

9-1
SELECT name, 
       case when 
       dept in (1,2)
       then
       'Sci'
       else
       'Art'
       end
from teacher 
10

10-1
SELECT name, 
       case when 
       dept in (1,2)
       then
       'Sci'
       else
       'None'
       end
from teacher 



Self JOIN
1

1-1
select count(*) from stops
2
SELECT id from stops
where name = 'Craiglockhart'
3
SELECT a.id, a.name from stops a, route b
where a.id=b.stop and b.company='LRT' and b.num=4
order by b.pos; 
3-1
SELECT a.id, a.name 
from stops a, (select stop, pos from route
where company = 'LRT' and num = 4) b 
where a.id=b.stop
order by b.pos 
4

4-1
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
having count(*) >= 2
#쿼리 문제 나오는 사이트 만들기 월요일까지 과제 
5

5-1 #원래 있던거 인라인 없게 고치기
SELECT a.company, a.num, a.stop, b.stop
FROM route a, route b, stops c 
where a.stop=53 and
      a.company=b.company and
      a.num=b.num and
      c.name='Craiglockhart'
5-2
SELECT a.num, b.num from route a, route b
where a.stop=53 and b.stop=149 and a.num=b.num
5-3
SELECT a.company, a.num, b.stop, b.stop from route a, route b
where a.stop=(select id from stops
                where name = 'Craiglockhart') 
    and b.stop=(select id from stops
                where name = 'London Road') 
    and a.num = b.num 
6

6-1
SELECT a.company, a.num, c.name, d.name 
from route a, route b, stops c, stops d
where a.stop=c.id and b.stop=d.id and c.id=53 and d.id=149 and a.num=b.num
7
SELECT distinct a.company, a.num from route a, route b
where a.stop=(select id from stops
                where name = 'Haymarket') 
    and b.stop=(select id from stops
                where name = 'Leith') 
    and a.num = b.num 
7-1
SELECT distinct a.company, a.num from route a, route b
where a.stop=115 and b.stop=137 and a.num=b.num 
8
SELECT distinct a.company, a.num from route a, route b
where a.stop=(select id from stops
                where name = 'Craiglockhart') 
    and b.stop=(select id from stops
                where name = 'Tollcross') 
    and a.num = b.num 
8-1
SELECT distinct a.company, a.num from route a, route b, stops c, stops d
where a.num = b.num and c.name = 'Craiglockhart' and d.name = 'Tollcross'
      and c.id=a.stop and d.id=b.stop 
9

9-1
SELECT c.name, a.company, a.num from route a, route b, stops c
where a.stop=53 and b.num in (a.num) and c.id=b.stop and b.company='LRT'
9-2 #힌트보기
SELECT b.name, a.num from rout a, stop b
where a.stop=b.id and a.num=27
10

10-1
#1. 정보확인
SELECT * from stops
where name in ('Craiglockhart'and'Lochend') # 53, 147 결과참고
#2. 문제조건(어디부터 어디까지 가는 버스) 정보 확인
SELECT num, stop from route
where stop in (select stop from route where num=10)
#3. 정보활용해 147번 정류장 까지 가는 일직선 버스 확인
SELECT num, stop from route
where num 
in(SELECT num from route
where stop in (select stop from route where num=10)
)
and stop=147 
#4. 147번 정류장을 지나는(갈아 탈 수 있는) 버스 확인 
SELECT num, stop from route
where num 
in(SELECT num from route
where stop in (select stop from route where num 
                in(SELECT num from route where stop=53)
                )) 
and stop=147 
#5. 셀프조인 써서 3번, 4번 합치면 목적지까지 가는 버스를 확인할 수 있음
SELECT y.num, z.company, v.name, x.num, z.company
from(
SELECT num, stop from route
where num 
in(SELECT num from route
where stop in (select stop from route where num=10)
) 
and stop=147 
) x, route z, stops v
join(
SELECT num, stop from route
where num 
in(SELECT num from route
where stop in (select stop from route where num 
                in(SELECT num from route where stop=53)
                )) 
and stop=147 
) y
on x.name=y.name
#수업 답 

SELECT a.num start_bus, b.num end_bus, a.stop, b.stop from route a, route b
where a.stop=53 and b.stop=147

SELECT a.stop, a.num from route a, route b, stops c
where a.num in (10, 20) and a.stop=b.stop and a.stop=c.id 

SELECT a.stop c.name from route a, route b, stops c
where a.num =10 and b.num = 34 and a.stop=b.stop and a.stop=c.id 


>>
SELECT a.num, a.company, d.name, b.num, b.company from route a, route b,
    (SELECT a.num start_num, b.num end_num, 
            a.company as start_company, b.company as end_company 
            from route a, route b
     where a.stop=53 and b.stop=147) c, stops d
where a.num in (c.start_num) and b.num in (c.end_num) 
            and a.company=c.start_company and b.company=c.end_company
            and a.stop=b.stop and a.stop=d.id 
order by a.num, d.name, b.num 