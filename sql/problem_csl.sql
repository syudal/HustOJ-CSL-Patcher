-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- 생성 시간: 23-08-24 04:03
-- 서버 버전: 10.6.12-MariaDB-0ubuntu0.22.04.1
-- PHP 버전: 8.1.2-1ubuntu2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 데이터베이스: `jol`
--
CREATE DATABASE IF NOT EXISTS `jol` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `jol`;

-- --------------------------------------------------------

--
-- 테이블 구조 `problem_csl`
--

DROP TABLE IF EXISTS `problem_csl`;
CREATE TABLE `problem_csl` (
  `problem_id` int(11) NOT NULL,
  `front` text NOT NULL,
  `rear` text NOT NULL,
  `bann` varchar(30) DEFAULT NULL,
  `credits` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 덤프된 테이블의 인덱스
--

--
-- 테이블의 인덱스 `problem_csl`
--
ALTER TABLE `problem_csl`
  ADD PRIMARY KEY (`problem_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
