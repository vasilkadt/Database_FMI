USE movies;

--EXERSICE 1--

--Напишете заявка, която извежда адреса на студио ‘Disney’.
SELECT ADDRESS  
FROM STUDIO
WHERE NAME='Disney';

--Напишете заявка, която извежда рождената дата на актьора Jack Nicholson.
SELECT BIRTHDATE 
FROM MOVIESTAR
WHERE NAME='Jack Nicholson';

--Напишете заявка, която извежда имената на актьорите, които са участвали във филм от 1980 или във филм,
--в чието заглавие има думата ‘Knight’.
SELECT STARNAME 
FROM STARSIN
WHERE MOVIEYEAR = 1980 OR MOVIETITLE LIKE '%Knight%';

--Напишете заявка, която извежда имената на продуцентите с нетни активи над 10 000 000 долара.
SELECT NAME 
FROM MOVIEEXEC
WHERE NETWORTH > 10000000;

--Напишете заявка, която извежда имената на актьорите, които са мъже или живеят на Prefect Rd.
SELECT NAME
FROM MOVIESTAR
WHERE GENDER = 'M' OR ADDRESS = 'Prefect Rd';

--EXERSICE 2--

--Напишете заявка, която извежда имената на актьорите мъже, участвали във филма The Usual Suspects.
SELECT STARNAME
FROM STARSIN JOIN MOVIESTAR ON STARNAME=NAME
WHERE GENDER='M' AND MOVIETITLE='The Usual Suspects';

--Напишете заявка, която извежда имената на актьорите, участвали във филми от 1995, продуцирани от студио MGM.
SELECT STARNAME
FROM STARSIN JOIN MOVIE ON MOVIETITLE=TITLE
WHERE MOVIEYEAR=1995 AND STUDIONAME ='MGM';

--Напишете заявка, която извежда имената на продуцентите, които са продуцирали филми на студио MGM.
SELECT DISTINCT NAME 
FROM MOVIEEXEC JOIN MOVIE ON PRODUCERC# = CERT#
WHERE STUDIONAME = 'MGM';

--Напишете заявка, която извежда имената на филми с дължина, по-голяма от дължината на филма Star Wars.
SELECT m1.TITLE  
FROM MOVIE AS m1, MOVIE AS m2
WHERE m2.TITLE = 'Star Wars' AND m1.[LENGTH] > m2.[LENGTH];

--Напишете заявка, която извежда имената на продуцентите с нетни активи поголеми от тези на Stephen Spielberg.
SELECT me1.NAME
FROM MOVIEEXEC AS me1, MOVIEEXEC AS me2
WHERE me2.NAME='Stephen Spielberg' AND me1.NETWORTH > me2.NETWORTH;

--EXERSICE 3--
--Напишете заявка, която извежда имената на актрисите, които са също и продуценти с нетни активи над 10 милиона.
SELECT NAME
FROM MOVIESTAR
WHERE GENDER='M' AND NAME IN (SELECT NAME
FROM MOVIEEXEC
WHERE NETWORTH > 10000000);

--Напишете заявка, която извежда имената на тези актьори (мъже и жени), които не са продуценти.
SELECT NAME
FROM MOVIESTAR
WHERE NAME NOT IN (SELECT NAME
FROM MOVIEEXEC);

--Напишете заявка, която извежда имената на всички филми с дължина, по-голяма от дължината на филма ‘Star Wars’.
SELECT TITLE 
FROM MOVIE
WHERE [LENGTH] > ALL(SELECT [LENGTH]  
FROM MOVIE
WHERE TITLE = 'Star Wars');

--Напишете заявка, която извежда имената на продуцентите и имената на филмите за всички филми, 
--които са продуцирани от продуценти с нетни активи по-големи от тези на ‘Merv Griffin’.
SELECT NAME, TITLE
FROM MOVIEEXEC JOIN MOVIE ON PRODUCERC# = CERT#
WHERE NETWORTH > ALL(SELECT NETWORTH
FROM MOVIEEXEC
WHERE NAME = 'Merv Griffin');

