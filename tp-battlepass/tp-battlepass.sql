
CREATE TABLE IF NOT EXISTS `battlepass` (
  `identifier` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `playtime` longtext DEFAULT NULL,
  `level` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
