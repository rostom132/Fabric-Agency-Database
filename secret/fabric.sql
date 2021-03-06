-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2020 at 04:44 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fabric`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_category` (IN `i_categoryName` VARCHAR(70), IN `i_categoryColor` VARCHAR(20), IN `i_supplierCode` INT(10), IN `i_purchasePrice` INT(6), IN `i_quantity` INT(10), IN `i_sellingPrice` INT(6))  BEGIN
    DECLARE inserted_category_id INT(10);
    INSERT INTO category (`categoryName`, `color`,`r_supplierCode`) VALUES(i_categoryName, i_categoryColor, i_supplierCode);
    SELECT last_insert_id() INTO inserted_category_id;
    INSERT INTO relationprovide_provideInformation (`categoryCode`, `purchasePrice`, `quantity`) VALUES (inserted_category_id, i_purchasePrice, i_quantity);
    INSERT INTO category_sellingprice (`categoryCode`, `price`) VALUES (inserted_category_id, i_sellingPrice);
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_order` (IN `i_customerCode` INT(10), IN `i_employeeCode` INT(10), IN `i_categoryCode` INT(10), IN `i_boltCode` INT(10))  BEGIN
    DECLARE inserted_order_id INT(10);
    INSERT INTO customer_order (`r_customerCode`) VALUES(i_customerCode);
    SET inserted_order_id = (SELECT last_insert_id());
    INSERT INTO relationprocess_processorder (`orderCode`, `employeeCode`) VALUES (inserted_order_id, i_employeeCode);
    INSERT INTO relationcontain_containbolt (`categoryCode`, `boltCode`, `orderCode`) VALUES (i_categoryCode, i_boltCode, inserted_order_id);
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_supplier` (IN `supplierName` VARCHAR(70), IN `address` VARCHAR(70), IN `bankAccount` VARCHAR(22), IN `taxCode` VARCHAR(50), OUT `inserted_id` INT(10))  BEGIN
  INSERT INTO supplier (`supplierName`, `address`, `bankAccount`, `taxCode`) VALUES (supplierName, address, bankAccount, taxCode);
  SELECT last_insert_id() INTO inserted_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCategoriesBySupplier` (IN `input_supplierId` INT(10))  SELECT categoryCode as code,categoryName as name,color,quantity FROM category WHERE r_supplierCode = input_supplierId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerPhone` (IN `input_customerCode` INT(10))  SELECT customer_phonenumber.phoneNumber