--EXERSICE 4--

--Напишете заявка, която извежда името на продуцента и имената на филмите, продуцирани от продуцента на филма ‘Star Wars’.
SELECT NAME, TITLE
FROM MOVIEEXEC JOIN MOVIE ON CERT# = PRODUCERC#
WHERE CERT# IN(SELECT PRODUCERC#
FROM MOVIE
WHERE TITLE='Star Wars');

--Напишете заявка, която извежда имената на продуцентите на филмите, в които е участвал ‘Harrison Ford’.
SELECT DISTINCT NAME 
FROM MOVIEEXEC JOIN MOVIE ON CERT# = PRODUCERC#
WHERE TITLE IN(SELECT MOVIETITLE
FROM STARSIN
WHERE STARNAME='Harrison Ford');

--Напишете заявка, която извежда името на студиото и имената на актьорите, участвали във филми, 
--произведени от това студио, подредени по име на студио.
SELECT DISTINCT STUDIONAME, STARNAME
FROM MOVIE JOIN STARSIN ON TITLE=MOVIETITLE
ORDER BY STUDIONAME;

--Напишете заявка, която извежда имената на актьорите, участвали във филми на продуценти с най-големи нетни активи.
SELECT DISTINCT STARNAME, NETWORTH, MOVIETITLE
FROM STARSIN JOIN MOVIE ON MOVIETITLE=TITLE 
JOIN MOVIEEXEC ON PRODUCERC# = CERT#
WHERE NETWORTH >=ALL(SELECT NETWORTH
FROM MOVIEEXEC)
ORDER BY MOVIETITLE;

--Напишете заявка, която извежда имената на актьорите, които не са участвали в нито един филм.
SELECT DISTINCT NAME, MOVIETITLE
FROM STARSIN RIGHT JOIN MOVIESTAR ON STARNAME = NAME
WHERE MOVIETITLE is null;

--EXERSICE 6--
--Напишете заявка, която извежда заглавие и година на всички филми, които са по-дълги от 120
--минути и са снимани преди 2000 г. Ако дължината на филма е неизвестна, заглавието и годината на този филм също да се изведат.
SELECT TITLE, YEAR 
FROM MOVIE
WHERE [LENGTH] > 120 OR [LENGTH] is NULL AND YEAR < 2000;

--Напишете заявка, която извежда име и пол на всички актьори (мъже и жени), чието име започва
--с 'J' и са родени след 1948 година. Резултатът да бъде подреден по име в намаляващ ред.
SELECT NAME, GENDER 
FROM MOVIESTAR 
WHERE NAME LIKE 'J%' AND BIRTHDATE > 1948
ORDER BY NAME DESC;

--Напишете заявка, която извежда име на студио и брой на актьорите,
--участвали във филми, които са създадени от това студио.
SELECT STUDIONAME AS studioname, COUNT(DISTINCT STARNAME) AS num_actors
FROM MOVIE JOIN STARSIN ON TITLE = MOVIETITLE
GROUP BY STUDIONAME;

--Напишете заявка, която за всеки актьор извежда име на актьора и броя на
--филмите, в които актьорът е участвал.
SELECT STARNAME AS starname, COUNT(DISTINCT MOVIETITLE) AS num_movies
FROM STARSIN
GROUP BY STARNAME;

--Напишете заявка, която за всяко студио извежда име на студиото и заглавие
--на филма, излязъл последно на екран за това студио.
SELECT m1.STUDIONAME AS studioname, m1.TITLE AS title, m1.YEAR AS year
FROM MOVIE AS m1
WHERE TITLE =(SELECT TOP(1) TITLE
FROM MOVIE AS m2
WHERE m1.STUDIONAME = m2.STUDIONAME
ORDER BY YEAR DESC)
ORDER BY m1.STUDIONAME DESC;

