CREATE TABLE student (id INT(4), NAME char(5), sex INT(1), age INT(4), vs char(8) COMMENT '院系', class INT(4), date date, tel char(11), jg char(4) COMMENT '籍贯')

ALTER TABLE student ADD PRIMARY KEY(id)

ALTER TABLE student ADD UNIQUE(tel)

SHOW CREATE TABLE student;

ALTER TABLE student ADD CONSTRAINT chk_age CHECK(age >= 18 and age <= 30);

INSERT INTO student VALUES(1,'张小青', 1, 20, '广告', 0801, '2007-12-5', '13245678945', '内蒙古');

INSERT INTO student VALUES(2,'于洋', 1, 40, '软工', 0708, '2007-7-15', '13171254631', '辽宁');

INSERT INTO student VALUES(3,'余婷', 1, 21, '环艺', 0709, '2007-9-3', '15815674123', '江西'),
(4,'任亮', 0, 21, '英语', 0802, '2008-2-22', '13145674123', '山东'),
(5,'高亮', 0, 22, '环艺', 0709, '2007-8-26', '15012897953', '山西'),
(6,'龚建刚', 0, 23, '环艺', 0803, '2008-2-26', '13171254689', '江西');

#所有人年龄加1
UPDATE student SET age=age+1 ;

#修改所有男生并且大于22岁的学生的籍贯为北京
UPDATE student SET jg='北京' WHERE sex=0 and age > 22 ;

#修改入学日期在2007-12-1之前的学生的性别为男
UPDATE student set sex=0 where TO_DAYS(date) - TO_DAYS('2007-12-1') < 0;

INSERT INTO student VALUES(7,'马东洋', 0, 25, '软工', 0708, '2007-12-25', '13545563489', '湖北');

#修改学号大于004号并且年龄超出22岁的同学的院系为建筑
UPDATE student SET vs='建筑' WHERE id > 4 AND age > 22;

#删除英语的学生
DELETE FROM student WHERE vs='英语' ;

#查询出广告学院，软工学院学生的信息
SELECT * FROM student WHERE vs='广告' OR vs='软工';

#查询出年龄在20--22之间的学生的姓名,年龄,所在班级
SELECT NAME, age,	class FROM student WHERE age > 20 and age < 24;

#查询年龄大于22岁的男同学和所有女同学
SELECT * FROM student WHERE (age > 22 AND sex=0) OR sex=1;

#查询学生表中学校的院系,显示院系
SELECT DISTINCT vs FROM student ;

#查询学号为006和004的学生信息
SELECT * FROM student WHERE id in (4,6);