FROM customer, customer_phonenumber
WHERE customer.customerCode = input_customerCode AND customer.customerCode = customer_phonenumber.customerCode$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderByName` (IN `filterName` VARCHAR(256))  SELECT orderCode, totalPrice, customerCode, CONCAT(customerLastName, " ", customerFirstName) as Name
FROM customer_order, customer 
WHERE customerCode = r_customerCode AND CONCAT(customerLastName, " ", customerFirstName) LIKE CONCAT("%", filterName, "%")$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderInfo` (IN `input_orderCode` INT(10))  SELECT input_orderCode as OrderID, customerCode, employee.employeeCode, CONCAT(customerLastName, " ", customerFirstName) as customerName, customer.address as customerAddress, CONCAT(employeeLastName, " ", employeeFirstName) as employeeName, employee.address as employeeAddress, employee.phoneNumber, date, time, totalPrice
FROM customer_order, customer, employee, relationprocess_processorder
WHERE customer_order.orderCode = input_orderCode AND customer.customerCode = customer_order.r_customerCode AND relationprocess_processorder.orderCode = customer_order.orderCode AND employee.employeeCode = relationprocess_processorder.employeeCode$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderList` (IN `input_orderCode` INT(10))  SELECT category.categoryCode, category.categoryName, color, bolt.boltCode, length
FROM customer_order, relationcontain_containbolt, bolt, category
WHERE customer_order.orderCode = input_orderCode AND customer_order.orderCode = relationcontain_containbolt.orderCode AND relationcontain_containbolt.categoryCode = bolt.categoryCode AND relationcontain_containbolt.boltCode = bolt.boltCode AND bolt.categoryCode = category.categoryCode$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSellingPrice` (IN `input_supplierId` INT(10))  SELECT categoryCode as code, price, date FROM category_sellingprice 
  NATURAL JOIN category
  WHERE category.r_supplierCode = input_supplierId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSupplierInfo` (IN `input_supplierId` INT(10))  SELECT supplierName as name, taxCode as tax, address, bankAccount as bank  FROM supplier WHERE supplierCode = input_supplierId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSupplierPhoneNumber` (IN `input_supplierId` INT(10))  SELECT phoneNumber FROM supplier_phonenumber WHERE supplierCode = input_supplierId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPhones` (IN `supplier` INT(10), IN `phonesArray` LONGTEXT)  BEGIN
    DECLARE _result longtext DEFAULT 'INSERT INTO supplier_phonenumber(supplierCode, phoneNumber) VALUES ';
    DECLARE _counter INT DEFAULT 0;
    
    SET @start = 'INSERT INTO supplier_phonenumber(supplierCode, phoneNumber) VALUES ';
    WHILE _counter < JSON_LENGTH(phonesArray) DO
        IF _counter != 0 THEN
            SET @start = CONCAT(@start, ', ');
        END IF;
        SET @start = CONCAT(@start,"('", supplier, "',", JSON_EXTRACT(phonesArray, CONCAT('$[',_counter,']')), ')');
        SET _counter = _counter + 1;
    END WHILE;
	
    PREPARE stmt FROM @start;
    EXECUTE stmt;                                                                
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sortSuppliers` (IN `startDate` DATE, IN `endDate` DATE)  BEGIN
  IF ((startDate is NULL OR startDate = "") AND (endDate is NULL or endDate = ""))
  THEN 
    SIGNAL SQLSTATE '42927' 
    SET MESSAGE_TEXT = 'Two parameters is not valid';
  ELSE 
    BEGIN
      IF (startDate is NULL OR startDate = "")
      THEN SET startDate = endDate;
      END IF;
      IF (endDate is NULL OR endDate = "")
      THEN SET endDate = curdate();
      END IF;
      SELECT supplier.supplierCode, supplier.supplierName, count(*) number_of_categories
      FROM category
      JOIN relationprovide_provideInformation as r_provideInformation ON category.categoryCode = r_provideInformation.categoryCode
      JOIN supplier ON r_supplierCode = supplier.supplierCode
      WHERE DATE(r_provideInformation.date) >= startDate AND DATE(r_provideInformation.date) <= endDate 
      GROUP BY supplier.supplierCode
      ORDER BY number_of_categories ASC;
    END;
  END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calcPurchasePrice` (`input_supplierCode` INT) RETURNS INT(11) BEGIN
DECLARE totalPurchasePrice INT;
SELECT SUM(purchasePrice) into totalPurchasePrice
FROM relationprovide_provideinformation as r_provideInformation, category 
WHERE r_provideInformation.categoryCode = category.categoryCode AND category.r_supplierCode = input_supplierCode;
RETURN totalPurchasePrice;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `calc_order_quantity` (`input_orderCode` INT(10)) RETURNS INT(11) BEGIN
  DECLARE order_quantity INT(10);
  SELECT count(*) into order_quantity 
  FROM customer_order, relationcontain_containbolt
  WHERE customer_order.orderCode = relationcontain_containbolt.orderCode AND customer_order.orderCode = input_orderCode
  GROUP BY customer_order.orderCode;
  RETURN order_quantity;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberOfSuppliers` (`input_supplierName` VARCHAR(70)) RETURNS INT(11) BEGIN