--Напишете заявка, която извежда името на най-младия актьор (мъж).
SELECT ms1.NAME AS name
FROM MOVIESTAR AS ms1
WHERE GENDER='M' AND BIRTHDATE >=ALL(SELECT BIRTHDATE 
FROM MOVIESTAR AS ms2
WHERE GENDER='M');

--Напишете заявка, която извежда име на актьор и име на студио за тези
--актьори, участвали в най-много филми на това студио.
SELECT STUDIONAME as studioname, STARNAME AS starname, COUNT(STARNAME) AS num_movies
FROM MOVIE JOIN STARSIN ON MOVIETITLE = TITLE
GROUP BY STARNAME, STUDIONAME
HAVING COUNT(STARNAME)>=ALL(SELECT COUNT(STARNAME) AS num_movies
FROM MOVIE JOIN STARSIN ON MOVIETITLE = TITLE
GROUP BY STARNAME, STUDIONAME);

--Напишете заявка, която извежда заглавие и година на филма, и брой на
--актьорите, участвали в този филм за тези филми с повече от двама актьори.
SELECT TITLE AS movietitle, YEAR AS movieyear, COUNT(STARNAME) AS num_actors
FROM MOVIE JOIN STARSIN ON MOVIETITLE = TITLE
GROUP BY TITLE, YEAR
HAVING COUNT(STARNAME) > 2;

USE pc;

--EXERSICE 1--

--Напишете заявка, която извежда модел, честота и размер на диска за
--всички персонални компютри с цена под 1200 долара. Задайте
--псевдоними за атрибутите честота и размер на диска, съответно MHz и GB.
SELECT model, speed AS MHz, hd as GB
FROM pc
WHERE price < 1200;

--Напишете заявка, която извежда производителите на принтери без повторения.
SELECT DISTINCT maker
FROM product;

--Напишете заявка, която извежда модел, размер на паметта, размер на екран за лаптопите, чиято цена е над 1000 долара.
SELECT model, ram, screen 
FROM laptop
WHERE price > 1000;

--Напишете заявка, която извежда всички цветни принтери.
SELECT code, model, color, type, price 
FROM printer
WHERE color = 'y';

--Напишете заявка, която извежда модел, честота и размер на диска за
--тези персонални компютри със CD 12x или 16x и цена под 2000 долара.
SELECT model, speed, hd
FROM pc
WHERE cd='12x' OR cd='16x' AND price < 2000;

--EXERSICE 2--

--Напишете заявка, която извежда производителя и честотата на лаптопите с размер на диска поне 9 GB.
SELECT DISTINCT maker, speed
FROM laptop JOIN product ON laptop.model = product.model
WHERE hd >= 9;

--Напишете заявка, която извежда модел и цена на продуктите, произведени от производител с име B.
SELECT pc.model, price
FROM product JOIN pc ON pc.model=product.model
WHERE maker = 'B'
UNION  
SELECT laptop.model, price
FROM product JOIN laptop ON laptop.model=product.model
WHERE maker = 'B'
UNION  
SELECT printer.model, price
FROM product JOIN printer ON printer.model=product.model
WHERE maker = 'B';

--Напишете заявка, която извежда производителите, които произвеждат лаптопи, но не произвеждат персонални компютри.
SELECT maker
FROM laptop JOIN product ON laptop.model = product.model
EXCEPT 
SELECT maker
FROM pc JOIN product ON pc.model = product.model

--Напишете заявка, която извежда размерите на тези дискове, които се предлагат
--в поне два различни персонални компютъра (два компютъра с различен код).
SELECT DISTINCT pc1.hd
FROM pc AS pc1 JOIN pc AS pc2 ON pc1.hd = pc2.hd 
WHERE pc1.code != pc2.code; 

--Напишете заявка, която извежда двойките модели на персонални компютри, които имат еднаква честота и памет. 
--Двойките трябва да се показват само по веднъж, например само (i, j), но не и (j, i).
SELECT DISTINCT pc1.model, pc2.model
FROM pc AS pc1 JOIN pc AS pc2 ON pc1.speed = pc2.speed AND pc1.ram = pc2.ram
WHERE pc1.model < pc2.model;


