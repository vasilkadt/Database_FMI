
CREATE DATABASE TEMP;
USE TEMP;

--Задача 1
--а) Дефинирайте следните релации:
--Product (maker, model, type), където:
-- модел е низ от точно 4 символа,
-- производител е низ от точно 1 символ,
-- тип е низ до 7 символа;
--Printer (code, model, price), където:
-- код е цяло число,
-- модел е низ от точно 4 символа,
-- цена с точност до два знака след десетичната запетая;
--б) Добавете кортежи с примерни данни към новосъздадените релации.
--в) Добавете към релацията Printer атрибути:
-- type - низ до 6 символа (забележка: type може да приема стойност 'laser', 'matrix' или 'jet'),
-- color - низ от точно 1 символ, стойност по подразбиране 'n' (забележка: color може да приема стойност 'y' или 'n').
--г) Напишете заявка, която премахва атрибута price от релацията Printer.
--д) Изтрийте релациите, които сте създали в Задача 1.

CREATE TABLE Product (
maker CHAR(1),
model CHAR(4),
[type] VARCHAR(7)
);

CREATE TABLE Printer (
code INT,
model CHAR(4),
price DECIMAL(5,2)
);

INSERT INTO Product
VALUES ('A', 'MOD1', 'TYPE1'),
	   ('B', 'MOD2', 'TYPE2');
 
INSERT INTO Printer (code, model, price)
VALUES (333, 'MOD1', 250.99),
	   (222, 'MOD2', 400.99);

ALTER TABLE Printer 
ADD [type] VARCHAR(6),
color CHAR(1) DEFAULT 'n',
CONSTRAINT [type]
   CHECK ([type] IN ('laser', 'matrix', 'jet')),
CONSTRAINT color 
   CHECK (color IN ('n', 'y'));
   
ALTER FROM Product DROP COLUMN price;

DROP TABLE Product;
DROP TABLE Printer;

-- Задача 2
-- а) Нека създадем мини вариант на Facebook. Искаме да имаме следните релации:
-- Users: уникален номер (id), email, парола, дата на регистрация.
-- Friends: двойки от номера на потребители, напр. ако 12 е приятел на 21, 25 и
-- 40, ще има кортежи (12,21), (12,25), (12,40).
-- Walls: номер на потребител, номер на потребител написал съобщението,
-- текст на съобщението, дата.
-- Groups: уникален номер, име, описание (по подразбиране - празен низ).
-- GroupMembers: двойки от вида номер на група - номер на потребител.
-- б) Добавете кортежи с примерни данни към новосъздадените релации.

CREATE TABLE Users (
id INTEGER,
email VARCHAR(30),
[password] VARCHAR(30),
dateOfRegistration DATETIME2
);

CREATE TABLE Friends (
fr1ID INT,
fr2ID INT
);

CREATE TABLE Walls (
ownerID INTEGER,
writerID INTEGER,
[text] VARCHAR(300),
[date] DATETIME2
);

CREATE TABLE Groups (
id INTEGER,
[name] VARCHAR(20),
[description] VARCHAR(100) DEFAULT ''
);

CREATE TABLE GroupMembers (
groupID INTEGER,
userID INTEGER
);

INSERT INTO Users
VALUES (1, 'vasi@abv.bg', 'vaschica', GETDATE()),
	   (2, 'gabi@abv.bg', 'gabka', GETDATE());
INSERT INTO Friends
VALUES (1, 2),
	   (2, 1);
INSERT INTO Walls
VALUES (1, 2, 'zdravei', GETDATE()),
	   (2, 1, 'zdr', GETDATE());
INSERT INTO Groups
VALUES (1, 'kolejkite', '4-te kolejki');
INSERT INTO GroupMembers
VALUES (1, 1),
	   (1, 2);