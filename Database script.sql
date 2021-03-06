USE [master]
GO
/****** Object:  Database [CourseReport]    Script Date: 10.05.2021 16:20:57 ******/
CREATE DATABASE [CourseReport]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CourseReport', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CourseReport.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CourseReport_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CourseReport_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CourseReport] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CourseReport].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CourseReport] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CourseReport] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CourseReport] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CourseReport] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CourseReport] SET ARITHABORT OFF 
GO
ALTER DATABASE [CourseReport] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CourseReport] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CourseReport] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CourseReport] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CourseReport] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CourseReport] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CourseReport] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CourseReport] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CourseReport] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CourseReport] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CourseReport] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CourseReport] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CourseReport] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CourseReport] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CourseReport] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CourseReport] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CourseReport] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CourseReport] SET RECOVERY FULL 
GO
ALTER DATABASE [CourseReport] SET  MULTI_USER 
GO
ALTER DATABASE [CourseReport] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CourseReport] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CourseReport] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CourseReport] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CourseReport] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CourseReport] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'CourseReport', N'ON'
GO
ALTER DATABASE [CourseReport] SET QUERY_STORE = OFF
GO
USE [CourseReport]
GO
/****** Object:  UserDefinedTableType [dbo].[EnrollmentType]    Script Date: 10.05.2021 16:20:57 ******/
CREATE TYPE [dbo].[EnrollmentType] AS TABLE(
	[EnrollmentID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL
)
GO
/****** Object:  Table [dbo].[Course]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [varchar](5) NOT NULL,
	[Description] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[StudentID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrollment]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollment](
	[EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateID] [varchar](50) NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateID] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[EnrollmentReport]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EnrollmentReport] as

	select
		t1.CourseID,
		t1.EnrollmentID,
		t1.StudentID,
		t2.CourseCode,
		t2.[Description],
		t3.FirstName,
		t3.LastName
	from
		Enrollment as t1
	INNER JOIN
		Course as t2 on t1.CourseID = t2.CourseID
	INNER JOIN
		Student as t3 on t3.StudentID = t1.StudentID
GO
ALTER TABLE [dbo].[Enrollment] ADD  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Enrollment] ADD  DEFAULT ('system') FOR [CreateID]
GO
ALTER TABLE [dbo].[Enrollment] ADD  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Enrollment] ADD  DEFAULT ('system') FOR [UpdateID]
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([StudentID])
GO
/****** Object:  StoredProcedure [dbo].[Course_GetList]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Course_GetList]
AS
	SELECT
		CourseID,
		CourseCode,
		[Description]
	from
		[dbo].[Course]
GO
/****** Object:  StoredProcedure [dbo].[Enrollment_GetList]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Enrollment_GetList]
AS
	SELECT
		EnrollmentID,
		StudentID,
		CourseID
	FROM
	[dbo].Enrollment
GO
/****** Object:  StoredProcedure [dbo].[Enrollment_Upsert]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Enrollment_Upsert]
	@EnrollmentType [EnrollmentType] READONLY,
	@UserID VARCHAR(50)
as
	MERGE INTO Enrollment as TARGET
	USING
	(
		SELECT 
			EnrollmentID,
			StudentID,
			CourseID,
			@UserID UpdateID,
			GETDATE() [UpdateDate],
			@UserID CreateID,
			GETDATE() [CreateDate]
		FROM
			@EnrollmentType
	) AS SOURCE
	ON
	(
		TARGET.[EnrollmentID] = SOURCE.[EnrollmentID]
	)
	WHEN
		MATCHED THEN
			UPDATE SET
				TARGET.[StudentID] = SOURCE.[StudentID],
				TARGET.[CourseID] = SOURCE.[CourseID],
				TARGET.[UpdateDate] = SOURCE.[UpdateDate],
				TARGET.[UpdateID] = SOURCE.[UpdateID]
		WHEN NOT MATCHED BY TARGET then
			INSERT (
				[StudentID],
				[CourseID],
				[CreateDate],
				[CreateID],
				[UpdateDate],
				[UpdateID]
			)
			VALUES
			(
				SOURCE.[StudentID],
				SOURCE.[CourseID],
				SOURCE.[CreateDate],
				SOURCE.[CreateID],
				SOURCE.[UpdateDate],
				SOURCE.[UpdateID]
			);
GO
/****** Object:  StoredProcedure [dbo].[EnrollmentReport_GetList]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EnrollmentReport_GetList]
AS
	SELECT
	*
	FROM [dbo].EnrollmentReport
GO
/****** Object:  StoredProcedure [dbo].[Student_GetList]    Script Date: 10.05.2021 16:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Student_GetList]
AS
	SELECT
		StudentID,
		FirstName,
		LastName
	FROM
		[dbo].Student
GO
USE [master]
GO
ALTER DATABASE [CourseReport] SET  READ_WRITE 
GO