--Напишете заявка, която извежда производителите на поне два различни персонални компютъра с честота поне 400.
SELECT DISTINCT maker
FROM pc AS pc1 JOIN product ON pc1.model = product.model
JOIN pc AS pc2 ON pc2.model=product.model
WHERE pc1.speed >= 400 AND pc2.speed >= 400;

--EXERSICE 3--

--Напишете заявка, която извежда производителите на персонални компютри с честота над 500.
SELECT maker
FROM product
WHERE model IN (SELECT model
FROM pc
WHERE speed > 500);

--Напишете заявка, която извежда код, модел и цена на принтерите с най-висока цена.
SELECT code, model, price
FROM printer
WHERE price >= ALL(SELECT price
FROM printer);

--Напишете заявка, която извежда лаптопите, чиято честота е по-ниска от честотата на всички персонални компютри.
SELECT *
FROM laptop
WHERE speed < ALL(SELECT speed
FROM pc);

--Напишете заявка, която извежда модела и цената на продукта (PC, лаптоп или принтер) с най-висока цена.
SELECT model, price
FROM laptop
WHERE price >= ALL(SELECT price
FROM printer)
AND price >= ALL(SELECT price
FROM laptop)
AND price >= ALL(SELECT price
FROM pc)
UNION 
SELECT model, price
FROM pc
WHERE price >= ALL(SELECT price
FROM printer)
AND price >= ALL(SELECT price
 FROM laptop)
AND price >= ALL(SELECT price
FROM pc)
UNION 
SELECT model, price
FROM printer
WHERE price >= ALL(SELECT price
FROM printer)
AND price >= ALL(SELECT price
FROM laptop)
AND price >= ALL(SELECT price
FROM pc);

--Напишете заявка, която извежда производителя на цветния принтер с най-ниска цена.
SELECT maker
FROM printer JOIN product ON printer.model = product.model
WHERE color='y' AND price <= ALL(SELECT price
FROM printer
WHERE color='y');

--Напишете заявка, която извежда производителите на тези персонални компютри с най-малко RAM памет, които имат най-бързи процесори.
SELECT maker
FROM product JOIN pc ON product.model = pc.model 
WHERE ram <= ALL(SELECT ram
FROM pc) 
AND speed >=ALL(SELECT speed
FROM pc
WHERE pc.ram <= ALL(SELECT ram
FROM pc));

--EXERSICE 4--

--Напишете заявка, която извежда производител, модел и тип на продукт за тези производители, 
--за които съответният продукт не се продава(няма го в таблиците PC, Laptop или Printer).
SELECT *
FROM product
WHERE model NOT IN(SELECT model
FROM pc)
AND model NOT IN(SELECT model
FROM laptop)
AND model NOT IN(SELECT model
FROM printer);

--Намерете всички производители, които правят както лаптопи, така и принтери.
SELECT DISTINCT p1.maker
FROM product AS p1 JOIN laptop ON p1.model=laptop.model
JOIN product AS p2 ON p1.maker=p2.maker 
JOIN printer ON p2.model=printer.model;

--Намерете размерите на тези твърди дискове, които се появяват в два или повече модела лаптопи.
SELECT DISTINCT l1.hd
FROM laptop AS l1 JOIN laptop AS l2 ON l1.model!=l2.model
WHERE l1.hd=l2.hd;

--Намерете всички модели персонални компютри, които нямат регистриран производител.
SELECT model
FROM pc
WHERE model NOT IN(SELECT model
FROM product);

--EXERSICE 5--

--Напишете заявка, която извежда средната честота на персоналните компютри.
SELECT ROUND(AVG(speed),2) AS AvgSpeed
FROM pc;

--Напишете заявка, която извежда средния размер на екраните на лаптопите за всеки производител.
SELECT maker, AVG(screen) AS AvgScreen
FROM laptop JOIN product ON laptop.model=product.model
GROUP BY maker;