DECLARE totalPurchasePrice INT;
SELECT COUNT(`supplierCode`) INTO totalPurchasePrice FROM supplier WHERE `supplierName` = input_supplierName;
RETURN totalPurchasePrice;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getPurchaseInfo` (`supplier_code` CHAR(20)) RETURNS LONGTEXT CHARSET utf8mb4 BEGIN
    DECLARE purchase JSON;
    DECLARE done INT DEFAULT FALSE;
    DECLARE code int(10);
    DECLARE name varchar(70);
    DECLARE color varchar(20);
    DECLARE quantity int(10);
    DECLARE date_purchase date;
    DECLARE price int(20);
    DECLARE index_detail int(10);
    DECLARE total_price int(30);
    DECLARE category_info
        CURSOR FOR SELECT category.categoryCode, category.color, category.categoryName
            FROM category WHERE r_supplierCode = supplier_code;
    DECLARE category_purchase
        CURSOR FOR SELECT relationprovide_provideinformation.quantity, relationprovide_provideinformation.date, relationprovide_provideinformation.purchasePrice 
        FROM relationprovide_provideinformation WHERE categoryCode = code;
 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  SET purchase = '{"categories_detail": [],"total_price": ""}';
    SET index_detail = -1;
    SET total_price = 0;
 
 
    OPEN category_info;
 
    info_loop: LOOP
        FETCH category_info INTO code, color, name;
        IF done THEN
            LEAVE info_loop;
            CLOSE category_info;
        END IF;
        SELECT JSON_ARRAY_APPEND(purchase, '$.categories_detail', JSON_OBJECT("color", color, "name", name, "purchase_detail", JSON_ARRAY())) INTO purchase;
        SET index_detail = index_detail + 1;
 
        OPEN category_purchase;
        purchase_loop: LOOP
            FETCH category_purchase INTO quantity, date_purchase, price;
            IF done THEN
                SET done = FALSE;
                CLOSE category_purchase;
                LEAVE purchase_loop;
            END IF;
            SET total_price = total_price + price;
            SELECT JSON_ARRAY_APPEND(purchase, CONCAT('$.categories_detail[',index_detail,'].purchase_detail'), JSON_OBJECT("quantity", quantity, "date_purchase", date_purchase, "price", price)) INTO purchase;
        END LOOP purchase_loop;  
    END LOOP info_loop;
    
    SELECT JSON_REPLACE(purchase, "$.total_price", total_price) INTO purchase;
 
    RETURN purchase;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_length` (`new_categoryCode` INT(10), `new_boltCode` INT(10)) RETURNS INT(11) BEGIN
    DECLARE new_length FLOAT;
    SELECT bolt.length INTO new_length
    FROM bolt
    WHERE new_categoryCode = bolt.categoryCode and new_boltCode = bolt.boltCode
    LIMIT 1;
    RETURN new_length;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_selling_price` (`new_categoryCode` INT(10)) RETURNS INT(11) BEGIN
    DECLARE new_price INT(6);
    SELECT category_sellingprice.price INTO new_price
    FROM category
    JOIN category_sellingprice ON category_sellingprice.categoryCode = category.categoryCode
    WHERE category.categoryCode = new_categoryCode and category_sellingprice.date <= curdate()
    ORDER BY category_sellingprice.date DESC LIMIT 1;
    RETURN new_price;
END$$

DELIMITER ;

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
(1, 2, 15),
(1, 3, 50),
(2, 1, 10),
(2, 2, 15),
(3, 1, 10),
(3, 2, 20),
(4, 1, 10),
(4, 2, 20),
(5, 1, 10),
(5, 2, 20),
(6, 1, 10),
(6, 2, 20),
(7, 1, 10),
(7, 2, 20),
(8, 1, 10),
(8, 2, 20),
(9, 1, 10),
(9, 2, 20),
(10, 1, 15),
(19, 1, 60),
(19, 2, 40);

--
-- Triggers `bolt`
--
DELIMITER $$
CREATE TRIGGER `delete_quantityBolt` AFTER DELETE ON `bolt` FOR EACH ROW UPDATE category SET quantity = quantity - 1 WHERE categoryCode = OLD.categoryCode
$$
DELIMITER ;
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
(1, 'Tasar Silk', 'blue', 2, 1),
(2, 'Muga Silk', 'green', 2, 1),
(3, 'Eri Silk', 'purple', 2, 1),
(4, 'Pima Cotton', 'blue', 2, 2),
(5, 'Upland Cotton', 'green', 2, 2),
(6, 'Egyptian Cotton', 'purple', 2, 2),
(7, 'Full Grain Leather', 'blue', 2, 3),
(8, 'Corrected Grain Leather', 'green', 2, 3),
(9, 'Bonded Leather', 'purple', 2, 3),
(10, 'Mulberry Silk', 'cyan', 1, 1),
(11, 'Faux Leather', 'cyan', 0, 3),
(12, 'Suede Leather', 'grey', 0, 3),
(19, 'Charmeuse Silk', 'white', 2, 15);

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
(1, 146, '2020-12-01'),
(1, 193, '2020-12-02'),
(1, 219, '2020-12-05'),
(2, 220, '2020-12-01'),
(2, 330, '2020-12-31'),
(3, 293, '2020-12-01'),
(4, 250, '2020-12-01'),
(5, 300, '2020-12-01'),
(6, 350, '2020-12-01'),
(7, 400, '2020-12-01'),
(8, 450, '2020-12-01'),
(9, 500, '2020-12-01'),
(10, 605, '2020-12-02'),
(11, 600, '2020-12-02'),
(12, 650, '2020-12-02'),
(19, 800, '2020-12-11');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerCode` int(10) UNSIGNED NOT NULL,
  `customerFirstName` varchar(70) NOT NULL,
  `customerLastName` varchar(70) NOT NULL,
  `address` varchar(70) NOT NULL,
  `arrearage` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerCode`, `customerFirstName`, `customerLastName`, `address`, `arrearage`) VALUES
(1, 'Thien', 'Nhan Ngoc', '186/1 Mã Lò, Quận Bình Tân', 115140),
(2, 'Tien', 'Tran Dinh', '110B Thạch Lam, Quận Tân Phú', 5000),
(3, 'Phuong', 'Pham Nhat', '11/7 Cộng Hòa, Quận Tân Bình', 13000),
(4, 'Nhan', 'Nguyen Huu Trung', '123/9 Đường 3/2, Quận 10', 500),
(5, 'Khoa', 'Truong Le Vinh', '33/8/A Phạm Ngũ Lão, Quận Gò Vấp', 0);

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
(7, 27050, 1),
(8, 5490, 2),
(9, 11500, 4),
(10, 23000, 3),
(21, 48000, 1);

--
-- Triggers `customer_order`
--
DELIMITER $$
CREATE TRIGGER `calc_arrearage` AFTER UPDATE ON `customer_order` FOR EACH ROW BEGIN
	IF !(NEW.totalPrice <=> OLD.totalPrice) THEN
   		UPDATE customer
        SET arrearage = arrearage + (NEW.totalPrice - OLD.totalPrice)
        WHERE customer.customerCode = NEW.r_customerCode;
   	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_partialpayment`
