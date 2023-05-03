USE movies;

--Да се вмъкне информация за актрисата Nicole Kidman.
--За нея знаем само, че е родена на 20.06.1967.
INSERT INTO MOVIESTAR (NAME, GENDER, BIRTHDATE)
VALUES ('Nicole Kidman', 'F', '1967-06-20');
 
--Да се изтрият всички продуценти с нетни активи под 30 милиона.
DELETE FROM MOVIEEXEC
WHERE NETWORTH < 30000000;

--Да се изтрие информацията за всички филмови звезди, за които не се знае адреса.
DELETE FROM MOVIESTAR 
WHERE ADDRESS is NULL;

USE pc;

-- Използвайте две INSERT заявки. Съхранете в базата данни факта, че персонален компютър
--модел 1100 е направен от производителя C, има процесор 2400 MHz, RAM 2048 MB, твърд диск
--500 GB, 52x оптично дисково устройство и струва $299. Нека новият компютър има код 12.
--Забележка: модел и CD са от тип низ.
INSERT INTO product (model, maker, type)
VALUES ('1100', 'C', 'PC');
INSERT INTO pc (code, model, speed, ram, hd, cd, price)
VALUES (12, '1100', 2400, 2048, 500, '52x', 299);

--Да се изтрие наличната информация в таблицата PC за компютри модел 1100.
DELETE FROM pc 
WHERE model=1100;

--Да се изтрият от таблицата Laptop всички лаптопи, направени от производител, който не произвежда принтери.
DELETE FROM laptop 
WHERE model IN (SELECT model
                FROM product
                WHERE maker NOT IN (SELECT DISTINCT maker
									FROM product
									WHERE type = 'Printer')
				AND type = 'Laptop');

--Производител А купува производител B. На всички продукти на В променете производителя да бъде А.
UPDATE product 
SET maker='A'
WHERE maker='B';

--Да се намали наполовина цената на всеки компютър и да се добавят по 20 GB към всеки твърд диск.
UPDATE pc 
SET price = price/2, hd = hd+20;

--За всеки лаптоп от производител B добавете по един инч към диагонала на екрана.
UPDATE laptop 
SET screen = screen+1
WHERE model IN (SELECT DISTINCT model
                FROM product
                WHERE type='Laptop'
                AND maker='B');

USE ships;

--Два британски бойни кораба от класа Nelson - Nelson и Rodney - са били пуснати на вода
--едновременно през 1927 г. Имали са девет 16-инчови оръдия (bore) и водоизместимост от 34000
--тона (displacement). Добавете тези факти към базата от данни.
INSERT INTO SHIPS(NAME,CLASS,LAUNCHED)
VALUES('Nelson','Nelson',1927),
	  ('Rodney','Nelson',1927);
INSERT INTO CLASSES(CLASS,TYPE,COUNTRY,NUMGUNS,BORE,DISPLACEMENT)
VALUES('Nelson','bb','Gt.Britain',9,16,34000),
	  ('Nelson','bb','Gt.Britain',9,16,34000);
	  
--Изтрийте от таблицата Ships всички кораби, които са потънали в битка.
DELETE FROM SHIPS 
WHERE NAME IN (SELECT SHIP
               FROM OUTCOMES
               WHERE RESULT='sunk');

--Променете данните в релацията Classes така, че калибърът (bore) да се измерва в сантиметри (в
--момента е в инчове, 1 инч ~ 2.5 см) и водоизместимостта да се измерва в метрични тонове (1 м.т. = 1.1 т.)
UPDATE CLASSES
SET BORE = BORE*2.5, DISPLACEMENT = DISPLACEMENT/1.1;