--Напишете заявка, която извежда средната честота на лаптопите с цена над 1000.
SELECT AVG(speed) AS AvgSpeed
FROM laptop
WHERE price > 1000;

--Напишете заявка, която извежда средната цена на персоналните компютри, произведени от производител ‘A’.
SELECT maker, ROUND(AVG(price),2) AS AvgPrice
FROM pc JOIN product ON pc.model = product.model
WHERE maker = 'A'
GROUP BY maker;

--Напишете заявка, която извежда средната цена на персоналните компютри и лаптопите за производител ‘B’.
SELECT maker, AVG(price) AS AvgPrice
FROM(SELECT price, model
FROM laptop
UNION ALL
SELECT price, model
FROM pc) t
JOIN product ON t.model = product.model 
WHERE maker='B'
GROUP BY maker;

--Напишете заявка, която извежда средната цена на персоналните компютри според различните им честоти.
SELECT speed, AVG(price) AS AvgPrice
FROM pc
GROUP BY speed;

--Напишете заявка, която извежда производителите, които са произвели поне 3 
--различни персонални компютъра (с различен код).
SELECT maker, COUNT(*) AS number_of_pc
FROM pc JOIN product ON pc.model = product.model
GROUP BY maker
HAVING COUNT(*) > 2;

--Напишете заявка, която извежда производителите с най-висока цена на персонален компютър.
SELECT maker, MAX(price)
FROM pc JOIN product ON pc.model = product.model
GROUP BY maker
HAVING MAX(price) >= ALL(SELECT price FROM pc);

--Напишете заявка, която извежда средната цена на персоналните компютри за всяка честота по-голяма от 800.
SELECT speed, AVG(price) AS AvgPrice
FROM pc
WHERE speed > 800
GROUP BY speed;

--.Напишете заявка, която извежда средния размер на диска на тези персонални компютри, 
--произведени от производители, които произвеждат и принтери. Резултатът да се изведе за всеки отделен производител.
SELECT maker, AVG(hd) AS AvgHDD
FROM pc JOIN product ON pc.model = product.model 
WHERE maker IN (SELECT maker
FROM product JOIN printer ON printer.model=product.model)
GROUP BY maker;

--EXERSICE 6--
--Напишете заявка, която извежда всички модели лаптопи, за които се предлагат както разновидности с 15" екран, така и с 11" екран.
SELECT model, code, screen
FROM laptop
WHERE screen = 15
UNION 
SELECT model, code, screen
FROM laptop
WHERE screen = 11;

--Да се изведат различните модели компютри, чиято цена е по-ниска от найевтиния лаптоп, произвеждан от същия производител.
SELECT DISTINCT pc.model
FROM pc JOIN product AS pr1 ON pc.model = pr1.model
WHERE price <(SELECT TOP(1) price
FROM laptop JOIN product AS pr2 ON laptop.model = pr2.model
WHERE pr1.maker  = pr2.maker
ORDER BY price DESC);

--Един модел компютри може да се предлага в няколко разновидности с различна цена.
--Да се изведат тези модели компютри, чиято средна цена (на различните му разновидности) 
--е по-ниска от най-евтиния лаптоп, произвеждан от същия производител.
SELECT p.model AS model, AVG(price) as avg_price
FROM pc AS p JOIN product AS pr1 ON p.model = pr1.model
GROUP BY p.model, pr1.maker
HAVING AVG(p.price) <(SELECT TOP(1) l.price
FROM laptop AS l JOIN product AS pr2 ON l.model = pr2.model
WHERE pr1.maker = pr2.maker
ORDER BY l.price);

--Напишете заявка, която извежда за всеки компютър код на продукта, производител и брой
--компютри, които имат цена, по-голяма или равна на неговата.
SELECT p.code AS code, p2.maker AS maker, (SELECT COUNT(p3.price) 
						                   FROM pc AS p3
						                   WHERE p3.price >= p.price) AS num_pc_higher_price
