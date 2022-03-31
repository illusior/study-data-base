USE lab7;

-- 1. Добавить внешние ключи.

ALTER TABLE lesson
    ADD CONSTRAINT FK_lesson_teacher FOREIGN KEY (id_teacher)
        REFERENCES teacher (id_teacher);

ALTER TABLE lesson
    ADD CONSTRAINT FK_lesson_subject FOREIGN KEY (id_subject)
        REFERENCES subject (id_subject);

ALTER TABLE lesson
    ADD CONSTRAINT FK_lesson_group FOREIGN KEY (id_group)
        REFERENCES `group` (id_group);

ALTER TABLE mark
    ADD CONSTRAINT FK_mark_lesson FOREIGN KEY (id_lesson)
        REFERENCES lesson (id_lesson);

ALTER TABLE mark
    ADD CONSTRAINT FK_mark_student FOREIGN KEY (id_student)
        REFERENCES student (id_student);

ALTER TABLE student
    ADD CONSTRAINT FK_student_group FOREIGN KEY (id_group)
        REFERENCES `group` (id_group);

-- 2. Выдать оценки студентов по информатике, если они обучаются данному предмету.
-- Оформить выдачу данных с использованием view.

DROP VIEW IF EXISTS it_student_mark;

CREATE VIEW it_student_mark AS
SELECT st.`name`, m.mark 
FROM mark m
	JOIN lesson l ON l.id_lesson = m.id_lesson
    JOIN `subject` s ON s.id_subject = l.id_subject AND s.`name` = 'Информатика'
    JOIN student st ON st.id_student = m.id_student;

SELECT * FROM it_student_mark;

-- 3. Дать информацию о должниках с указанием фамилии студента и названия предмета.
-- Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе.
-- Оформить в виде процедуры, на входе идентификатор группы.

DROP PROCEDURE IF EXISTS students_debtor_procedure;

DELIMITER //
CREATE PROCEDURE students_debtor_procedure (IN id_group INT)
BEGIN
	SELECT st.`name`, sub.`name`, MAX(m.mark) AS max_mark
	FROM student st
		LEFT JOIN lesson l ON l.id_group = st.id_group
		LEFT JOIN `subject` sub ON sub.id_subject = l.id_subject
		LEFT JOIN mark m ON m.id_lesson = l.id_lesson AND m.id_student = st.id_student
	WHERE st.id_group = id_group
	GROUP BY st.`name`, sub.`name`
	HAVING max_mark IS NULL
	ORDER BY st.`name`, sub.`name`;
END//
DELIMITER ;

CALL students_debtor_procedure(2);

-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов.

SELECT sub.`name`, COUNT(DISTINCT st.id_student) AS student_amount, AVG(m.mark) AS average_mark
FROM lesson l
	JOIN `group` g ON g.id_group = l.id_group
    JOIN student st ON st.id_group = g.id_group
    JOIN `subject` sub ON sub.id_subject = l.id_subject
    JOIN mark m ON m.id_lesson = l.id_lesson
GROUP BY l.id_subject
HAVING student_amount > 35;

-- 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты.
-- При отсутствии оценки заполнить значениями NULL поля оценки.

DROP TABLE IF EXISTS vm_student_subject_mark;
CREATE TEMPORARY TABLE IF NOT EXISTS vm_student_subject_mark
SELECT id_student, id_subject, mark, `date`
FROM mark m
	JOIN (
		SELECT id_lesson, id_subject, `date`
        FROM lesson l
			JOIN `group` g ON g.id_group = l.id_group
		WHERE g.`name` = 'ВМ'
    ) AS vm_lesson ON vm_lesson.id_lesson = m.id_lesson;

DROP TABLE IF EXISTS vm_student_subject;
CREATE TEMPORARY TABLE IF NOT EXISTS vm_student_subject
SELECT st.id_student, st.`name` AS student_name , subject_name, vm_subject.group_name
FROM student st
	LEFT JOIN (
		SELECT sub.id_subject, sub.`name` AS subject_name, g.`name` AS group_name, g.id_group
		FROM lesson l
			JOIN `group` g ON g.id_group = l.id_group
			JOIN `subject` sub ON sub.id_subject = l.id_subject
		WHERE g.`name` = 'ВМ'
		GROUP BY sub.`name`
	) AS vm_subject ON vm_subject.id_group = st.id_group
WHERE vm_subject.id_subject IS NOT NULL
ORDER BY st.`name`, vm_subject.subject_name;

SELECT group_name, student_name, subject_name, mark, `date`
FROM vm_student_subject vm_st_sub
	LEFT JOIN vm_student_subject_mark vm_st_sub_m ON vm_st_sub_m.id_student = vm_st_sub.id_student;

DROP TABLE IF EXISTS vm_student_subject_mark;
DROP TABLE IF EXISTS vm_student_subject;

-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.

 SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS `ps_bd-id_mark`;
CREATE TEMPORARY TABLE `ps_bd-id_mark`
SELECT id_mark
FROM lesson l
	JOIN `subject` sub ON sub.id_subject = l.id_subject
	JOIN `group` g ON g.id_group = l.id_group
	JOIN mark m ON m.id_lesson = l.id_lesson
WHERE sub.`name` = 'БД' AND g.`name` = 'ПС' AND MONTH(date) = 5 AND DAYOFMONTH(date) = 6 AND mark < 5;

UPDATE mark m
SET m.mark = m.mark + 1
WHERE m.id_mark IN (SELECT * FROM `ps_bd-id_mark`);

 SET SQL_SAFE_UPDATES = 1;

-- 7. Добавить необходимые индексы.

CREATE INDEX IX_group_id_group
    ON `group` (id_group);

CREATE INDEX IX_lesson_id_lesson
    ON lesson (id_lesson);

CREATE INDEX IX_lesson_id_group
    ON lesson (id_group);

CREATE INDEX IX_lesson_id_subject
    ON lesson (id_subject);
    
CREATE INDEX IX_mark_id_lesson
    ON mark (id_lesson);
    
CREATE INDEX IX_mark_id_student
    ON mark (id_student);
    
CREATE INDEX IX_subject_id_subject
    ON `subject` (id_subject);

CREATE INDEX IX_student_id_student
    ON student (id_student);

CREATE INDEX IX_student_id_group
    ON student (id_group);
