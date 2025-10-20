--
-- Database: `logistics_db`
--
CREATE DATABASE IF NOT EXISTS `logistics_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `logistics_db`;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff','driver') NOT NULL DEFAULT 'staff',
  `failed_login_attempts` int(11) DEFAULT 0,
  `lockout_until` datetime DEFAULT NULL,
  `employee_id` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--
INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `employee_id`, `created_at`) VALUES
(1, 'admin', 'admin@slate.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'admin', 'SLATE-001', '2025-10-27 01:00:00'),
(2, 'staff_member_1', 'staff1@slate.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'staff', 'SLATE-002', '2025-10-27 01:00:00'),
(3, 'driver_john', 'johndoe@email.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'driver', 'SLATE-003', '2025-10-27 01:01:00'),
(4, 'driver_jane', 'janesmith@email.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'driver', 'SLATE-004', '2025-10-27 01:02:00'),
(5, 'driver_peter', 'peterjones@email.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'driver', 'SLATE-005', '2025-10-27 01:03:00'),
(6, 'vehicle_ELF001', 'vehicle_elf001@slate.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'driver', 'SLATE-V01', '2025-10-27 01:04:00'),
(7, 'vehicle_HIA002', 'vehicle_hia002@slate.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'driver', 'SLATE-V02', '2025-10-27 01:05:00'),
(8, 'pending_driver', 'newdriver@email.com', '$2y$10$E.4a4/yLp2F.1rD.2n9R1e/U/Q.Da/3n29n4i.eJ.s2Q4.sW6w8.m', 'driver', 'SLATE-008', '2025-10-27 01:06:00');

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--
DROP TABLE IF EXISTS `drivers`;
CREATE TABLE `drivers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `license_expiry_date` date DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `date_joined` date DEFAULT NULL,
  `status` enum('Active','Suspended','Inactive','Pending') NOT NULL DEFAULT 'Pending',
  `rating` decimal(3,1) DEFAULT 0.0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_number` (`license_number`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drivers`