FROM pc AS p 
JOIN product AS p2 ON p.model = p2.model;


USE ships;

--EXERSICE 1--

--Напишете заявка, която извежда класа и страната за всички класове с помалко от 10 оръдия.
SELECT CLASS, COUNTRY 
FROM CLASSES
WHERE NUMGUNS < 10;

--Напишете заявка, която извежда имената на корабите, пуснати на вода
--преди 1918. Задайте псевдоним shipName на колоната.
SELECT NAME AS shipName
FROM SHIPS
WHERE LAUNCHED < 1918;

--Напишете заявка, която извежда имената на корабите, потънали в битка и имената на съответните битки.
SELECT SHIP, BATTLE 
FROM OUTCOMES
WHERE RESULT='sunk';

--Напишете заявка, която извежда имената на корабите с име, съвпадащо с името на техния клас.
SELECT NAME
FROM SHIPS
WHERE NAME=CLASS;

--Напишете заявка, която извежда имената на корабите, които започват с буквата R.
SELECT NAME
FROM SHIPS
WHERE NAME LIKE 'R%';

--Напишете заявка, която извежда имената на корабите, които съдържат 2 или повече думи.
SELECT NAME
FROM SHIPS
WHERE NAME LIKE '% %';

--EXERSICE 2--

--Напишете заявка, която извежда името на корабите с водоизместимост над 50000.
SELECT NAME
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS 
WHERE DISPLACEMENT > 50000;

--Напишете заявка, която извежда имената, водоизместимостта и броя оръдия на
--всички кораби, участвали в битката при Guadalcanal.
SELECT NAME, DISPLACEMENT, NUMGUNS
FROM SHIPS JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
JOIN CLASSES ON CLASSES.CLASS = SHIPS.CLASS
WHERE OUTCOMES.BATTLE = 'Guadalcanal';

--Напишете заявка, която извежда имената на тези държави, които имат както бойни кораби, така и бойни крайцери.
SELECT cl1.COUNTRY
FROM CLASSES AS cl1 JOIN CLASSES AS cl2 ON cl1.COUNTRY = cl2.COUNTRY 
WHERE cl1.[TYPE] = 'bb' AND cl2.[TYPE] = 'bc';

--Напишете заявка, която извежда имената на тези кораби, които са били
--повредени в една битка, но по-късно са участвали в друга битка.
SELECT outc1.SHIP
FROM OUTCOMES AS outc1 JOIN OUTCOMES AS outc2 ON outc1.SHIP = outc2.SHIP 
JOIN BATTLES AS b1 ON b1.NAME = outc1.BATTLE 
JOIN BATTLES AS b2 ON b2.NAME = outc2.BATTLE
WHERE outc1.[RESULT] = 'damaged' AND b1.[DATE] < b2.[DATE];

--EXERSICE 3--

--Напишете заявка, която извежда страните, чиито кораби са с най-голям брой оръдия.
SELECT DISTINCT COUNTRY
FROM CLASSES
WHERE NUMGUNS >= ALL(SELECT NUMGUNS
FROM CLASSES);

--Напишете заявка, която извежда класовете, за които поне един от корабите е потънал в битка.
SELECT DISTINCT CLASS 
FROM SHIPS JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE [RESULT] >= ANY (SELECT [RESULT]
FROM OUTCOMES
WHERE [RESULT] = 'sunk');

--Напишете заявка, която извежда името и класа на корабите с 16 инчови оръдия.
SELECT NAME, CLASS
FROM SHIPS
WHERE CLASS IN(SELECT CLASS
FROM CLASSES
WHERE BORE=16);

--Напишете заявка, която извежда имената на битките, в които са участвали кораби от клас ‘Kongo’.
SELECT BATTLE
FROM OUTCOMES
WHERE SHIP IN(SELECT NAME
FROM SHIPS
WHERE CLASS='Kongo');

