USE [master]
GO
/****** Object:  Database [GISData]    Script Date: 2021-07-10 1:50:41 PM ******/
CREATE DATABASE [GISData]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'GISDATA_dat', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\GISDATA.mdf' , SIZE = 9298688KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'GISDATA_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\GISDATA_log.mdf' , SIZE = 1024KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [GISData] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GISData].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [GISData] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GISData] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GISData] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GISData] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GISData] SET ARITHABORT OFF 
GO
ALTER DATABASE [GISData] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [GISData] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [GISData] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GISData] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GISData] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GISData] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GISData] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GISData] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GISData] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GISData] SET  DISABLE_BROKER 
GO
ALTER DATABASE [GISData] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GISData] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GISData] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GISData] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GISData] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GISData] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GISData] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GISData] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [GISData] SET  MULTI_USER 
GO
ALTER DATABASE [GISData] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [GISData] SET DB_CHAINING OFF 
GO
ALTER DATABASE [GISData] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [GISData] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [GISData] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'GISData', N'ON'
GO
ALTER DATABASE [GISData] SET QUERY_STORE = ON
GO
ALTER DATABASE [GISData] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = ALL, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
ALTER DATABASE [GISData] SET  READ_WRITE 
GO
