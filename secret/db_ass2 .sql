-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2020 at 12:18 PM
-- Server version: 10.4.16-MariaDB
-- PHP Version: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ass2`
--

-- --------------------------------------------------------

--
-- Table structure for table `bolt`
--

CREATE TABLE `bolt` (
  `categoryCode` int(10) UNSIGNED NOT NULL,
  `boltCode` int(10) UNSIGNED NOT NULL,
  `length` float NOT NULL CHECK (`length` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bolt`
--

INSERT INTO `bolt` (`categoryCode`, `boltCode`, `length`) VALUES
(1, 1, 1.5),
(2, 1, 3.5);

--
-- Triggers `bolt`
--
DELIMITER $$
CREATE TRIGGER `quantityBolt` AFTER INSERT ON `bolt` FOR EACH ROW UPDATE category SET quantity = quantity + 1 WHERE categoryCode = NEW.categoryCode
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryCode` int(10) UNSIGNED NOT NULL,
  `categoryName` varchar(70) NOT NULL,
  `color` varchar(20) NOT NULL,
  `quantity` int(10) DEFAULT 0,
  `r_supplierCode` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryCode`, `categoryName`, `color`, `quantity`, `r_supplierCode`) VALUES
(1, 'Cotton', 'Brown', 1, 1),
(2, 'Kaki', 'White', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `category_sellingprice`
--

CREATE TABLE `category_sellingprice` (
  `categoryCode` int(10) UNSIGNED NOT NULL,
  `price` int(6) UNSIGNED NOT NULL,
  `date` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category_sellingprice`
--

INSERT INTO `category_sellingprice` (`categoryCode`, `price`, `date`) VALUES
(1, 50000, '2020-11-29'),
(2, 60000, '2020-11-04'),
(2, 70000, '2020-11-27'),
(2, 100000, '2020-12-01');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerCode` int(10) UNSIGNED NOT NULL,
  `customerFirstName` varchar(70) NOT NULL,
  `customerLastName` varchar(70) NOT NULL,
  `address` varchar(70) NOT NULL,
  `arrearage` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerCode`, `customerFirstName`, `customerLastName`, `address`, `arrearage`) VALUES
(1, 'Thien', 'Nhan Ngoc', 'Bình Tân', 100000);

-- --------------------------------------------------------

--
-- Table structure for table `customer_order`
--

CREATE TABLE `customer_order` (
  `orderCode` int(10) UNSIGNED NOT NULL,
  `totalPrice` float UNSIGNED NOT NULL DEFAULT 0,
  `r_customerCode` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_order`
--

INSERT INTO `customer_order` (`orderCode`, `totalPrice`, `r_customerCode`) VALUES
(1, 320000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer_partialpayment`
--

CREATE TABLE `customer_partialpayment` (
  `customerCode` int(10) UNSIGNED NOT NULL,
  `date` date DEFAULT curdate(),
  `money` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `customer_partialpayment`
--
DELIMITER $$
CREATE TRIGGER `calc_unpaidDebt_insert` AFTER INSERT ON `customer_partialpayment` FOR EACH ROW UPDATE customer 
SET arrearage = arrearage - NEW.money
WHERE customer.customerCode = NEW.customerCode
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `calc_unpaidDebt_update` AFTER UPDATE ON `customer_partialpayment` FOR EACH ROW
BEGIN
    IF !(NEW.money <=> OLD.money) THEN
        UPDATE customer 
        SET arrearage = arrearage - (NEW.money - OLD.money)
        WHERE customer.customerCode = NEW.customerCode;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_phonenumber`
--

CREATE TABLE `customer_phonenumber` (
  `customerCode` int(10) UNSIGNED NOT NULL,
  `phoneNumber` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `employeeCode` int(10) UNSIGNED NOT NULL,
  `employeeFirstName` varchar(70) NOT NULL,
  `employeeLastName` varchar(70) NOT NULL,
  `genre` varchar(1) NOT NULL CHECK (`genre` in ('F','M','B')),
  `address` varchar(70) NOT NULL,
  `phoneNumber` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`employeeCode`, `employeeFirstName`, `employeeLastName`, `genre`, `address`, `phoneNumber`) VALUES
(1, 'Khoa', 'Nguyen Viet', 'M', 'Quận 7', '123456789');

-- --------------------------------------------------------

--
-- Table structure for table `relationcontain_containbolt`
--

CREATE TABLE `relationcontain_containbolt` (
  `categoryCode` int(10) UNSIGNED NOT NULL,
  `boltCode` int(10) UNSIGNED NOT NULL,
  `orderCode` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `relationcontain_containbolt`
--

INSERT INTO `relationcontain_containbolt` (`categoryCode`, `boltCode`, `orderCode`) VALUES
(1, 1, 1),
(2, 1, 1);

--
-- Triggers `relationcontain_containbolt`
--
DELIMITER $$
CREATE TRIGGER `calc_totalPrice` AFTER INSERT ON `relationcontain_containbolt` FOR EACH ROW BEGIN
    DECLARE length FLOAT;
    DECLARE price INT(10) DEFAULT 0;
    SET length = (
        SELECT bolt.length
        FROM bolt
        WHERE NEW.categorycode = bolt.categoryCode and NEW.boltcode = bolt.boltCode
        LIMIT 1
    );
    SET price = (
        SELECT category_sellingprice.price
        FROM category
        JOIN category_sellingprice ON category_sellingprice.categoryCode = category.categoryCode
        WHERE category.categoryCode = NEW.categoryCode and category_sellingprice.date <= curdate()
        ORDER BY category_sellingprice.date DESC LIMIT 1
    );
    UPDATE customer_order SET customer_order.totalPrice = customer_order.totalPrice + price*length WHERE customer_order.orderCode = NEW.orderCode;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `relationprocess_processorder`
--

CREATE TABLE `relationprocess_processorder` (
  `orderCode` int(10) UNSIGNED NOT NULL,
  `employeeCode` int(10) UNSIGNED NOT NULL,
  `time` time DEFAULT curtime(),
  `date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `relationprocess_processorder`
--

INSERT INTO `relationprocess_processorder` (`orderCode`, `employeeCode`, `time`, `date`) VALUES
(1, 1, '09:33:59', '2020-11-29');

-- --------------------------------------------------------

--
-- Table structure for table `relationprovide_provideinformation`
--

CREATE TABLE `relationprovide_provideinformation` (
  `categoryCode` int(10) UNSIGNED NOT NULL,
  `purchasePrice` int(6) UNSIGNED NOT NULL,
  `quantity` int(10) NOT NULL CHECK (`quantity` > 0),
  `date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplierCode` int(10) UNSIGNED NOT NULL,
  `supplierName` varchar(70) NOT NULL,
  `address` varchar(70) DEFAULT NULL,
  `bankAccount` varchar(22) NOT NULL,
  `taxCode` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplierCode`, `supplierName`, `address`, `bankAccount`, `taxCode`) VALUES
(1, 'Silk Agency', '12/34 Gò Dầu, Tân Phú', '598648639579432', '348753487658');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_phonenumber`
--

CREATE TABLE `supplier_phonenumber` (
  `supplierCode` int(10) UNSIGNED NOT NULL,
  `phoneNumber` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bolt`
--
ALTER TABLE `bolt`
  ADD PRIMARY KEY (`categoryCode`,`boltCode`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryCode`),
  ADD KEY `category_fk_supplier` (`r_supplierCode`);

--
-- Indexes for table `category_sellingprice`
--
ALTER TABLE `category_sellingprice`
  ADD PRIMARY KEY (`categoryCode`,`date`),
  ADD KEY `curentprice_fk_category` (`categoryCode`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerCode`);

--
-- Indexes for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD PRIMARY KEY (`orderCode`),
  ADD KEY `order_fk_employee` (`r_customerCode`);

--
-- Indexes for table `customer_partialpayment`
--
ALTER TABLE `customer_partialpayment`
  ADD PRIMARY KEY (`customerCode`);

--
-- Indexes for table `customer_phonenumber`
--
ALTER TABLE `customer_phonenumber`
  ADD PRIMARY KEY (`customerCode`,`phoneNumber`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employeeCode`);

--
-- Indexes for table `relationcontain_containbolt`
--
ALTER TABLE `relationcontain_containbolt`
  ADD PRIMARY KEY (`categoryCode`,`boltCode`),
  ADD KEY `relationContain_containBolt_fk_order` (`orderCode`);

--
-- Indexes for table `relationprocess_processorder`
--
ALTER TABLE `relationprocess_processorder`
  ADD PRIMARY KEY (`orderCode`,`employeeCode`),
  ADD KEY `relationProcess_processsOrder_fk_employee` (`employeeCode`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplierCode`);

--
-- Indexes for table `supplier_phonenumber`
--
ALTER TABLE `supplier_phonenumber`
  ADD PRIMARY KEY (`supplierCode`,`phoneNumber`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `categoryCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `orderCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `employeeCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplierCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bolt`
--
ALTER TABLE `bolt`
  ADD CONSTRAINT `bolt_fk_category` FOREIGN KEY (`categoryCode`) REFERENCES `category` (`categoryCode`);

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `category_fk_supplier` FOREIGN KEY (`r_supplierCode`) REFERENCES `supplier` (`supplierCode`);

--
-- Constraints for table `category_sellingprice`
--
ALTER TABLE `category_sellingprice`
  ADD CONSTRAINT `curentprice_fk_category` FOREIGN KEY (`categoryCode`) REFERENCES `category` (`categoryCode`);

--
-- Constraints for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD CONSTRAINT `order_fk_employee` FOREIGN KEY (`r_customerCode`) REFERENCES `employee` (`employeeCode`);

--
-- Constraints for table `customer_partialpayment`
--
ALTER TABLE `customer_partialpayment`
  ADD CONSTRAINT `customer_partialPayment_fk_customer` FOREIGN KEY (`customerCode`) REFERENCES `customer` (`customerCode`) ON DELETE CASCADE;

--
-- Constraints for table `customer_phonenumber`
--
ALTER TABLE `customer_phonenumber`
  ADD CONSTRAINT `customer_phoneNumber_fk_customer` FOREIGN KEY (`customerCode`) REFERENCES `customer` (`customerCode`) ON DELETE CASCADE;

--
-- Constraints for table `relationcontain_containbolt`
--
ALTER TABLE `relationcontain_containbolt`
  ADD CONSTRAINT `relationContain_containBolt_fk_bolt` FOREIGN KEY (`categoryCode`,`boltCode`) REFERENCES `bolt` (`categoryCode`, `boltCode`) ON DELETE CASCADE,
  ADD CONSTRAINT `relationContain_containBolt_fk_order` FOREIGN KEY (`orderCode`) REFERENCES `customer_order` (`orderCode`);

--
-- Constraints for table `relationprocess_processorder`
--
ALTER TABLE `relationprocess_processorder`
  ADD CONSTRAINT `relationProcess_processOrder_fk_order` FOREIGN KEY (`orderCode`) REFERENCES `customer_order` (`orderCode`) ON DELETE CASCADE,
  ADD CONSTRAINT `relationProcess_processsOrder_fk_employee` FOREIGN KEY (`employeeCode`) REFERENCES `employee` (`employeeCode`) ON DELETE CASCADE;

--
-- Constraints for table `supplier_phonenumber`
--
ALTER TABLE `supplier_phonenumber`
  ADD CONSTRAINT `suplier_phonenumber_fk_supplier` FOREIGN KEY (`supplierCode`) REFERENCES `supplier` (`supplierCode`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
