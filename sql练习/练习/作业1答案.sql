DROP TABLE IF EXISTS student;

CREATE TABLE student (
	 id int(4) PRIMARY KEY,
	 NAME VARCHAR(10) ,
	 sex char(2)
);

#部门表
CREATE TABLE dept (
	deptno INT(4) PRIMARY KEY,
	dname VARCHAR(20) COMMENT '部门名称',
	loc VARCHAR(20) COMMENT '部门位置'
);

#员工信息表
CREATE TABLE emp (
	empno INT(4) PRIMARY KEY AUTO_INCREMENT,
	ename VARCHAR(20),
	job VARCHAR(20) COMMENT '工作',
	manager VARCHAR(20) COMMENT '领导的编号',
	hiredate date,
	salary FLOAT(8,2),
	comm FLOAT(5,2) COMMENT '提成',
	deptno INT(4) COMMENT '部门编号'
);

#工资等级表
CREATE TABLE salgrade (
	grade INT PRIMARY KEY,
	losal INT(4) COMMENT '下限',
	hisal INT(4) COMMENT '上限'
);

CREATE TABLE office (
	ono INT(4) PRIMARY KEY COMMENT '科室编号',
	oname VARCHAR(20) COMMENT '科室名称'
);

SHOW TABLES;

INSERT INTO student (id,NAME,sex) VALUES(1,'唐理','男'),(2,'陈丹','女'),(3,'吴迪','女'),(4,'孙凯','男');

SELECT * FROM student

#设为自增
ALTER TABLE student MODIFY id INT AUTO_INCREMENT;

SHOW CREATE TABLE student

INSERT INTO student (NAME,sex) VALUES('timy2','女');

BEGIN;
INSERT INTO `dept` VALUES (10, 'accounting', 'New York');
INSERT INTO `dept` VALUES (20, 'research', 'Dallas');
INSERT INTO `dept` VALUES (30, 'sales', 'Chicago');
INSERT INTO `dept` VALUES (40, 'operations', 'Boston');
INSERT INTO `dept` VALUES (50, 'manager', 'Washington');
COMMIT;

BEGIN;
INSERT INTO `emp` VALUES (7369, 'smith', 'operations', 7947, '2016-12-17', 8000.00, 100.00, 40);
INSERT INTO `emp` VALUES (7947, 'park', 'research', 7902, '2017-01-31', 40000.00, NULL, 50);
INSERT INTO `emp` VALUES (7948, 'swift', 'sales', 7947, '2019-12-01', 4500.00, 900.00, 30);
INSERT INTO `emp` VALUES (7949, '007', 'sales', 7947, '2019-10-01', 4500.00, 500.00, 30);
INSERT INTO `emp` VALUES (7950, 'lilei', 'research', 7947, '2018-05-23', 10000.00, NULL, 20);
INSERT INTO `emp` VALUES (7951, 'hanmm', 'research', 7947, '2019-02-28', 8000.00, NULL, 20);
INSERT INTO `emp` VALUES (7977, 'jordon', 'sales', 7902, '2019-12-01', 5000.00, 800.00, 30);
INSERT INTO `emp` VALUES (7978, 'wilianm', 'accounting', 7947, '2018-12-01', 12000.00, NULL, 10);
COMMIT;

#不在accounting和sales的员工
SELECT * FROM emp WHERE job NOT IN ('accounting','sales')

#查询工资比20号部门所有员工都高的员工信息
SELECT * FROM emp WHERE salary > (SELECT MAX(salary) FROM emp WHERE deptno=20)

#查询工资比20号部门任意一个员工高的员工
SELECT * FROM emp WHERE salary > (SELECT MIN(salary) FROM emp WHERE deptno=20)

#查询不是领导的员工信息
SELECT * FROM emp WHERE deptno != 50

#平均值
SELECT AVG(salary) FROM emp

#找到员工表中薪水大于本部门平均薪水的员工
SELECT * FROM emp WHERE salary > (SELECT AVG(salary) FROM emp)