--Напишете заявка, която извежда класа и името на корабите, чиито брой оръдия е по-голям 
--или равен на този на корабите със същия калибър оръдия.
SELECT CLASS, NAME
FROM SHIPS 
WHERE CLASS IN (SELECT CLASS 
FROM CLASSES AS c
WHERE c.NUMGUNS >= ALL(SELECT NUMGUNS
FROM CLASSES
WHERE BORE = c.BORE))
ORDER BY CLASS;

--EXERSICE 4--

--Напишете заявка, която извежда цялата налична информация за всеки кораб, 
--включително и данните за неговия клас. В резултата не трябва да се включват тези класове, които нямат кораби.
SELECT *
FROM SHIPS FULL JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS
WHERE NAME IS NOT null;

--Повторете горната заявка, като този път включите в резултата и класовете, 
--които нямат кораби, но съществуват кораби със същото име като тяхното.
SELECT *
FROM SHIPS FULL JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS;

--За всяка страна изведете имената на корабите, които никога не са участвали в битка.
SELECT COUNTRY, NAME
FROM CLASSES JOIN SHIPS ON CLASSES.CLASS = SHIPS.CLASS
LEFT JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE OUTCOMES.BATTLE IS NULL
ORDER BY COUNTRY;

--Намерете имената на всички кораби с поне 7 оръдия, пуснати на вода през 1916,
--но наречете резултатната колона Ship Name.
SELECT NAME AS 'Ship Name'
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS
WHERE NUMGUNS>=7 AND LAUNCHED=1916;

--Изведете имената на всички потънали в битка кораби, името и дата на провеждане на битките,
--в които те са потънали. Подредете резултата по име на битката.
SELECT SHIP, NAME, DATE 
FROM OUTCOMES JOIN BATTLES ON BATTLE=NAME
WHERE RESULT='sunk'
ORDER BY NAME;

--Намерете името, водоизместимостта и годината на пускане на вода на 
--всички кораби, които имат същото име като техния клас.
SELECT NAME, DISPLACEMENT, LAUNCHED
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS
WHERE NAME=SHIPS.CLASS;

--Намерете всички класове кораби, от които няма пуснат на вода нито един кораб.
SELECT *
FROM CLASSES LEFT JOIN SHIPS ON SHIPS.CLASS = CLASSES.CLASS
WHERE LAUNCHED IS NULL;

--Изведете името, водоизместимостта и броя оръдия на корабите, участвали в
--битката ‘North Atlantic’, а също и резултата от битката.
SELECT NAME, DISPLACEMENT, NUMGUNS, RESULT 
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS
JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE BATTLE='North Atlantic'

--EXERSICE 5--

--Напишете заявка, която извежда броя на класовете бойни кораби.
SELECT COUNT(DISTINCT CLASS)
FROM CLASSES
WHERE TYPE='bb';

--Напишете заявка, която извежда средния брой оръдия за всеки клас боен кораб.
SELECT CLASS, AVG(NUMGUNS) AS AvgGuns
FROM CLASSES
WHERE TYPE='bb'
GROUP BY CLASS;

--Напишете заявка, която извежда средния брой оръдия за всички бойни кораби.
SELECT AVG(NUMGUNS) AS AvgGuns
FROM CLASSES
WHERE TYPE='bb';

--Напишете заявка, която извежда за всеки клас първата и последната година, в
--която кораб от съответния клас е пуснат на вода.
SELECT CLASSES.CLASS , MIN(LAUNCHED) AS FirstYear, MAX(LAUNCHED) AS LastYear
FROM CLASSES JOIN SHIPS ON CLASSES.CLASS = SHIPS.CLASS
GROUP BY CLASSES.CLASS;

--Напишете заявка, която извежда броя на корабите, потънали в битка според класа.
SELECT CLASS, COUNT(RESULT) AS NO_Sunk
FROM SHIPS JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE RESULT = 'sunk'
GROUP BY CLASS;