--

CREATE TABLE `customer_partialpayment` (
  `customerCode` int(10) UNSIGNED NOT NULL,
  `date` date NOT NULL DEFAULT curdate(),
  `money` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_partialpayment`
--

INSERT INTO `customer_partialpayment` (`customerCode`, `date`, `money`) VALUES
(1, '2020-12-06', 200),
(1, '2020-12-06', 500),
(1, '2020-12-06', 1000),
(2, '2020-12-08', 490),
(3, '2020-12-08', 10000),
(4, '2020-12-11', 11000);

--
-- Triggers `customer_partialpayment`
--
DELIMITER $$
CREATE TRIGGER `calc_unpaidDebt_delete` AFTER DELETE ON `customer_partialpayment` FOR EACH ROW BEGIN
    UPDATE customer 
    SET arrearage = arrearage + OLD.money
    WHERE customer.customerCode = OLD.customerCode;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calc_unpaidDebt_insert` AFTER INSERT ON `customer_partialpayment` FOR EACH ROW UPDATE customer 
SET arrearage = arrearage - NEW.money
WHERE customer.customerCode = NEW.customerCode
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calc_unpaidDebt_update` AFTER UPDATE ON `customer_partialpayment` FOR EACH ROW BEGIN
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

--
-- Dumping data for table `customer_phonenumber`
--

INSERT INTO `customer_phonenumber` (`customerCode`, `phoneNumber`) VALUES
(1, '0918853016'),
(2, '0845426661'),
(2, '0865123412'),
(3, '0962764218'),
(4, '0975476891'),
(5, '0935678934');

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
(1, 'Khoa', 'Nguyen Viet', 'M', '127/80/13 Nguyễn Thị Thập, Quận 7', '0123456769'),
(2, 'Thomas', 'Tom', 'F', '84/1 Gò Dầu, Quận Tân Phú', '0962764218'),
(3, 'Tuan', 'Ngo Duc', 'M', '12/34/96 Cộng Hóa, Quận Tân Bình', '0853546345'),
(4, 'Cuong', 'Tran Trinh', 'M', '68 Bình Trị Đông, Quận Bình Tân', '0914567895');

-- --------------------------------------------------------

--
-- Stand-in structure for view `getallcategories`
-- (See below for the actual view)
--
CREATE TABLE `getallcategories` (
`category` varchar(70)
,`id` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getallorders`
-- (See below for the actual view)
--
CREATE TABLE `getallorders` (
`orderCode` int(10) unsigned
,`totalPrice` float unsigned
,`customerCode` int(10) unsigned
,`Name` varchar(141)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getalltransaction`
-- (See below for the actual view)
--
CREATE TABLE `getalltransaction` (
`categoryName` varchar(70)
,`Date` date
,`purchasePrice` int(6) unsigned
,`Quantity` int(10)
,`supplierName` varchar(70)
,`supplierCode` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getcustomersname`
-- (See below for the actual view)
--
CREATE TABLE `getcustomersname` (
`Name` varchar(141)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getsupplierinfos`
-- (See below for the actual view)
--
CREATE TABLE `getsupplierinfos` (
`supplierCode` int(10) unsigned
,`address` varchar(70)
,`bankAccount` varchar(22)
,`taxCode` varchar(50)
,`phoneNumber` mediumtext
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getsuppliersname`
-- (See below for the actual view)
--
CREATE TABLE `getsuppliersname` (
`ID` int(10) unsigned
,`Name` varchar(70)
);

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
(3, 2, 7),
(6, 2, 7),
(10, 1, 7),
(2, 1, 8),
(6, 1, 8),
(4, 1, 9),
(5, 1, 9),
(5, 2, 9),
(2, 2, 10),
(19, 1, 21);

--
-- Triggers `relationcontain_containbolt`
--
DELIMITER $$
CREATE TRIGGER `calc_totalPrice` AFTER INSERT ON `relationcontain_containbolt` FOR EACH ROW BEGIN
    DECLARE length FLOAT;
    DECLARE price INT(10) DEFAULT 0;
    SET length = (select get_length(NEW.categoryCode, NEW.boltcode));
    SET price = (select get_selling_price(NEW.categoryCode));
    UPDATE customer_order SET customer_order.totalPrice = customer_order.totalPrice + price*length WHERE customer_order.orderCode = NEW.orderCode;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_containBolt` BEFORE DELETE ON `relationcontain_containbolt` FOR EACH ROW BEGIN
    DECLARE order_quantity INT(10);
    SELECT calc_order_quantity(OLD.orderCode) INTO order_quantity;
    IF order_quantity <=> 1
    THEN 
      BEGIN
        SIGNAL SQLSTATE '42927' 
        SET MESSAGE_TEXT = 'Order must contain at least 1 item';
      END;
    END IF;
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
(7, 1, '12:33:23', '2020-12-06'),
(8, 2, '13:00:08', '2020-12-08'),
(9, 3, '13:02:04', '2020-12-08'),
(10, 2, '13:02:42', '2020-11-15'),
(21, 4, '21:51:57', '2020-12-11');

-- --------------------------------------------------------

--
-- Table structure for table `relationprovide_provideinformation`
--

CREATE TABLE `relationprovide_provideinformation` (
  `categoryCode` int(10) UNSIGNED NOT NULL,
  `purchasePrice` int(6) UNSIGNED NOT NULL,
  `quantity` int(10) NOT NULL DEFAULT 0,
  `date` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `relationprovide_provideinformation`
--

INSERT INTO `relationprovide_provideinformation` (`categoryCode`, `purchasePrice`, `quantity`, `date`) VALUES
(1, 100, 0, '2020-12-01'),
(1, 120, 0, '2020-12-05'),
(2, 140, 0, '2020-12-01'),
(3, 220, 0, '2020-12-01'),
(4, 200, 0, '2020-12-01'),
(5, 240, 0, '2020-12-01'),
(6, 290, 0, '2020-12-01'),
(7, 340, 0, '2020-12-01'),
(8, 390, 0, '2020-12-01'),
(9, 460, 0, '2020-12-01'),
(10, 400, 15, '2020-12-02'),
(11, 410, 0, '2020-12-02'),
(12, 430, 0, '2020-12-02'),
(19, 700, 100, '2020-12-11');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplierCode` int(10) UNSIGNED NOT NULL,
  `supplierName` varchar(70) NOT NULL,
  `address` varchar(70) DEFAULT NULL,
  `bankAccount` varchar(22) DEFAULT NULL,
  `taxCode` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplierCode`, `supplierName`, `address`, `bankAccount`, `taxCode`) VALUES
(1, 'Silk Agency', '17/10 Đường số 6, Quận Bình Tân', '0953756463228754', '3600416862-002'),
(2, 'Cotton Agency', '330A Bình Thới, Quận 11', '0915077211241413', '2500557716'),
(3, 'Leather Agency', '20/11/B Điện Biên Phủ Quận 10', '0743684285147217', '2500241938'),
(11, 'Rita Company', '17 Lô A, Lý Thường Kiệt, Quận 10', '0000111122223333', '0102030405'),
(15, 'Silk Agency', '80/7/A Lạc Long Quân, Quận 10', '0986335711112222', '0134567823');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_phonenumber`
--

CREATE TABLE `supplier_phonenumber` (
  `supplierCode` int(10) UNSIGNED NOT NULL,
  `phoneNumber` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier_phonenumber`
--

INSERT INTO `supplier_phonenumber` (`supplierCode`, `phoneNumber`) VALUES
(1, '0865123412'),
(1, '08969935447'),
(1, '0969935447'),
(2, '0853546345'),
(3, '0977445765'),
(11, '0912345678'),
(11, '0922345678'),
(11, '0932345678'),
(11, '0942345678'),
(15, '0933567893');

-- --------------------------------------------------------

--
-- Structure for view `getallcategories`
--
DROP TABLE IF EXISTS `getallcategories`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getallcategories`  AS  select distinct `category`.`categoryName` AS `category`,`category`.`r_supplierCode` AS `id` from `category` ;

-- --------------------------------------------------------

--
-- Structure for view `getallorders`
--
DROP TABLE IF EXISTS `getallorders`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getallorders`  AS  select `customer_order`.`orderCode` AS `orderCode`,`customer_order`.`totalPrice` AS `totalPrice`,`customer`.`customerCode` AS `customerCode`,concat(`customer`.`customerLastName`,' ',`customer`.`customerFirstName`) AS `Name` from (`customer_order` join `customer`) where `customer_order`.`r_customerCode` = `customer`.`customerCode` order by `customer_order`.`orderCode` ;

-- --------------------------------------------------------

--
-- Structure for view `getalltransaction`
--
DROP TABLE IF EXISTS `getalltransaction`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getalltransaction`  AS  select `category`.`categoryName` AS `categoryName`,`relationprovide_provideinformation`.`date` AS `Date`,`relationprovide_provideinformation`.`purchasePrice` AS `purchasePrice`,`relationprovide_provideinformation`.`quantity` AS `Quantity`,`supplier`.`supplierName` AS `supplierName`,`supplier`.`supplierCode` AS `supplierCode` from ((`category` join `relationprovide_provideinformation`) join `supplier`) where `category`.`categoryCode` = `relationprovide_provideinformation`.`categoryCode` and `supplier`.`supplierCode` = `category`.`r_supplierCode` order by `relationprovide_provideinformation`.`date` desc ;

-- --------------------------------------------------------

--
-- Structure for view `getcustomersname`
--
DROP TABLE IF EXISTS `getcustomersname`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getcustomersname`  AS  select distinct concat(`customer`.`customerLastName`,' ',`customer`.`customerFirstName`) AS `Name` from `customer` order by `customer`.`customerFirstName` ;

-- --------------------------------------------------------

--
-- Structure for view `getsupplierinfos`
--
DROP TABLE IF EXISTS `getsupplierinfos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getsupplierinfos`  AS  select `supplier`.`supplierCode` AS `supplierCode`,`supplier`.`address` AS `address`,`supplier`.`bankAccount` AS `bankAccount`,`supplier`.`taxCode` AS `taxCode`,group_concat(`supplier_phonenumber`.`phoneNumber` separator ', ') AS `phoneNumber` from (`supplier` left join `supplier_phonenumber` on(`supplier`.`supplierCode` = `supplier_phonenumber`.`supplierCode`)) group by `supplier`.`supplierCode` ;

-- --------------------------------------------------------

--
-- Structure for view `getsuppliersname`
--
DROP TABLE IF EXISTS `getsuppliersname`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getsuppliersname`  AS  select `supplier`.`supplierCode` AS `ID`,`supplier`.`supplierName` AS `Name` from `supplier` order by `supplier`.`supplierName` ;

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
  ADD PRIMARY KEY (`categoryCode`,`price`,`date`);

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
  ADD KEY `customer_order_fk_customer` (`r_customerCode`);

--
-- Indexes for table `customer_partialpayment`
--
ALTER TABLE `customer_partialpayment`
  ADD PRIMARY KEY (`customerCode`,`date`,`money`);

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
  ADD PRIMARY KEY (`orderCode`) USING BTREE,
  ADD KEY `relationProcess_processsOrder_fk_employee` (`employeeCode`);

--
-- Indexes for table `relationprovide_provideinformation`
--
ALTER TABLE `relationprovide_provideinformation`
  ADD PRIMARY KEY (`categoryCode`,`date`,`purchasePrice`,`quantity`);

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
  MODIFY `categoryCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `customer_order`
--
ALTER TABLE `customer_order`
  MODIFY `orderCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `employeeCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplierCode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

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
  ADD CONSTRAINT `category_sellingprice_fk_category` FOREIGN KEY (`categoryCode`) REFERENCES `category` (`categoryCode`) ON DELETE CASCADE;

--
-- Constraints for table `customer_order`
--
ALTER TABLE `customer_order`
  ADD CONSTRAINT `customer_order_fk_customer` FOREIGN KEY (`r_customerCode`) REFERENCES `customer` (`customerCode`);

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
  ADD CONSTRAINT `relationContain_containBolt_fk_bolt` FOREIGN KEY (`categoryCode`,`boltCode`) REFERENCES `bolt` (`categoryCode`, `boltCode`),
  ADD CONSTRAINT `relationContain_containBolt_fk_order` FOREIGN KEY (`orderCode`) REFERENCES `customer_order` (`orderCode`) ON DELETE CASCADE;

--
-- Constraints for table `relationprocess_processorder`
--
ALTER TABLE `relationprocess_processorder`
  ADD CONSTRAINT `relationProcess_processOrder_fk_order` FOREIGN KEY (`orderCode`) REFERENCES `customer_order` (`orderCode`) ON DELETE CASCADE,
  ADD CONSTRAINT `relationProcess_processsOrder_fk_employee` FOREIGN KEY (`employeeCode`) REFERENCES `employee` (`employeeCode`);

--
-- Constraints for table `relationprovide_provideinformation`
--
ALTER TABLE `relationprovide_provideinformation`
  ADD CONSTRAINT `relationprovide_provideinformation_fk_category` FOREIGN KEY (`categoryCode`) REFERENCES `category` (`categoryCode`) ON DELETE CASCADE;

--
-- Constraints for table `supplier_phonenumber`
--
ALTER TABLE `supplier_phonenumber`
  ADD CONSTRAINT `suplier_phonenumber_fk_supplier` FOREIGN KEY (`supplierCode`) REFERENCES `supplier` (`supplierCode`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
