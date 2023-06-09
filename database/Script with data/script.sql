USE [master]
GO
/****** Object:  Database [Authenticate]    Script Date: 5/16/2023 2:24:24 AM ******/
CREATE DATABASE [Authenticate]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Authenticate', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Authenticate.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Authenticate_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Authenticate_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Authenticate] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Authenticate].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Authenticate] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Authenticate] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Authenticate] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Authenticate] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Authenticate] SET ARITHABORT OFF 
GO
ALTER DATABASE [Authenticate] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Authenticate] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Authenticate] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Authenticate] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Authenticate] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Authenticate] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Authenticate] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Authenticate] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Authenticate] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Authenticate] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Authenticate] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Authenticate] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Authenticate] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Authenticate] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Authenticate] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Authenticate] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Authenticate] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Authenticate] SET RECOVERY FULL 
GO
ALTER DATABASE [Authenticate] SET  MULTI_USER 
GO
ALTER DATABASE [Authenticate] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Authenticate] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Authenticate] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Authenticate] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Authenticate] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Authenticate] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Authenticate', N'ON'
GO
ALTER DATABASE [Authenticate] SET QUERY_STORE = OFF
GO
USE [Authenticate]
GO
/****** Object:  Table [dbo].[TBL_LogFailedLogin]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_LogFailedLogin](
	[LFL_ID] [int] IDENTITY(1,1) NOT NULL,
	[LFL_USER] [nvarchar](20) NULL,
	[LFL_PASS] [nvarchar](20) NULL,
	[LFL_DATETIME] [nvarchar](20) NOT NULL,
	[LFL_STATUS] [bit] NOT NULL,
	[LFL_IP] [nvarchar](20) NOT NULL,
	[LFL_OS] [nvarchar](20) NULL,
	[LFL_BROWSER] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_TOKEN]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_TOKEN](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NULL,
	[UserName] [nvarchar](4000) NULL,
	[Token] [nvarchar](max) NOT NULL,
	[Expire_Date] [datetime] NULL,
	[Info] [nvarchar](max) NULL,
	[Create_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Token] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_USERS]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_USERS](
	[USERS_UNAME] [nvarchar](20) NOT NULL,
	[USERS_UID] [int] IDENTITY(1,1) NOT NULL,
	[USERS_PASS] [nvarchar](20) NOT NULL,
	[USERS_ROLEID] [int] NOT NULL,
	[USERS_IS_ENABLED] [bit] NOT NULL,
	[flag] [bit] NULL,
 CONSTRAINT [PK_UsersTB] PRIMARY KEY CLUSTERED 
(
	[USERS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[TBL_USERS] ON 

INSERT [dbo].[TBL_USERS] ([USERS_UNAME], [USERS_UID], [USERS_PASS], [USERS_ROLEID], [USERS_IS_ENABLED], [flag]) VALUES (N'admin', 1, N'123', 0, 0, NULL)
SET IDENTITY_INSERT [dbo].[TBL_USERS] OFF
GO
ALTER TABLE [dbo].[TBL_TOKEN] ADD  CONSTRAINT [DF_Token_CreateDate]  DEFAULT (getdate()) FOR [Create_Date]
GO
ALTER TABLE [dbo].[TBL_USERS] ADD  CONSTRAINT [DF_UsersTB_UName]  DEFAULT ((0)) FOR [USERS_UNAME]
GO
ALTER TABLE [dbo].[TBL_USERS] ADD  CONSTRAINT [DF_UsersTB_Pass]  DEFAULT ((0)) FOR [USERS_PASS]
GO
ALTER TABLE [dbo].[TBL_USERS] ADD  CONSTRAINT [DF_UsersTB_RoleID]  DEFAULT ((0)) FOR [USERS_ROLEID]
GO
ALTER TABLE [dbo].[TBL_USERS] ADD  CONSTRAINT [DF_UsersTB_IsEnabled]  DEFAULT ((0)) FOR [USERS_IS_ENABLED]
GO
/****** Object:  StoredProcedure [dbo].[SPAuthenticateUserMobile]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		vahid askarifar
-- Create date: 1398/10/03
-- Description:	AuthenticateUser
-- =============================================
create PROCEDURE [dbo].[SPAuthenticateUserMobile]
	@txt_UserName		nvarchar(20),
	@txt_Password		nvarchar(20)
AS
BEGIN
	SELECT * FROM TBL_USERS  WHERE (USERS_UNAME = @txt_UserName) AND (USERS_PASS = @txt_Password)  
END

GO
/****** Object:  StoredProcedure [dbo].[SPCountInvalidLoginMobile]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		VAHID ASKARIFAR	
-- Create date: 1398/09/30
-- Description:	 CountInvalidLoginIP
-- =============================================
CREATE PROCEDURE [dbo].[SPCountInvalidLoginMobile]

	       @ReqDate  nvarchar(20),
           @ReqIP  nvarchar(20),
		   @ReqUser nvarchar(50)
AS
BEGIN
DECLARE @Result1	int
if (@ReqIP = "0" )set @ReqIP = null
set @Result1 = (select COUNT(LFL_ID) as "count" FROM TBL_LogFailedLogin
	where LFL_IP = COALESCE(@ReqIP ,LFL_IP )
	and SUBSTRING ( LFL_DATETIME ,1 , 8 )= SUBSTRING ( @ReqDate ,1 , 8 )
	)
	select @result1 as Result
end

GO
/****** Object:  StoredProcedure [dbo].[SPLoadToken]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		vahid askari
-- Create date: 1398/10/03
-- Description:	SPLoadToken
-- =============================================
create PROCEDURE [dbo].[SPLoadToken]
	@Token		nvarchar(50),	
	@DateNow		datetime
AS
BEGIN
     select * from TBL_TOKEN where Token = @Token and Expire_Date > @DateNow
END
GO
/****** Object:  StoredProcedure [dbo].[SPNewLogFailedLogin]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Ali Seyyedein
-- Create date: 1393/08/18
-- Description:	Add New LogFailedLogin
-- =============================================
CREATE PROCEDURE [dbo].[SPNewLogFailedLogin]

	       @LFL_USER  nvarchar(20),
           @LFL_PASS  nvarchar(20),
           @LFL_DATETIME  nvarchar(20),
           @LFL_STATUS  bit ,
           @LFL_IP  nvarchar(20),
           @LFL_OS  nvarchar(20),
           @LFL_BROWSER  nvarchar(20) 
AS
BEGIN
INSERT INTO [TBL_LogFailedLogin]
           ([LFL_USER]
           ,[LFL_PASS]
           ,[LFL_DATETIME]
           ,[LFL_STATUS]
           ,[LFL_IP]
           ,[LFL_OS]
           ,[LFL_BROWSER])
     VALUES
	     ( @LFL_USER  ,
           @LFL_PASS  ,
           @LFL_DATETIME  ,
           @LFL_STATUS  ,
           @LFL_IP  ,
           @LFL_OS  ,
           @LFL_BROWSER)           
end

GO
/****** Object:  StoredProcedure [dbo].[SPNewToken]    Script Date: 5/16/2023 2:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		vahid askarifar
-- Create date: 1398/10/03
-- Description:	Add New Customer
-- =============================================
create PROCEDURE [dbo].[SPNewToken]
	@UserID		nvarchar(20),
	@UserName	nvarchar(50),
	@Token		nvarchar(max),	
	@ExpireDate		datetime,
	@Info nvarchar(max),
	@CreateDate datetime
AS
BEGIN

	   INSERT INTO TBL_TOKEN(UserID,UserName,Token,Expire_Date,Info,Create_Date)values(@UserID,@UserName,@Token,@ExpireDate,@Info,@CreateDate)   
	       	       
	
end

GO
USE [master]
GO
ALTER DATABASE [Authenticate] SET  READ_WRITE 
GO