--Напишете заявка, която извежда броя на корабите, потънали в битка според
--класа, за тези класове с повече от 2 кораба.
SELECT CLASS, COUNT(RESULT) AS NO_Sunk
FROM SHIPS JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE RESULT = 'sunk'
GROUP BY CLASS
HAVING CLASS IN ( SELECT c.CLASS
				 FROM CLASSES AS c
				 JOIN SHIPS AS sh ON sh.CLASS = c.CLASS
				 GROUP BY c.CLASS
				 HAVING COUNT(sh.NAME) > 2);

--Напишете заявка, която извежда средния калибър на оръдията на корабите за всяка страна.
SELECT COUNTRY, CONVERT(decimal(4,2), AVG(BORE)) AS Avg_Bore
FROM CLASSES JOIN SHIPS ON SHIPS.CLASS = CLASSES.CLASS
GROUP BY COUNTRY;

--EXERSICE 6--

--Напишете заявка, която извежда имената на всички кораби без повторения,
--които са участвали в поне една битка и чиито имена започват с C или K.
SELECT DISTINCT NAME
FROM SHIPS JOIN OUTCOMES ON NAME=SHIP
WHERE NAME LIKE 'C%' OR NAME LIKE 'K%';

--Напишете заявка, която извежда име и държава на всички кораби, които
--никога не са потъвали в битка (може и да не са участвали).
SELECT DISTINCT NAME AS name, COUNTRY AS country
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS 
LEFT JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE RESULT='ok' OR RESULT='damaged' OR RESULT is NULL;

--Напишете заявка, която извежда държавата и броя на потъналите кораби за тази държава. 
--Държави, които нямат кораби или имат кораб, но той не е участвал в битка, също да бъдат изведени.
SELECT COUNTRY AS country, COUNT(DISTINCT SHIP) AS num_sunk_ships
FROM SHIPS RIGHT JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS 
LEFT JOIN OUTCOMES ON SHIPS.NAME = OUTCOMES.SHIP
WHERE RESULT = 'sunk' OR RESULT IS NULL
GROUP BY COUNTRY;

--Напишете заявка, която извежда име на битките, които са по-мащабни (с
--повече участващи кораби) от битката при Guadalcanal.
SELECT o1.BATTLE AS battle
FROM OUTCOMES AS o1 JOIN SHIPS AS s1 ON s1.NAME = o1.SHIP
GROUP BY o1.BATTLE
HAVING COUNT(s1.NAME) > (SELECT COUNT(s2.NAME)
FROM OUTCOMES AS o2 JOIN SHIPS AS s2 ON s2.NAME = o2.SHIP
WHERE o2.BATTLE='Guadalcanal'
GROUP BY o2.BATTLE);

--Напишете заявка, която извежда име на битките, които са по-мащабни (с
--повече участващи страни) от битката при Surigao Strait.
SELECT o1.BATTLE AS battle
FROM OUTCOMES AS o1 JOIN SHIPS AS s1 ON s1.NAME = o1.SHIP
GROUP BY o1.BATTLE
HAVING COUNT(s1.NAME) > (SELECT COUNT(s2.NAME)
FROM OUTCOMES AS o2 JOIN SHIPS AS s2 ON s2.NAME = o2.SHIP
WHERE o2.BATTLE='Surigao Strait'
GROUP BY o2.BATTLE);

--Напишете заявка, която извежда имената на най-леките кораби с най-много оръдия.
SELECT NAME 
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS 
WHERE DISPLACEMENT <=ALL(SELECT DISPLACEMENT  
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS
WHERE NUMGUNS >=ANY(SELECT NUMGUNS  
FROM SHIPS JOIN CLASSES ON SHIPS.CLASS = CLASSES.CLASS));

--Изведете броя на корабите, които са били увредени в битка, но са били
--поправени и по-късно са победили в друга битка.
SELECT COUNT(DISTINCT SHIP) AS num_ships
FROM OUTCOMES
WHERE [RESULT] = 'damaged' AND SHIP IN(SELECT SHIP
FROM OUTCOMES
WHERE [RESULT] = 'ok');