--
INSERT INTO `drivers` (`id`, `user_id`, `name`, `license_number`, `license_expiry_date`, `contact_number`, `date_joined`, `status`, `rating`, `created_at`) VALUES
(1, 3, 'John Doe', 'D01-23-456789', '2028-05-20', '09171234567', '2023-01-15', 'Active', 4.8, '2025-10-27 02:01:00'),
(2, 4, 'Jane Smith', 'D02-34-567890', '2026-11-30', '09182345678', '2023-03-22', 'Active', 4.9, '2025-10-27 02:02:00'),
(3, 5, 'Peter Jones', 'D03-45-678901', '2027-08-10', '09283456789', '2024-06-01', 'Active', 4.5, '2025-10-27 02:03:00'),
(4, 6, 'Vehicle Account (ELF001)', 'VEHICLE-ELF001', '2099-12-31', 'N/A', '2025-01-01', 'Active', 5.0, '2025-10-27 02:04:00'),
(5, 7, 'Vehicle Account (HIA002)', 'VEHICLE-HIA002', '2099-12-31', 'N/A', '2025-01-01', 'Active', 5.0, '2025-10-27 02:05:00'),
(6, 8, 'New Applicant Driver', 'D04-56-789012', '2029-01-01', '09123456789', '2025-10-27', 'Pending', 0.0, '2025-10-27 02:06:00');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aggregate_id` int(11) NOT NULL,
  `event_type` varchar(255) NOT NULL,
  `event_payload` json NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--
INSERT INTO `events` (`id`, `aggregate_id`, `event_type`, `event_payload`, `created_at`) VALUES
(1, 1, 'DriverCreated', '{\"id\": 1, \"name\": \"John Doe\", \"rating\": 4.5, \"status\": \"Pending\", \"user_id\": 3, \"date_joined\": \"2023-01-15\", \"contact_number\": \"09171234567\", \"license_number\": \"D01-23-456789\", \"license_expiry_date\": \"2028-05-20\"}', '2025-10-27 03:01:00'),
(2, 1, 'DriverApproved', '{\"rating\": 4.8, \"status\": \"Active\"}', '2025-10-27 03:02:00'),
(3, 2, 'DriverCreated', '{\"id\": 2, \"name\": \"Jane Smith\", \"rating\": 4.9, \"status\": \"Active\", \"user_id\": 4, \"date_joined\": \"2023-03-22\", \"contact_number\": \"09182345678\", \"license_number\": \"D02-34-567890\", \"license_expiry_date\": \"2026-11-30\"}', '2025-10-27 03:03:00');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `model` varchar(100) DEFAULT NULL,
  `tag_type` varchar(50) DEFAULT NULL,
  `tag_code` varchar(100) DEFAULT NULL,
  `load_capacity_kg` int(11) DEFAULT NULL,
  `plate_no` varchar(20) DEFAULT NULL,
  `status` enum('Active','Inactive','Maintenance','En Route','Idle','Breakdown') NOT NULL DEFAULT 'Active',
  `assigned_driver_id` int(11) DEFAULT NULL,
  `image_url` varchar(2083) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_code` (`tag_code`),
  UNIQUE KEY `plate_no` (`plate_no`),
  KEY `assigned_driver_id` (`assigned_driver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--
INSERT INTO `vehicles` (`id`, `type`, `model`, `tag_type`, `tag_code`, `load_capacity_kg`, `plate_no`, `status`, `assigned_driver_id`, `image_url`, `created_at`) VALUES
(1, 'Light-Duty Truck', 'Isuzu Elf NPR', 'RFID', 'ELF001', 4500, 'ABC-1234', 'Active', 1, 'elf.PNG', '2025-10-27 04:01:00'),
(2, 'Van', 'Toyota Hiace', 'RFID', 'HIA002', 1200, 'DEF-5678', 'En Route', 2, 'hiace.PNG', '2025-10-27 04:02:00'),
(3, '4-Wheeler Truck', 'Mitsubishi Fuso Canter', 'RFID', 'CAN003', 4000, 'GHI-9012', 'Idle', 5, 'canter.PNG', '2025-10-27 04:03:00'),
(4, 'Light-Duty Truck', 'Isuzu Elf NKR', 'RFID', 'ELF004', 4200, 'JKL-3456', 'Maintenance', NULL, 'elf.PNG', '2025-10-27 04:04:00');

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_code` varchar(20) NOT NULL,
  `client_name` varchar(100) NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `reserved_by_user_id` int(11) DEFAULT NULL,
  `purpose` text DEFAULT NULL,
  `reservation_date` date NOT NULL,
  `status` enum('Confirmed','Pending','Cancelled','Rejected') NOT NULL DEFAULT 'Pending',
  `load_capacity_needed` int(11) DEFAULT NULL,
  `destination_address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_code` (`reservation_code`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `reserved_by_user_id` (`reserved_by_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--
INSERT INTO `reservations` (`id`, `reservation_code`, `client_name`, `vehicle_id`, `reserved_by_user_id`, `purpose`, `reservation_date`, `status`, `load_capacity_needed`, `destination_address`, `created_at`) VALUES
(1, 'R20251027001', 'ABC Corporation', 2, 2, 'Urgent delivery of documents.', '2025-10-28', 'Confirmed', 50, 'Makati City Hall, Makati', '2025-10-27 05:01:00'),
(2, 'R20251027002', 'XYZ Logistics', 1, 2, 'Pickup of cargo from port area.', '2025-10-29', 'Confirmed', 4000, 'Manila Port Area, Manila', '2025-10-27 05:02:00'),
(3, 'R20251027003', 'Sample Client Inc.', NULL, 2, 'Awaiting vehicle assignment for electronics transport.', '2025-10-30', 'Pending', 2000, 'Technohub, Quezon City', '2025-10-27 05:03:00'),
(4, 'R20251027004', 'Past Delivery Co.', 3, 2, 'Completed delivery last week.', '2025-10-20', 'Confirmed', 3500, 'Laguna Technopark, Biñan, Laguna', '2025-10-20 05:04:00'),
(5, 'R20251027005', 'Cancelled Booking', 1, 2, 'Client cancelled due to schedule changes.', '2025-11-05', 'Cancelled', 1500, 'SM Megamall, Mandaluyong', '2025-10-27 05:05:00');

-- --------------------------------------------------------

--
-- Table structure for table `trips`
--
DROP TABLE IF EXISTS `trips`;
CREATE TABLE `trips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` int(11) DEFAULT NULL,
  `trip_code` varchar(20) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `client_name` varchar(255) DEFAULT NULL,
  `pickup_time` datetime NOT NULL,
  `destination` varchar(255) NOT NULL,
  `status` enum('Scheduled','Completed','Cancelled','En Route','Breakdown','Idle','Arrived at Destination','Unloading') NOT NULL DEFAULT 'Scheduled',
  `current_location` varchar(255) DEFAULT NULL,
  `eta` datetime DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `proof_of_delivery_path` varchar(255) DEFAULT NULL,
  `delivery_notes` text DEFAULT NULL,
  `route_adherence_score` decimal(5,2) DEFAULT 100.00,
  `route_deviations` int(11) DEFAULT 0,
  `actual_arrival_time` datetime DEFAULT NULL,
  `arrival_status` enum('Pending','On-Time','Early','Late') NOT NULL DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `trip_code` (`trip_code`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `driver_id` (`driver_id`),
  KEY `reservation_id` (`reservation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trips`
--
INSERT INTO `trips` (`id`, `reservation_id`, `trip_code`, `vehicle_id`, `driver_id`, `client_name`, `pickup_time`, `destination`, `status`, `current_location`, `eta`, `start_time`, `proof_of_delivery_path`, `delivery_notes`, `route_adherence_score`, `route_deviations`, `actual_arrival_time`, `arrival_status`, `created_at`) VALUES
(1, 1, 'T20251028001', 2, 2, 'ABC Corporation', '2025-10-28 09:00:00', 'Makati City Hall, Makati', 'En Route', '14.5547, 121.0244', '2025-10-28 10:00:00', '09:05:00', NULL, NULL, 98.50, 1, NULL, 'Pending', '2025-10-27 06:01:00'),
(2, 2, 'T20251029002', 1, 1, 'XYZ Logistics', '2025-10-29 08:00:00', 'Manila Port Area, Manila', 'Scheduled', NULL, '2025-10-29 09:30:00', NULL, NULL, NULL, 100.00, 0, NULL, 'Pending', '2025-10-27 06:02:00'),
(3, 4, 'T20251020003', 3, 4, 'Past Delivery Co.', '2025-10-20 10:00:00', 'Laguna Technopark, Biñan, Laguna', 'Completed', NULL, '2025-10-20 12:00:00', '10:02:00', 'uploads/pod/sample_pod.jpg', 'Received by accounting department.', 95.00, 3, '2025-10-20 11:55:00', 'Early', '2025-10-20 06:03:00'),
(4, 5, 'T20251105004', 1, 3, 'Cancelled Booking', '2025-11-05 13:00:00', 'SM Megamall, Mandaluyong', 'Cancelled', NULL, '2025-11-05 14:00:00', NULL, NULL, 'Client request.', 100.00, 0, NULL, 'Pending', '2025-10-27 06:04:00');

-- --------------------------------------------------------

--
-- Table structure for table `trip_costs`
--
DROP TABLE IF EXISTS `trip_costs`;
CREATE TABLE `trip_costs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trip_id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `fuel_cost` decimal(10,2) DEFAULT 0.00,
  `labor_cost` decimal(10,2) DEFAULT 0.00,
  `tolls_cost` decimal(10,2) DEFAULT 0.00,
  `other_cost` decimal(10,2) DEFAULT 0.00,
  `total_cost` decimal(10,2) GENERATED ALWAYS AS (`fuel_cost` + `labor_cost` + `tolls_cost` + `other_cost`) STORED,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `trip_id` (`trip_id`),
  KEY `vehicle_id` (`vehicle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trip_costs`
--
INSERT INTO `trip_costs` (`id`, `trip_id`, `vehicle_id`, `fuel_cost`, `labor_cost`, `tolls_cost`, `other_cost`) VALUES
(1, 3, 3, 1250.75, 500.00, 450.00, 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `budgets`
--
DROP TABLE IF EXISTS `budgets`;
CREATE TABLE `budgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `budget_title` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `budgets`
--
INSERT INTO `budgets` (`id`, `budget_title`, `start_date`, `end_date`, `amount`, `created_at`) VALUES
(1, 'October 2025 Operations Budget', '2025-10-01', '2025-10-31', 250000.00, '2025-10-01 08:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--
DROP TABLE IF EXISTS `expenses`;
CREATE TABLE `expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expense_category` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `expense_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expenses`
--
INSERT INTO `expenses` (`id`, `expense_category`, `description`, `amount`, `expense_date`, `created_at`) VALUES
(1, 'Fuel', 'Diesel for all trucks - Week 1', 35000.00, '2025-10-07', '2025-10-07 09:00:00'),
(2, 'Maintenance', 'Preventive Maintenance for ELF001', 15000.00, '2025-10-15', '2025-10-15 09:01:00'),
(3, 'Salaries', 'Driver Salaries - First Half', 80000.00, '2025-10-15', '2025-10-15 09:02:00');

-- --------------------------------------------------------

--
-- Table structure for table `usage_logs`
--
DROP TABLE IF EXISTS `usage_logs`;
CREATE TABLE `usage_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_id` int(11) NOT NULL,
  `log_date` date NOT NULL,
  `metrics` varchar(255) NOT NULL,
  `fuel_usage` decimal(10,2) NOT NULL,
  `mileage` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `vehicle_id` (`vehicle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usage_logs`
--
INSERT INTO `usage_logs` (`id`, `vehicle_id`, `log_date`, `metrics`, `fuel_usage`, `mileage`, `created_at`) VALUES
(1, 1, '2025-10-26', 'Completed 3 short trips', 55.50, 250, '2025-10-27 10:00:00'),
(2, 2, '2025-10-26', 'City driving for deliveries', 30.20, 150, '2025-10-27 10:01:00');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_approvals`
--
DROP TABLE IF EXISTS `maintenance_approvals`;
CREATE TABLE `maintenance_approvals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_id` int(11) NOT NULL,
  `arrival_date` date NOT NULL,
  `date_of_return` date DEFAULT NULL,
  `status` enum('Pending','Approved','On-Queue','Completed','Rejected') NOT NULL DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `vehicle_id` (`vehicle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maintenance_approvals`
--
INSERT INTO `maintenance_approvals` (`id`, `vehicle_id`, `arrival_date`, `date_of_return`, `status`, `created_at`) VALUES
(1, 4, '2025-10-25', '2025-10-28', 'Completed', '2025-10-25 11:00:00'),
(2, 1, '2025-11-01', NULL, 'Pending', '2025-10-27 11:01:00');

-- --------------------------------------------------------

--
-- Table structure for table `driver_behavior_logs`
--
DROP TABLE IF EXISTS `driver_behavior_logs`;
CREATE TABLE `driver_behavior_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,
  `trip_id` int(11) DEFAULT NULL,
  `log_date` date NOT NULL,
  `overspeeding_count` int(11) NOT NULL DEFAULT 0,
  `harsh_braking_count` int(11) NOT NULL DEFAULT 0,
  `idle_duration_minutes` int(11) NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `driver_id` (`driver_id`),
  KEY `trip_id` (`trip_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `driver_behavior_logs`
--
INSERT INTO `driver_behavior_logs` (`id`, `driver_id`, `trip_id`, `log_date`, `overspeeding_count`, `harsh_braking_count`, `idle_duration_minutes`, `notes`, `created_at`) VALUES
(1, 1, 3, '2025-10-20', 3, 1, 15, 'Overspeeding incidents detected on SLEX.', '2025-10-20 12:00:00'),
(2, 2, 1, '2025-10-28', 1, 5, 25, 'Multiple harsh braking events in city traffic.', '2025-10-28 12:01:00');

-- --------------------------------------------------------

--
-- Table structure for table `tracking_log`
--
DROP TABLE IF EXISTS `tracking_log`;
CREATE TABLE `tracking_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `trip_id` int(11) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `speed_mph` int(11) DEFAULT 0,
  `status_message` varchar(255) DEFAULT NULL,
  `log_time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `trip_id` (`trip_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tracking_log`
--
INSERT INTO `tracking_log` (`id`, `trip_id`, `latitude`, `longitude`, `speed_mph`, `status_message`, `log_time`) VALUES
(1, 1, 14.60910000, 121.02230000, 30, 'Departed from origin', '2025-10-28 09:05:00'),
(2, 1, 14.58290000, 121.03000000, 25, 'On EDSA, moderate traffic', '2025-10-28 09:20:00'),
(3, 1, 14.55470000, 121.02440000, 15, 'Approaching Ayala Avenue', '2025-10-28 09:45:00');

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--
DROP TABLE IF EXISTS `alerts`;
CREATE TABLE `alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trip_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `alert_type` enum('SOS','Breakdown','Other') NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('Pending','Acknowledged','Resolved') NOT NULL DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `trip_id` (`trip_id`),
  KEY `driver_id` (`driver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alerts`
--
INSERT INTO `alerts` (`id`, `trip_id`, `driver_id`, `alert_type`, `description`, `status`, `created_at`) VALUES
(1, 1, 2, 'SOS', 'Minor accident on EDSA. No injuries, but vehicle is stopped.', 'Pending', '2025-10-28 09:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message_text` text NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--
INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message_text`, `sent_at`, `is_read`) VALUES
(1, 1, 3, 'John, please check your schedule for tomorrow. New trip assigned.', '2025-10-27 15:00:00', 1),
(2, 3, 1, 'Copy, admin. Saw it. Will prepare accordingly.', '2025-10-27 15:05:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(100) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_resets`
--
INSERT INTO `password_resets` (`id`, `user_id`, `token`, `expires_at`, `created_at`) VALUES
(1, 2, 'expiredtoken1234567890abcdefghijklmnopqrstuvwxyz', '2025-10-27 10:00:00', '2025-10-27 09:00:00');

--
-- Constraints for dumped tables
--
ALTER TABLE `drivers`
  ADD CONSTRAINT `drivers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`assigned_driver_id`) REFERENCES `drivers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`reserved_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `trips`
  ADD CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `trips_ibfk_3` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `trip_costs`
  ADD CONSTRAINT `trip_costs_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trip_costs_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON UPDATE CASCADE;
  
ALTER TABLE `usage_logs`
  ADD CONSTRAINT `usage_logs_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE `maintenance_approvals`
  ADD CONSTRAINT `maintenance_approvals_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `driver_behavior_logs`
  ADD CONSTRAINT `driver_behavior_logs_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `driver_behavior_logs_ibfk_2` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `tracking_log`
  ADD CONSTRAINT `tracking_log_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `alerts`
  ADD CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `alerts_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;

