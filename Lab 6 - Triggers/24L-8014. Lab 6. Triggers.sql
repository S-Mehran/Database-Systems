select * from Students
select * from Courses
select * from Instructors
select * from Registration
select * from Semester
select * from Courses_Semester
select * from ChallanForm

--FUNCTIONALITY 1
create trigger stud_trig 
on Students
instead of delete 
AS BEGIN
print'You cannot delete this data'
end;


DELETE FROM Students WHERE Name='Ali';


--FUNCTIONALITY 2
create trigger new_trig 
on Courses
instead of INSERT 
AS BEGIN
print'You cannot insert this data'
end;


INSERT INTO Students (RollNo, Name)
VALUES (10, 'Arslan');



--FUNCTIONALITY 3
create table Notifyy
(
NotificationID INT PRIMARY KEY IDENTITY(1,1),
StudentID int,
NotificationString VARCHAR(40)
);


CREATE TRIGGER trg_NotifyCourseRegistration
ON Registration
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @RollNumber INT;
    DECLARE @CourseID INT;
    DECLARE @Action NVARCHAR(10);

 
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        SET @Action = 'INSERT';
        SELECT @RollNumber = RollNumber, @CourseID = CourseID FROM INSERTED;
    END
    ELSE IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        SET @Action = 'DELETE';
        SELECT @RollNumber = RollNumber, @CourseID = CourseID FROM DELETED;
    END

 
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO Notifyy (StudentID, NotificationString)
        VALUES (@RollNumber, 'Your registration for course ' + CAST(@CourseID AS NVARCHAR) + ' was successful.');
    END
    ELSE IF @Action = 'DELETE'
    BEGIN
        INSERT INTO Notifyy (StudentID, NotificationString)
        VALUES (@RollNumber, 'Your registration for course ' + CAST(@CourseID AS NVARCHAR) + ' was not successful.');
    END
END;


INSERT INTO Registration (Semester, RollNumber, CourseID, Section, GPA)
VALUES ('Fall2016', 5, 101, 'A', 3.5);



--FUNCTIONALITY 4

CREATE TRIGGER trg_CheckFeeCharges
ON Registration
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @RollNumber VARCHAR(7);
    DECLARE @FeeChargesDue FLOAT;

    SELECT @RollNumber = RollNumber FROM INSERTED;


    SELECT @FeeChargesDue = TotalDues FROM ChallanForm WHERE RollNumber = @RollNumber and ChallanForm.[Status] = 'Pending';


    IF @FeeChargesDue > 20000
    BEGIN
        PRINT 'Registration not allowed: Fee charges due exceed 20,000.';
    END
    ELSE
    BEGIN
        INSERT INTO Registration (Semester, RollNumber, CourseID, Section, GPA)
        SELECT Semester, RollNumber, CourseID, Section, GPA FROM INSERTED;
        PRINT 'Registration successful.';
    END
END;


INSERT INTO ChallanForm (Semester, RollNumber, TotalDues, [Status])
VALUES ('Fall2016', 1, 25000, 'Pending'),
     ('Fall2016', 3, 15000, 'Pending'); 


--FUNCTIONALITY 5

CREATE TRIGGER trg_PreventDeleteCourseSemester
ON Courses_Semester
AFTER DELETE
AS
BEGIN
    DECLARE @AvailableSeats INT;
    DECLARE @Semester INT;

    
    SELECT @AvailableSeats = AvailableSeats, @Semester = Semester FROM DELETED;

    
    IF @AvailableSeats < 10
    BEGIN
        PRINT 'Not possible';
    
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        PRINT 'Successfully deleted';
    END
END;




--FUNCTIONALITY 6

CREATE TRIGGER trg_AntiModify
ON DATABASE
FOR ALTER_TABLE, DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML;
    DECLARE @ObjectName NVARCHAR(128);

    SET @EventData = EVENTDATA();
    SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)');

    IF @ObjectName = 'Instructors'
    BEGIN
        PRINT 'Modification or dropping of the Instructors table is not allowed.';
        ROLLBACK;
    END
END;


