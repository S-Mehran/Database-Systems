CREATE PROCEDURE RegisterStudent
@RollNumber VARCHAR(7),@CourseID INT,@Semester VARCHAR(15),@Section CHAR(1),@CGPA FLOAT
AS BEGIN
BEGIN TRANSACTION;

IF @CGPA < 2.5
BEGIN
  PRINT 'You can only enroll in subjects that you can improve.';
  ROLLBACK TRANSACTION;
END
ELSE
BEGIN
  INSERT INTO Registration (Semester, RollNumber, CourseID, Section, GPA)
  VALUES (@Semester, @RollNumber, @CourseID, @Section, @CGPA);

COMMIT TRANSACTION;
END
END;
GO

EXEC RegisterStudent 
    @RollNumber = '1', 
    @CourseID = 20, 
    @Semester = 'Fall2016', 
    @Section = 'A', 
    @CGPA = 3.3;


EXEC RegisterStudent 
    @RollNumber = '8', 
    @CourseID = 30, 
    @Semester = 'Spring2017', 
    @Section = 'B', 
    @CGPA = 2.8;



EXEC RegisterStudent 
    @RollNumber = '1', 
    @CourseID = 20, 
    @Semester = 'Fall2016', 
    @Section = 'A', 
    @CGPA = 2.3;




	
select * from Students
select * from Courses
select * from Instructors
select * from Registration
select * from Semester
select * from Courses_Semester
select * from ChallanForm



Question:
Create a procedure for student registration in some course the procedure must check 
that the CGPA of the student if the CGPA is less than 2.5 the transaction must 
rollback and the record must not be stored and a message must be displayed that 
he can only enroll in subjects that he can improve however if the student’s CGPA
is greater than 2.5 he can enroll in any subject he wants in this case the 
transaction should be committed.  Assume that the enrollment can only be done 
through stored procedure.