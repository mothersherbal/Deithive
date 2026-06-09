-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 11, 2026 at 08:46 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `diethive`
--

-- --------------------------------------------------------

--
-- Table structure for table `buddy_sessions`
--

CREATE TABLE `buddy_sessions` (
  `id` int(11) NOT NULL,
  `owner_user_id` int(11) NOT NULL,
  `buddy_user_id` int(11) NOT NULL,
  `buddy_token` varchar(64) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `goal_daily_tracking`
--

CREATE TABLE `goal_daily_tracking` (
  `id` int(11) NOT NULL,
  `goal_id` int(11) DEFAULT NULL,
  `day_number` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `goal_daily_tracking`
--

INSERT INTO `goal_daily_tracking` (`id`, `goal_id`, `day_number`, `completed`) VALUES
(62, 59, 1, 1),
(63, 58, 1, 1),
(64, 57, 1, 1),
(67, 61, 1, 1),
(69, 62, 1, 1),
(70, 63, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `habits`
--

CREATE TABLE `habits` (
  `id` int(11) NOT NULL,
  `title` varchar(120) NOT NULL,
  `category` varchar(30) NOT NULL,
  `what_is_it` text NOT NULL,
  `why_it_matters` text NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `habits`
--

INSERT INTO `habits` (`id`, `title`, `category`, `what_is_it`, `why_it_matters`, `icon`, `created_by_user_id`, `is_active`, `created_at`) VALUES
(1, '3L Water Daily', 'Diet', 'Drink at least 3 liters of water throughout the day.', 'Hydration improves energy levels, digestion, and skin health while helping control appetite.', '💧', NULL, 1, '2026-02-23 09:20:09'),
(2, 'Morning Lemon Water', 'Diet', 'Start the day with warm water and fresh lemon juice.', 'This ritual alkalizes the body, boosts Vitamin C, and kickstarts your metabolism.', '🍋', NULL, 1, '2026-02-23 09:20:09'),
(3, 'Herbal Tea', 'Diet', 'Replace one caffeinated drink with herbal tea.', 'Herbal teas provide antioxidants and hydration without caffeine jitters.', '🍵', NULL, 1, '2026-02-23 09:20:09'),
(4, 'No Sugary Drinks', 'Diet', 'Replace sodas and juices with water or sparkling water.', 'Liquid calories spike insulin rapidly; avoiding them is the easiest way to cut sugar.', '🥤', NULL, 1, '2026-02-23 09:20:09'),
(5, 'Green Smoothie', 'Diet', 'Drink a smoothie with greens.', 'Quick way to get vitamins and fiber.', '🥤', NULL, 1, '2026-02-23 09:20:09'),
(6, 'Zero Added Sugar', 'Diet', 'Avoid all foods and drinks with added sugar.', 'Reducing sugar lowers inflammation and improves heart health.', '🚫', NULL, 1, '2026-02-23 09:20:09'),
(7, 'Whole Foods Only', 'Diet', 'Eat only unprocessed foods.', 'Whole foods provide maximum nutrition.', '🌾', NULL, 1, '2026-02-23 09:20:09'),
(8, '3 Servings Greens', 'Diet', 'Eat 3 green vegetables daily.', 'Greens boost immunity.', '🥦', NULL, 1, '2026-02-23 09:20:09'),
(9, 'Eat the Rainbow', 'Diet', 'Eat foods of 3 different colors.', 'Different colors provide different nutrients.', '🌈', NULL, 1, '2026-02-23 09:20:09'),
(10, 'An Apple a Day', 'Diet', 'Eat one apple daily.', 'Promotes gut health.', '🍎', NULL, 1, '2026-02-23 09:20:09'),
(11, 'Berry Boost', 'Diet', 'Eat berries.', 'High antioxidants.', '🫐', NULL, 1, '2026-02-23 09:20:09'),
(12, 'Cruciferous Veg', 'Diet', 'Eat broccoli or cauliflower.', 'Supports detox.', '🥦', NULL, 1, '2026-02-23 09:20:09'),
(13, 'High Protein Diet', 'Diet', 'Add protein to every meal.', 'Protein helps muscle repair.', '🍗', NULL, 1, '2026-02-23 09:20:09'),
(14, 'Plant-Based Day', 'Diet', 'Eat vegetarian for a day.', 'Improves fiber intake.', '🌱', NULL, 1, '2026-02-23 09:20:09'),
(15, 'Oily Fish Weekly', 'Diet', 'Eat fish twice weekly.', 'Omega-3 supports brain health.', '🐟', NULL, 1, '2026-02-23 09:20:09'),
(16, '16:8 Fasting', 'Diet', 'Eat in 8h window.', 'Supports insulin balance.', '⏳', NULL, 1, '2026-02-23 09:20:09'),
(17, 'No Fast Food', 'Diet', 'Avoid fast food.', 'Reduces trans fats.', '🍟', NULL, 1, '2026-02-23 09:20:09'),
(18, 'Low Sodium', 'Diet', 'Limit salt intake.', 'Maintains BP.', '🧂', NULL, 1, '2026-02-23 09:20:09'),
(19, 'Healthy Fats', 'Diet', 'Eat nuts or avocado.', 'Supports hormones.', '🥑', NULL, 1, '2026-02-23 09:20:09'),
(20, 'Probiotic Boost', 'Diet', 'Eat yogurt or kefir.', 'Supports gut health.', '🥣', NULL, 1, '2026-02-23 09:20:09'),
(21, 'Late Night Ban', 'Diet', 'No food 3h before sleep.', 'Improves sleep quality.', '🌑', NULL, 1, '2026-02-23 09:20:09'),
(22, 'Salad for Lunch', 'Diet', 'Eat salad for lunch.', 'High nutrients.', '🥗', NULL, 1, '2026-02-23 09:20:09'),
(23, 'Portion Control', 'Diet', 'Eat 80% full.', 'Improves digestion.', '🍽️', NULL, 1, '2026-02-23 09:20:09'),
(24, 'Mindful Eating', 'Diet', 'Eat without screens.', 'Improves satiety.', '🧘', NULL, 1, '2026-02-23 09:20:09'),
(25, 'Cook a Meal', 'Diet', 'Cook meal at home.', 'Better control of nutrition.', '👨‍🍳', NULL, 1, '2026-02-23 09:20:09'),
(26, '30 Min Jog', 'Fitness', 'Jog 30 minutes.', 'Strengthens heart.', '🏃', NULL, 1, '2026-02-23 09:20:09'),
(27, '10,000 Steps', 'Fitness', 'Walk 10k steps.', 'Boosts metabolism.', '👟', NULL, 1, '2026-02-23 09:20:09'),
(28, 'HIIT Workout', 'Fitness', '15 min HIIT.', 'Burns fat fast.', '🔥', NULL, 1, '2026-02-23 09:20:09'),
(29, '5km Cycle', 'Fitness', 'Cycle 5km.', 'Improves stamina.', '🚴', NULL, 1, '2026-02-23 09:20:09'),
(30, '30 Min Swim', 'Fitness', 'Swim laps.', 'Full body workout.', '🏊', NULL, 1, '2026-02-23 09:20:09'),
(31, 'Jump Rope', 'Fitness', 'Jump rope 15min.', 'Improves agility.', '➰', NULL, 1, '2026-02-23 09:20:09'),
(32, 'Brisk Walk', 'Fitness', 'Walk fast 30min.', 'Burns fat.', '💨', NULL, 1, '2026-02-23 09:20:09'),
(33, 'Post-Meal Walk', 'Fitness', 'Walk after meal.', 'Improves digestion.', '🚶', NULL, 1, '2026-02-23 09:20:09'),
(34, 'Stair Climber', 'Fitness', 'Climb stairs.', 'Builds legs.', '🪜', NULL, 1, '2026-02-23 09:20:09'),
(35, 'Dancing', 'Fitness', 'Dance 20min.', 'Improves mood.', '💃', NULL, 1, '2026-02-23 09:20:09'),
(36, '50 Daily Pushups', 'Fitness', 'Do 50 pushups.', 'Builds strength.', '💪', NULL, 1, '2026-02-23 09:20:09'),
(37, 'Weight Training', 'Fitness', 'Lift weights.', 'Builds muscle.', '🏋️', NULL, 1, '2026-02-23 09:20:09'),
(38, '2 Minute Plank', 'Fitness', 'Hold plank.', 'Strengthens core.', '🧱', NULL, 1, '2026-02-23 09:20:09'),
(39, 'Leg Day', 'Fitness', 'Do squats/lunges.', 'Boosts metabolism.', '🦵', NULL, 1, '2026-02-23 09:20:09'),
(40, 'Core Strengthening', 'Fitness', 'Core workout.', 'Protects spine.', '🛡️', NULL, 1, '2026-02-23 09:20:09'),
(41, 'Pull-up Practice', 'Fitness', 'Practice pullups.', 'Builds back strength.', '🆙', NULL, 1, '2026-02-23 09:20:09'),
(42, 'Squat Challenge', 'Fitness', '50 squats.', 'Tones legs.', '🏋️‍♀️', NULL, 1, '2026-02-23 09:20:09'),
(43, 'Calisthenics', 'Fitness', 'Bodyweight workout.', 'Improves control.', '🤸‍♂️', NULL, 1, '2026-02-23 09:20:09'),
(44, 'Yoga Session', 'Fitness', '20 min yoga.', 'Improves flexibility.', '🧘', NULL, 1, '2026-02-23 09:20:09'),
(45, 'Morning Stretch', 'Fitness', 'Stretch morning.', 'Prepares body.', '🤸', NULL, 1, '2026-02-23 09:20:09'),
(46, 'Foam Rolling', 'Fitness', 'Roll muscles.', 'Reduces soreness.', '🔄', NULL, 1, '2026-02-23 09:20:09'),
(47, 'Always the Stairs', 'Fitness', 'Use stairs.', 'Burns calories.', '🪜', NULL, 1, '2026-02-23 09:20:09'),
(48, 'Posture Check', 'Fitness', 'Fix posture.', 'Reduces back pain.', '📏', NULL, 1, '2026-02-23 09:20:09'),
(49, 'Meditation', 'Mindfulness', 'Meditate 10min.', 'Reduces stress.', '🧘‍♂️', NULL, 1, '2026-02-23 09:20:09'),
(50, 'Gratitude Journal', 'Mindfulness', 'Write gratitude.', 'Boosts positivity.', '📓', NULL, 1, '2026-02-23 09:20:09'),
(51, 'Digital Detox', 'Sleep', 'No phone before bed.', 'Improves sleep.', '📵', NULL, 1, '2026-02-23 09:20:09'),
(52, '8 Hours Sleep', 'Sleep', 'Sleep 8h.', 'Critical for recovery.', '😴', NULL, 1, '2026-02-23 09:20:09'),
(53, 'Read Wellness', 'Mindfulness', 'Read health book.', 'Improves knowledge.', '📖', NULL, 1, '2026-02-23 09:20:09'),
(54, 'Cold Shower', 'Wellness', 'Cold shower.', 'Boosts resilience.', '🚿', NULL, 1, '2026-02-23 09:20:09'),
(55, 'Nature Walk', 'Wellness', 'Walk outside.', 'Lowers stress.', '🌲', NULL, 1, '2026-02-23 09:20:09'),
(56, 'Deep Breathing', 'Mindfulness', 'Breathing exercise.', 'Activates calm system.', '🌬️', NULL, 1, '2026-02-23 09:20:09'),
(57, 'Power Nap', 'Sleep', 'Nap 20min.', 'Restores energy.', '💤', NULL, 1, '2026-02-23 09:20:09'),
(58, 'Visualisation', 'Mindfulness', 'Visualize success.', 'Boosts performance.', '🧠', NULL, 1, '2026-02-23 09:20:09'),
(59, 'Sunlight View', 'Wellness', 'Morning sunlight.', 'Improves rhythm.', '☀️', NULL, 1, '2026-02-23 09:20:09'),
(60, 'Social Walk', 'Wellness', 'Walk with friend.', 'Improves wellbeing.', '🗣️', NULL, 1, '2026-02-23 09:20:09'),
(61, 'Floss Teeth', 'Wellness', 'Floss daily.', 'Improves oral health.', '🦷', NULL, 1, '2026-02-23 09:20:09'),
(62, 'Skin Care', 'Wellness', 'Do skincare.', 'Protects skin.', '🧴', NULL, 1, '2026-02-23 09:20:09'),
(63, 'Stand Every Hour', 'Fitness', 'Stand hourly.', 'Reduces sitting risk.', '🧍', NULL, 1, '2026-02-23 09:20:09'),
(64, 'Meal Prep', 'Diet', 'Prep meals.', 'Encourages healthy eating.', '🍱', NULL, 1, '2026-02-23 09:20:09'),
(65, 'Drink lemon water', 'Custom', 'Drink lemon water', 'User created habit', '⭐', 8, 1, '2026-02-25 08:20:36'),
(66, 'Drink lemon water', 'Custom', 'Drink lemon water', 'User created habit', '⭐', 8, 1, '2026-02-25 08:21:03'),
(67, 'Drink lemon water', 'Custom', 'Drink lemon water', 'User created habit', '⭐', 8, 1, '2026-02-25 08:21:06'),
(68, 'Drink water everyday', 'Custom', 'Drink water everyday', 'User created habit', '⭐', 8, 1, '2026-02-25 08:23:08'),
(69, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-02-27 03:42:03'),
(70, 'No Sugary Drinks', 'Custom', 'No Sugary Drinks', 'User created habit', '⭐', 7, 1, '2026-02-27 03:42:31'),
(71, 'High Protein Diet', 'Custom', 'High Protein Diet', 'User created habit', '⭐', 7, 1, '2026-02-27 03:42:41'),
(72, 'Morning Lemon Water', 'Custom', 'Morning Lemon Water', 'User created habit', '⭐', 15, 1, '2026-02-27 03:43:18'),
(73, 'No Sugary Drinks', 'Custom', 'No Sugary Drinks', 'User created habit', '⭐', 15, 1, '2026-02-27 04:07:57'),
(74, 'Zero Added Sugar', 'Custom', 'Zero Added Sugar', 'User created habit', '⭐', 15, 1, '2026-02-27 04:13:24'),
(75, 'Morning Run (A)', 'Custom', 'Morning Run (A)', 'User created habit', '⭐', 16, 1, '2026-02-27 04:16:25'),
(76, 'Evening Yoga (B)', 'Custom', 'Evening Yoga (B)', 'User created habit', '⭐', 17, 1, '2026-02-27 04:16:25'),
(77, '3 Servings Greens', 'Custom', '3 Servings Greens', 'User created habit', '⭐', 15, 1, '2026-02-27 04:19:52'),
(78, 'Whole Foods Only', 'Custom', 'Whole Foods Only', 'User created habit', '⭐', 7, 1, '2026-02-27 04:23:44'),
(79, 'Whole Foods Only', 'Custom', 'Whole Foods Only', 'User created habit', '⭐', 15, 1, '2026-02-27 04:39:21'),
(80, '3L Water Daily', 'Custom', '3L Water Daily', 'User created habit', '⭐', 15, 1, '2026-02-27 07:16:43'),
(81, '3L Water Daily', 'Custom', '3L Water Daily', 'User created habit', '⭐', 7, 1, '2026-02-27 07:19:39'),
(82, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-02-27 07:21:55'),
(83, 'No Sugary Drinks', 'Custom', 'No Sugary Drinks', 'User created habit', '⭐', 15, 1, '2026-02-27 07:23:29'),
(84, 'Skin Care', 'Custom', 'Skin Care', 'User created habit', '⭐', 15, 1, '2026-02-27 08:16:55'),
(85, 'jayram', 'Custom', 'jayram', 'User created habit', '⭐', 7, 1, '2026-02-27 08:18:47'),
(86, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 10, 1, '2026-02-27 08:26:36'),
(87, 'Morning Lemon Water', 'Custom', 'Morning Lemon Water', 'User created habit', '⭐', 15, 1, '2026-03-04 08:23:09'),
(88, 'Morning Lemon Water', 'Custom', 'Morning Lemon Water', 'User created habit', '⭐', 15, 1, '2026-03-04 08:48:06'),
(89, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 7, 1, '2026-03-04 08:50:11'),
(90, 'Oily Fish Weekly', 'Custom', 'Oily Fish Weekly', 'User created habit', '⭐', 7, 1, '2026-03-04 08:50:17'),
(91, 'Portion Control', 'Custom', 'Portion Control', 'User created habit', '⭐', 15, 1, '2026-03-04 08:51:08'),
(92, 'Post-Meal Walk', 'Custom', 'Post-Meal Walk', 'User created habit', '⭐', 15, 1, '2026-03-04 08:51:20'),
(93, 'Morning Lemon Water', 'Custom', 'Morning Lemon Water', 'User created habit', '⭐', 7, 1, '2026-03-04 11:13:45'),
(94, 'Skin Care', 'Custom', 'Skin Care', 'User created habit', '⭐', 7, 1, '2026-03-04 11:14:00'),
(95, 'No Sugary Drinks', 'Custom', 'No Sugary Drinks', 'User created habit', '⭐', 15, 1, '2026-03-05 03:27:03'),
(96, 'An Apple a Day', 'Custom', 'An Apple a Day', 'User created habit', '⭐', 7, 1, '2026-03-05 08:53:39'),
(97, 'Morning Lemon Water', 'Custom', 'Morning Lemon Water', 'User created habit', '⭐', 7, 1, '2026-03-05 08:53:58'),
(98, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-03-06 02:49:32'),
(99, '3L Water Daily', 'Custom', '3L Water Daily', 'User created habit', '⭐', 15, 1, '2026-03-07 07:55:17'),
(100, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-03-10 03:00:12'),
(101, 'Berry Boost', 'Custom', 'Berry Boost', 'User created habit', '⭐', 15, 1, '2026-03-10 03:00:30'),
(102, 'Morning Lemon Water', 'Custom', 'Morning Lemon Water', 'User created habit', '⭐', 15, 1, '2026-03-10 03:02:04'),
(103, 'Stand Every Hour', 'Custom', 'Stand Every Hour', 'User created habit', '⭐', 15, 1, '2026-03-10 03:05:44'),
(104, 'Green Smoothie', 'Custom', 'Green Smoothie', 'User created habit', '⭐', 15, 1, '2026-03-10 03:23:34'),
(105, 'Jump Rope', 'Custom', 'Jump Rope', 'User created habit', '⭐', 15, 1, '2026-03-10 04:07:26'),
(106, 'haboy', 'Custom', 'haboy', 'User created habit', '⭐', 7, 1, '2026-03-10 04:32:34'),
(107, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-03-11 05:45:49'),
(108, '3L Water Daily', 'Custom', '3L Water Daily', 'User created habit', '⭐', 15, 1, '2026-03-11 05:46:09'),
(109, 'Green Smoothie', 'Custom', 'Green Smoothie', 'User created habit', '⭐', 15, 1, '2026-03-11 05:56:00'),
(110, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-03-11 05:56:07'),
(111, 'Whole Foods Only', 'Custom', 'Whole Foods Only', 'User created habit', '⭐', 15, 1, '2026-03-11 05:56:12'),
(112, '5km Cycle', 'Custom', '5km Cycle', 'User created habit', '⭐', 15, 1, '2026-03-11 05:56:19'),
(113, 'Brisk Walk', 'Custom', 'Brisk Walk', 'User created habit', '⭐', 15, 1, '2026-03-11 05:56:31'),
(114, 'hi', 'Custom', 'hi', 'User created habit', '⭐', 15, 1, '2026-03-11 05:56:55'),
(115, 'Herbal Tea', 'Custom', 'Herbal Tea', 'User created habit', '⭐', 15, 1, '2026-03-11 06:23:11'),
(116, 'No Sugary Drinks', 'Custom', 'No Sugary Drinks', 'User created habit', '⭐', 15, 1, '2026-03-11 06:29:26'),
(117, '3L Water Daily', 'Custom', '3L Water Daily', 'User created habit', '⭐', 15, 1, '2026-03-11 06:30:00'),
(118, 'good talks', 'Custom', 'good talks', 'User created habit', '⭐', 15, 1, '2026-03-11 06:30:12'),
(119, '3 Servings Greens', 'Custom', '3 Servings Greens', 'User created habit', '⭐', 15, 1, '2026-03-11 06:30:22'),
(120, 'Cruciferous Veg', 'Custom', 'Cruciferous Veg', 'User created habit', '⭐', 15, 1, '2026-03-11 06:30:29'),
(121, 'Healthy Fats', 'Custom', 'Healthy Fats', 'User created habit', '⭐', 15, 1, '2026-03-11 06:30:36'),
(122, 'Probiotic Boost', 'Custom', 'Probiotic Boost', 'User created habit', '⭐', 7, 1, '2026-03-11 06:33:24'),
(123, 'Cold Shower', 'Custom', 'Cold Shower', 'User created habit', '⭐', 15, 1, '2026-03-11 06:42:34'),
(124, 'Dancing', 'Custom', 'Dancing', 'User created habit', '⭐', 15, 1, '2026-03-11 07:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `habit_daily_log`
--

CREATE TABLE `habit_daily_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `habit_id` int(11) NOT NULL,
  `log_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `habit_daily_log`
--

INSERT INTO `habit_daily_log` (`id`, `user_id`, `habit_id`, `log_date`, `created_at`) VALUES
(3, 5, 2, '2026-03-04', '2026-03-04 11:22:11'),
(4, 5, 2, '2026-02-01', '2026-03-04 11:22:18');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `time_value` varchar(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `is_unread` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notification_settings`
--

CREATE TABLE `notification_settings` (
  `user_id` int(11) NOT NULL,
  `daily_enabled` tinyint(1) DEFAULT 1,
  `daily_time` varchar(20) DEFAULT '09:00 AM',
  `monthly_enabled` tinyint(1) DEFAULT 1,
  `monthly_day` varchar(10) DEFAULT '5',
  `monthly_time` varchar(20) DEFAULT '10:00 AM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_settings`
--

INSERT INTO `notification_settings` (`user_id`, `daily_enabled`, `daily_time`, `monthly_enabled`, `monthly_day`, `monthly_time`) VALUES
(7, 1, '10:09 AM', 1, '5', '10:00 AM'),
(15, 1, '12:57 PM', 1, '5', '10:00 AM');

-- --------------------------------------------------------

--
-- Table structure for table `register`
--

CREATE TABLE `register` (
  `id` int(190) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password` varchar(170) NOT NULL,
  `otp` varchar(50) DEFAULT NULL,
  `otp_enquiry` varchar(50) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `register`
--

INSERT INTO `register` (`id`, `full_name`, `email`, `password`, `otp`, `otp_enquiry`, `otp_expiry`) VALUES
(2, 'Kousik Kumar', 'kousik@test.com', 'scrypt:32768:8:1$qXQq0dhiq6ibe2ni$1a073ebb228fa64ef6ae3013dcd71a54da7daf498deeabb95d920c4fb3e4f33183f1de106d1493a2c484ad8759e7d6b78cdd778e815f3febd8d6f16787a5c287', NULL, NULL, NULL),
(3, 'SSVVousik', 'kousikssvv3@gmail.com', 'scrypt:32768:8:1$NwudgFmf2UnSu06l$741075ec3d8d3a10749741b8de08d0cd6adf62efc0a0310cdc4582c2dfdc86f43c1902a683fc29e49463968e21a6c858bc834a83537ef3c05f8ae277c66b3b43', '5039', NULL, '2026-02-23 17:01:42'),
(4, 'Buddy Explorer', 'buddy@diethive.com', 'scrypt:32768:8:1$xaIUYK2IWZl5Oame$4e07f764c26c02ab9fd902393659422b756e0b38f2071a05dcad0ccab3ded4d74772025009e20ed768711635279d1f367183f8f1b814bf7c519e7f13a4bc7893', NULL, NULL, NULL),
(5, 'koiug', 'kousik@gmail.com', 'scrypt:32768:8:1$cyaCy7R1wLJl3fYR$ecd92ab236e1a1c3ab3574b699d04beb380f50295e3d49e4018bcb784437daa48c54132111ab351c49d1e7d786dec764132e76b3ca05dfa691c6294e79f82b11', NULL, NULL, NULL),
(6, 'swarna', 'swarna@gmail.com', 'scrypt:32768:8:1$LKq6sFPJxUFKe3ju$e15f767ed87bdb95a4dd49fd4960a3a03d99a42b78fbc139e9d3620625fc725dfff0e259e8c41804234ee32fe0887ec1191ce10f944c5b33e1721110fd230dd0', NULL, NULL, NULL),
(7, 'jayaram', 'jayaramklv@gmail.com', 'scrypt:32768:8:1$RcRwiTazLUBWobxM$56bc71d2ebdc58e38db237b648f779bb8a4c71f3ffa31783f501076dcb342546a61f53931f8fddc789828dc75c1760f01071b7aa1802c44f259dc89d85955e75', NULL, NULL, NULL),
(8, 'test', 'test@gmail.com', 'scrypt:32768:8:1$WNHlmcLGa3SJVMAa$afa9ec769ca62cd6c94aec34caac74b1f1498cf740745ee6cce6c483208ec12a8cd4df727eea55fa4093cddd49e96e5c85681330c4bc3ae68c48e612cd37cbb2', NULL, NULL, NULL),
(9, 'koushik', 'sn3029769@gmail.com', 'scrypt:32768:8:1$UXbXHIf8Ibqjps3z$3b186ac0d8d324a908ce0e1a8fa18d7ecfdcb23f7d3a212bc4be93c13b431475be84c3c25be36595fbe73bace4020eb486de34bab8a9c7a2ba6d1e8784302205', NULL, NULL, NULL),
(10, 'nani', 'kousikssvv1311.sse@saveetha.com', 'scrypt:32768:8:1$SqTcXukeZaVncSCG$97613d799187da5cfcb4e5401d56b0748e6201f312fe9e44b879e0a4614638905ff78046d29e535fd1dfe1d7c0e6f34be32d7d3e6aeb19ac79bb7a436ed672d2', NULL, NULL, NULL),
(14, 'charan', 'charandevalapalli@gmail.com', 'scrypt:32768:8:1$nBBTk2zm4A2wiQNR$0c8cf195963cad6d0bde99664a5d6d3e2f19a2308d90d0d749e9cd33bb28a55b16f226fb5c9751c1766ea8bf106758812906f122d4f4c748270a1a027dac3098', NULL, NULL, NULL),
(15, 'chotu ga', 'kousikssvv34@gmail.com', 'scrypt:32768:8:1$AagyEbicp83rdVnj$6adda72bd43d37b8b30a4f8e8e3acdff3789d8e393a9001128941f163c0076da4aac08d5fce91801e81ead9848573b2153584020ecabb3447a8986129a844e1f', NULL, NULL, NULL),
(16, 'Person A', 'a@diethive.test', 'scrypt:32768:8:1$LRBCG2ECLqDc6l05$86838a3186978161484d6bf0c7b9d4936ab97d76cbc32019dd530aa6d6158665d95610bd9b95e26716308f21d51296df228b05e7d1794640b1b7079c042ea112', NULL, NULL, NULL),
(17, 'Person B', 'b@diethive.test', 'scrypt:32768:8:1$45Emz4Mn3e7b4iDW$d114a3b774ca99371efdc5785d19c7b45c29835970f021c641696f6ee12030592a8c9b6b86ca1c78e1c3dd4dc84211abad782f47936815cce6d1aa8c3c0c6e2c', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tips`
--

CREATE TABLE `tips` (
  `id` int(11) NOT NULL,
  `tip_text` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tips`
--

INSERT INTO `tips` (`id`, `tip_text`) VALUES
(1, 'Progress beats perfection.'),
(2, 'Show up, even when you don’t feel like it.'),
(3, 'Discipline is stronger than motivation.'),
(4, 'Small steps create big change.'),
(5, 'Consistency wins over intensity.'),
(6, 'Your future self is watching.'),
(7, 'Effort today is strength tomorrow.'),
(8, 'Comfort is the enemy of growth.'),
(9, 'Action removes doubt.'),
(10, 'Don’t quit on a bad day.'),
(11, 'Start before you feel ready.'),
(12, 'Done is better than perfect.'),
(13, 'Movement creates momentum.'),
(14, 'One rep is better than none.'),
(15, 'Effort compounds daily.'),
(16, 'Try again. Then again.'),
(17, 'Sweat is proof of effort.'),
(18, 'Hard things build strong people.'),
(19, 'You don’t fail — you learn.'),
(20, 'Keep going. That’s the secret.'),
(21, 'Motivation fades. Discipline stays.'),
(22, 'Habits shape destiny.'),
(23, 'Show up for yourself.'),
(24, 'Do it tired. Do it anyway.'),
(25, 'Routine builds power.'),
(26, 'Structure creates success.'),
(27, 'Discipline is self-respect.'),
(28, 'One decision can change your day.'),
(29, 'Self-control is a superpower.'),
(30, 'Strong habits = strong life.'),
(31, 'Growth feels uncomfortable.'),
(32, 'Improvement is invisible at first.'),
(33, 'Today’s struggle = tomorrow’s strength.'),
(34, 'Every effort counts.'),
(35, 'You’re building something real.'),
(36, 'Results follow persistence.'),
(37, 'Growth never happens in comfort.'),
(38, 'Improvement is a daily choice.'),
(39, 'Focus on progress, not speed.'),
(40, 'Your limits are expandable.'),
(41, 'Confidence comes from action.'),
(42, 'Trust your process.'),
(43, 'Believe in your effort.'),
(44, 'You are capable.'),
(45, 'Strength grows quietly.'),
(46, 'Keep promises to yourself.'),
(47, 'Self-belief is fuel.'),
(48, 'Effort builds confidence.'),
(49, 'Discipline builds pride.'),
(50, 'You’re stronger than excuses.'),
(51, 'Little daily wins matter.'),
(52, 'One good day leads to another.'),
(53, 'Repetition creates mastery.'),
(54, 'Consistency beats talent.'),
(55, 'Show up daily.'),
(56, 'Momentum is built slowly.'),
(57, 'One day at a time.'),
(58, 'Streaks build success.'),
(59, 'Don’t break your chain.'),
(60, 'Daily action = long-term success.'),
(61, 'Rest is part of progress.'),
(62, 'Calm mind, strong body.'),
(63, 'Recovery is growth too.'),
(64, 'Breathe and reset.'),
(65, 'Strength includes patience.'),
(66, 'Listen to your body.'),
(67, 'Balance beats burnout.'),
(68, 'Wellness is a lifestyle.'),
(69, 'Pace yourself.'),
(70, 'Strength and peace can coexist.'),
(71, 'Push past average.'),
(72, 'Try one more time.'),
(73, 'Do what others avoid.'),
(74, 'Growth lives outside comfort.'),
(75, 'Hard work pays silently.'),
(76, 'Challenge creates change.'),
(77, 'Push limits gently but daily.'),
(78, 'Effort unlocks ability.'),
(79, 'Today’s effort is tomorrow’s reward.'),
(80, 'You’re capable of more.'),
(81, 'Good days are built.'),
(82, 'Start with a positive action.'),
(83, 'Energy follows effort.'),
(84, 'Progress is success.'),
(85, 'Be proud of trying.'),
(86, 'Smile — you showed up.'),
(87, 'Every step matters.'),
(88, 'Choose progress today.'),
(89, 'Positivity fuels performance.'),
(90, 'Effort is success already.'),
(91, 'Don’t stop now.'),
(92, 'Keep climbing.'),
(93, 'Finish what you start.'),
(94, 'Patience wins.'),
(95, 'Stay steady.'),
(96, 'Success loves persistence.'),
(97, 'Keep the promise to yourself.'),
(98, 'You’re getting better daily.'),
(99, 'Never underestimate consistency.');

-- --------------------------------------------------------

--
-- Table structure for table `tip_history`
--

CREATE TABLE `tip_history` (
  `id` int(11) NOT NULL,
  `tip_id` int(11) NOT NULL,
  `shown_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tip_history`
--

INSERT INTO `tip_history` (`id`, `tip_id`, `shown_date`) VALUES
(2, 87, '2026-02-23');

-- --------------------------------------------------------

--
-- Table structure for table `trophies`
--

CREATE TABLE `trophies` (
  `id` int(11) NOT NULL,
  `title` varchar(60) NOT NULL,
  `days_required` int(11) NOT NULL,
  `reward_points` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trophies`
--

INSERT INTO `trophies` (`id`, `title`, `days_required`, `reward_points`) VALUES
(1, '1 Week Trophy', 7, 50),
(2, '2 Week Trophy', 14, 100),
(3, '3 Week Trophy', 21, 150),
(4, '4 Week Trophy', 28, 250),
(5, '5 Week Trophy', 35, 350),
(6, '6 Week Trophy', 42, 450),
(7, '7 Week Trophy', 49, 550),
(8, '8 Week Trophy', 56, 650),
(9, '9 Week Trophy', 63, 750),
(10, '10 Week Trophy', 70, 850),
(11, '11 Week Trophy', 77, 950),
(12, '12 Week Trophy', 84, 1050);

-- --------------------------------------------------------

--
-- Table structure for table `user_goals`
--

CREATE TABLE `user_goals` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `habit_id` int(11) NOT NULL,
  `marks_per_day` int(3) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int(4) NOT NULL,
  `total_potential_rewards` int(6) NOT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_goals`
--

INSERT INTO `user_goals` (`id`, `user_id`, `habit_id`, `marks_per_day`, `start_date`, `end_date`, `total_days`, `total_potential_rewards`, `status`, `created_at`) VALUES
(57, 15, 118, 20, '2026-03-11', '2026-03-31', 21, 420, 'ACTIVE', '2026-03-11 06:30:13'),
(58, 15, 119, 20, '2026-03-11', '2026-03-31', 21, 420, 'ACTIVE', '2026-03-11 06:30:22'),
(59, 15, 120, 20, '2026-03-11', '2026-03-31', 21, 420, 'ACTIVE', '2026-03-11 06:30:29'),
(61, 7, 122, 20, '2026-03-11', '2026-03-31', 21, 420, 'ACTIVE', '2026-03-11 06:33:24'),
(62, 15, 123, 20, '2026-03-11', '2026-03-31', 21, 420, 'ACTIVE', '2026-03-11 06:42:35'),
(63, 15, 124, 20, '2026-03-11', '2026-03-31', 21, 420, 'ACTIVE', '2026-03-11 07:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `user_notifications`
--

CREATE TABLE `user_notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('daily','monthly') NOT NULL,
  `time_value` varchar(10) NOT NULL,
  `day_value` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_progress`
--

CREATE TABLE `user_progress` (
  `user_id` int(11) NOT NULL,
  `total_active_days` int(11) NOT NULL,
  `total_points` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_progress`
--

INSERT INTO `user_progress` (`user_id`, `total_active_days`, `total_points`, `updated_at`) VALUES
(5, 2, 20, '2026-03-04 11:22:18'),
(7, 1, 10, '2026-03-11 06:33:28'),
(9, 0, 0, '2026-02-25 07:42:23'),
(15, 5, 400, '2026-03-11 06:31:03');

-- --------------------------------------------------------

--
-- Table structure for table `user_selected_habits`
--

CREATE TABLE `user_selected_habits` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `habit_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `selected_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_selected_habits`
--

INSERT INTO `user_selected_habits` (`id`, `user_id`, `habit_id`, `is_active`, `selected_at`) VALUES
(1, 5, 1, 0, '2026-02-25 07:21:43'),
(2, 5, 2, 0, '2026-02-25 07:21:43'),
(3, 5, 3, 0, '2026-02-25 07:21:43'),
(4, 5, 4, 0, '2026-02-25 07:21:43'),
(5, 5, 5, 0, '2026-02-25 07:21:43'),
(6, 5, 1, 0, '2026-02-25 07:40:08'),
(7, 5, 2, 0, '2026-02-25 07:40:08'),
(8, 5, 3, 0, '2026-02-25 07:40:08'),
(9, 5, 4, 0, '2026-02-25 07:40:08'),
(10, 5, 5, 0, '2026-02-25 07:40:08'),
(11, 5, 1, 1, '2026-02-25 07:40:08'),
(12, 5, 2, 1, '2026-02-25 07:40:08'),
(13, 5, 3, 1, '2026-02-25 07:40:08'),
(14, 5, 4, 1, '2026-02-25 07:40:08'),
(15, 5, 5, 1, '2026-02-25 07:40:08'),
(16, 7, 13, 1, '2026-02-25 07:41:04'),
(17, 7, 15, 1, '2026-02-25 07:41:04'),
(18, 7, 9, 1, '2026-02-25 07:41:04'),
(19, 7, 6, 1, '2026-02-25 07:41:04'),
(20, 7, 10, 1, '2026-02-25 07:41:04'),
(21, 9, 16, 0, '2026-03-04 11:19:55'),
(22, 9, 17, 0, '2026-03-04 11:19:55'),
(23, 9, 7, 0, '2026-03-04 11:19:55'),
(24, 9, 8, 0, '2026-03-04 11:19:55'),
(25, 9, 1, 0, '2026-03-04 11:19:55'),
(26, 9, 16, 1, '2026-03-04 11:19:55'),
(27, 9, 17, 1, '2026-03-04 11:19:55'),
(28, 9, 7, 1, '2026-03-04 11:19:55'),
(29, 9, 8, 1, '2026-03-04 11:19:55'),
(30, 9, 1, 1, '2026-03-04 11:19:55');

-- --------------------------------------------------------

--
-- Table structure for table `user_trophies`
--

CREATE TABLE `user_trophies` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `trophy_id` int(11) NOT NULL,
  `is_unlocked` tinyint(1) NOT NULL,
  `unlocked_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_trophies`
--

INSERT INTO `user_trophies` (`id`, `user_id`, `trophy_id`, `is_unlocked`, `unlocked_at`) VALUES
(181, 15, 1, 1, '2026-03-11 09:43:16'),
(182, 15, 2, 0, '0000-00-00 00:00:00'),
(183, 15, 3, 0, '0000-00-00 00:00:00'),
(184, 15, 4, 0, '0000-00-00 00:00:00'),
(185, 15, 5, 0, '0000-00-00 00:00:00'),
(186, 15, 6, 0, '0000-00-00 00:00:00'),
(187, 15, 7, 0, '0000-00-00 00:00:00'),
(188, 15, 8, 0, '0000-00-00 00:00:00'),
(189, 15, 9, 0, '0000-00-00 00:00:00'),
(190, 15, 10, 0, '0000-00-00 00:00:00'),
(191, 15, 11, 0, '0000-00-00 00:00:00'),
(192, 15, 12, 0, '0000-00-00 00:00:00'),
(193, 7, 1, 0, '0000-00-00 00:00:00'),
(194, 7, 2, 0, '0000-00-00 00:00:00'),
(195, 7, 3, 0, '0000-00-00 00:00:00'),
(196, 7, 4, 0, '0000-00-00 00:00:00'),
(197, 7, 5, 0, '0000-00-00 00:00:00'),
(198, 7, 6, 0, '0000-00-00 00:00:00'),
(199, 7, 7, 0, '0000-00-00 00:00:00'),
(200, 7, 8, 0, '0000-00-00 00:00:00'),
(201, 7, 9, 0, '0000-00-00 00:00:00'),
(202, 7, 10, 0, '0000-00-00 00:00:00'),
(203, 7, 11, 0, '0000-00-00 00:00:00'),
(204, 7, 12, 0, '0000-00-00 00:00:00'),
(205, 7, 1, 0, '0000-00-00 00:00:00'),
(206, 7, 2, 0, '0000-00-00 00:00:00'),
(207, 7, 3, 0, '0000-00-00 00:00:00'),
(208, 7, 4, 0, '0000-00-00 00:00:00'),
(209, 7, 5, 0, '0000-00-00 00:00:00'),
(210, 7, 6, 0, '0000-00-00 00:00:00'),
(211, 7, 7, 0, '0000-00-00 00:00:00'),
(212, 7, 8, 0, '0000-00-00 00:00:00'),
(213, 7, 9, 0, '0000-00-00 00:00:00'),
(214, 7, 10, 0, '0000-00-00 00:00:00'),
(215, 7, 11, 0, '0000-00-00 00:00:00'),
(216, 7, 12, 0, '0000-00-00 00:00:00'),
(217, 7, 1, 0, '0000-00-00 00:00:00'),
(218, 7, 2, 0, '0000-00-00 00:00:00'),
(219, 7, 3, 0, '0000-00-00 00:00:00'),
(220, 7, 4, 0, '0000-00-00 00:00:00'),
(221, 7, 5, 0, '0000-00-00 00:00:00'),
(222, 7, 6, 0, '0000-00-00 00:00:00'),
(223, 7, 7, 0, '0000-00-00 00:00:00'),
(224, 7, 8, 0, '0000-00-00 00:00:00'),
(225, 7, 9, 0, '0000-00-00 00:00:00'),
(226, 7, 10, 0, '0000-00-00 00:00:00'),
(227, 7, 11, 0, '0000-00-00 00:00:00'),
(228, 7, 12, 0, '0000-00-00 00:00:00'),
(229, 7, 1, 0, '0000-00-00 00:00:00'),
(230, 7, 2, 0, '0000-00-00 00:00:00'),
(231, 7, 3, 0, '0000-00-00 00:00:00'),
(232, 7, 4, 0, '0000-00-00 00:00:00'),
(233, 7, 5, 0, '0000-00-00 00:00:00'),
(234, 7, 6, 0, '0000-00-00 00:00:00'),
(235, 7, 7, 0, '0000-00-00 00:00:00'),
(236, 7, 8, 0, '0000-00-00 00:00:00'),
(237, 7, 9, 0, '0000-00-00 00:00:00'),
(238, 7, 10, 0, '0000-00-00 00:00:00'),
(239, 7, 11, 0, '0000-00-00 00:00:00'),
(240, 7, 12, 0, '0000-00-00 00:00:00'),
(241, 7, 1, 0, '0000-00-00 00:00:00'),
(242, 7, 2, 0, '0000-00-00 00:00:00'),
(243, 7, 3, 0, '0000-00-00 00:00:00'),
(244, 7, 4, 0, '0000-00-00 00:00:00'),
(245, 7, 5, 0, '0000-00-00 00:00:00'),
(246, 7, 6, 0, '0000-00-00 00:00:00'),
(247, 7, 7, 0, '0000-00-00 00:00:00'),
(248, 7, 8, 0, '0000-00-00 00:00:00'),
(249, 7, 9, 0, '0000-00-00 00:00:00'),
(250, 7, 10, 0, '0000-00-00 00:00:00'),
(251, 7, 11, 0, '0000-00-00 00:00:00'),
(252, 7, 12, 0, '0000-00-00 00:00:00'),
(253, 7, 1, 0, '0000-00-00 00:00:00'),
(254, 7, 2, 0, '0000-00-00 00:00:00'),
(255, 7, 3, 0, '0000-00-00 00:00:00'),
(256, 7, 4, 0, '0000-00-00 00:00:00'),
(257, 7, 5, 0, '0000-00-00 00:00:00'),
(258, 7, 6, 0, '0000-00-00 00:00:00'),
(259, 7, 7, 0, '0000-00-00 00:00:00'),
(260, 7, 8, 0, '0000-00-00 00:00:00'),
(261, 7, 9, 0, '0000-00-00 00:00:00'),
(262, 7, 10, 0, '0000-00-00 00:00:00'),
(263, 7, 11, 0, '0000-00-00 00:00:00'),
(264, 7, 12, 0, '0000-00-00 00:00:00'),
(265, 15, 1, 1, '2026-03-11 09:43:16'),
(266, 15, 2, 0, '0000-00-00 00:00:00'),
(267, 15, 3, 0, '0000-00-00 00:00:00'),
(268, 15, 4, 0, '0000-00-00 00:00:00'),
(269, 15, 5, 0, '0000-00-00 00:00:00'),
(270, 15, 6, 0, '0000-00-00 00:00:00'),
(271, 15, 7, 0, '0000-00-00 00:00:00'),
(272, 15, 8, 0, '0000-00-00 00:00:00'),
(273, 15, 9, 0, '0000-00-00 00:00:00'),
(274, 15, 10, 0, '0000-00-00 00:00:00'),
(275, 15, 11, 0, '0000-00-00 00:00:00'),
(276, 15, 12, 0, '0000-00-00 00:00:00'),
(277, 15, 1, 1, '2026-03-11 09:43:16'),
(278, 15, 2, 0, '0000-00-00 00:00:00'),
(279, 15, 3, 0, '0000-00-00 00:00:00'),
(280, 15, 4, 0, '0000-00-00 00:00:00'),
(281, 15, 5, 0, '0000-00-00 00:00:00'),
(282, 15, 6, 0, '0000-00-00 00:00:00'),
(283, 15, 7, 0, '0000-00-00 00:00:00'),
(284, 15, 8, 0, '0000-00-00 00:00:00'),
(285, 15, 9, 0, '0000-00-00 00:00:00'),
(286, 15, 10, 0, '0000-00-00 00:00:00'),
(287, 15, 11, 0, '0000-00-00 00:00:00'),
(288, 15, 12, 0, '0000-00-00 00:00:00'),
(289, 15, 1, 1, '2026-03-11 09:43:20'),
(290, 15, 2, 0, '0000-00-00 00:00:00'),
(291, 15, 3, 0, '0000-00-00 00:00:00'),
(292, 15, 4, 0, '0000-00-00 00:00:00'),
(293, 15, 5, 0, '0000-00-00 00:00:00'),
(294, 15, 6, 0, '0000-00-00 00:00:00'),
(295, 15, 7, 0, '0000-00-00 00:00:00'),
(296, 15, 8, 0, '0000-00-00 00:00:00'),
(297, 15, 9, 0, '0000-00-00 00:00:00'),
(298, 15, 10, 0, '0000-00-00 00:00:00'),
(299, 15, 11, 0, '0000-00-00 00:00:00'),
(300, 15, 12, 0, '0000-00-00 00:00:00'),
(301, 15, 1, 1, '2026-03-11 09:43:27'),
(302, 15, 2, 0, '0000-00-00 00:00:00'),
(303, 15, 3, 0, '0000-00-00 00:00:00'),
(304, 15, 4, 0, '0000-00-00 00:00:00'),
(305, 15, 5, 0, '0000-00-00 00:00:00'),
(306, 15, 6, 0, '0000-00-00 00:00:00'),
(307, 15, 7, 0, '0000-00-00 00:00:00'),
(308, 15, 8, 0, '0000-00-00 00:00:00'),
(309, 15, 9, 0, '0000-00-00 00:00:00'),
(310, 15, 10, 0, '0000-00-00 00:00:00'),
(311, 15, 11, 0, '0000-00-00 00:00:00'),
(312, 15, 12, 0, '0000-00-00 00:00:00'),
(313, 15, 1, 1, '2026-03-11 09:43:30'),
(314, 15, 2, 0, '0000-00-00 00:00:00'),
(315, 15, 3, 0, '0000-00-00 00:00:00'),
(316, 15, 4, 0, '0000-00-00 00:00:00'),
(317, 15, 5, 0, '0000-00-00 00:00:00'),
(318, 15, 6, 0, '0000-00-00 00:00:00'),
(319, 15, 7, 0, '0000-00-00 00:00:00'),
(320, 15, 8, 0, '0000-00-00 00:00:00'),
(321, 15, 9, 0, '0000-00-00 00:00:00'),
(322, 15, 10, 0, '0000-00-00 00:00:00'),
(323, 15, 11, 0, '0000-00-00 00:00:00'),
(324, 15, 12, 0, '0000-00-00 00:00:00'),
(325, 15, 1, 1, '2026-03-11 09:54:42'),
(326, 15, 2, 0, '0000-00-00 00:00:00'),
(327, 15, 3, 0, '0000-00-00 00:00:00'),
(328, 15, 4, 0, '0000-00-00 00:00:00'),
(329, 15, 5, 0, '0000-00-00 00:00:00'),
(330, 15, 6, 0, '0000-00-00 00:00:00'),
(331, 15, 7, 0, '0000-00-00 00:00:00'),
(332, 15, 8, 0, '0000-00-00 00:00:00'),
(333, 15, 9, 0, '0000-00-00 00:00:00'),
(334, 15, 10, 0, '0000-00-00 00:00:00'),
(335, 15, 11, 0, '0000-00-00 00:00:00'),
(336, 15, 12, 0, '0000-00-00 00:00:00'),
(337, 15, 1, 0, '0000-00-00 00:00:00'),
(338, 15, 2, 0, '0000-00-00 00:00:00'),
(339, 15, 3, 0, '0000-00-00 00:00:00'),
(340, 15, 4, 0, '0000-00-00 00:00:00'),
(341, 15, 5, 0, '0000-00-00 00:00:00'),
(342, 15, 6, 0, '0000-00-00 00:00:00'),
(343, 15, 7, 0, '0000-00-00 00:00:00'),
(344, 15, 8, 0, '0000-00-00 00:00:00'),
(345, 15, 9, 0, '0000-00-00 00:00:00'),
(346, 15, 10, 0, '0000-00-00 00:00:00'),
(347, 15, 11, 0, '0000-00-00 00:00:00'),
(348, 15, 12, 0, '0000-00-00 00:00:00'),
(349, 15, 1, 0, '0000-00-00 00:00:00'),
(350, 15, 2, 0, '0000-00-00 00:00:00'),
(351, 15, 3, 0, '0000-00-00 00:00:00'),
(352, 15, 4, 0, '0000-00-00 00:00:00'),
(353, 15, 5, 0, '0000-00-00 00:00:00'),
(354, 15, 6, 0, '0000-00-00 00:00:00'),
(355, 15, 7, 0, '0000-00-00 00:00:00'),
(356, 15, 8, 0, '0000-00-00 00:00:00'),
(357, 15, 9, 0, '0000-00-00 00:00:00'),
(358, 15, 10, 0, '0000-00-00 00:00:00'),
(359, 15, 11, 0, '0000-00-00 00:00:00'),
(360, 15, 12, 0, '0000-00-00 00:00:00'),
(361, 15, 1, 0, '0000-00-00 00:00:00'),
(362, 15, 2, 0, '0000-00-00 00:00:00'),
(363, 15, 3, 0, '0000-00-00 00:00:00'),
(364, 15, 4, 0, '0000-00-00 00:00:00'),
(365, 15, 5, 0, '0000-00-00 00:00:00'),
(366, 15, 6, 0, '0000-00-00 00:00:00'),
(367, 15, 7, 0, '0000-00-00 00:00:00'),
(368, 15, 8, 0, '0000-00-00 00:00:00'),
(369, 15, 9, 0, '0000-00-00 00:00:00'),
(370, 15, 10, 0, '0000-00-00 00:00:00'),
(371, 15, 11, 0, '0000-00-00 00:00:00'),
(372, 15, 12, 0, '0000-00-00 00:00:00'),
(373, 15, 1, 0, '0000-00-00 00:00:00'),
(374, 15, 2, 0, '0000-00-00 00:00:00'),
(375, 15, 3, 0, '0000-00-00 00:00:00'),
(376, 15, 4, 0, '0000-00-00 00:00:00'),
(377, 15, 5, 0, '0000-00-00 00:00:00'),
(378, 15, 6, 0, '0000-00-00 00:00:00'),
(379, 15, 7, 0, '0000-00-00 00:00:00'),
(380, 15, 8, 0, '0000-00-00 00:00:00'),
(381, 15, 9, 0, '0000-00-00 00:00:00'),
(382, 15, 10, 0, '0000-00-00 00:00:00'),
(383, 15, 11, 0, '0000-00-00 00:00:00'),
(384, 15, 12, 0, '0000-00-00 00:00:00'),
(385, 15, 1, 0, '0000-00-00 00:00:00'),
(386, 15, 2, 0, '0000-00-00 00:00:00'),
(387, 15, 3, 0, '0000-00-00 00:00:00'),
(388, 15, 4, 0, '0000-00-00 00:00:00'),
(389, 15, 5, 0, '0000-00-00 00:00:00'),
(390, 15, 6, 0, '0000-00-00 00:00:00'),
(391, 15, 7, 0, '0000-00-00 00:00:00'),
(392, 15, 8, 0, '0000-00-00 00:00:00'),
(393, 15, 9, 0, '0000-00-00 00:00:00'),
(394, 15, 10, 0, '0000-00-00 00:00:00'),
(395, 15, 11, 0, '0000-00-00 00:00:00'),
(396, 15, 12, 0, '0000-00-00 00:00:00'),
(397, 15, 1, 0, '0000-00-00 00:00:00'),
(398, 15, 2, 0, '0000-00-00 00:00:00'),
(399, 15, 3, 0, '0000-00-00 00:00:00'),
(400, 15, 4, 0, '0000-00-00 00:00:00'),
(401, 15, 5, 0, '0000-00-00 00:00:00'),
(402, 15, 6, 0, '0000-00-00 00:00:00'),
(403, 15, 7, 0, '0000-00-00 00:00:00'),
(404, 15, 8, 0, '0000-00-00 00:00:00'),
(405, 15, 9, 0, '0000-00-00 00:00:00'),
(406, 15, 10, 0, '0000-00-00 00:00:00'),
(407, 15, 11, 0, '0000-00-00 00:00:00'),
(408, 15, 12, 0, '0000-00-00 00:00:00'),
(409, 15, 1, 0, '0000-00-00 00:00:00'),
(410, 15, 2, 0, '0000-00-00 00:00:00'),
(411, 15, 3, 0, '0000-00-00 00:00:00'),
(412, 15, 4, 0, '0000-00-00 00:00:00'),
(413, 15, 5, 0, '0000-00-00 00:00:00'),
(414, 15, 6, 0, '0000-00-00 00:00:00'),
(415, 15, 7, 0, '0000-00-00 00:00:00'),
(416, 15, 8, 0, '0000-00-00 00:00:00'),
(417, 15, 9, 0, '0000-00-00 00:00:00'),
(418, 15, 10, 0, '0000-00-00 00:00:00'),
(419, 15, 11, 0, '0000-00-00 00:00:00'),
(420, 15, 12, 0, '0000-00-00 00:00:00'),
(421, 15, 1, 0, '0000-00-00 00:00:00'),
(422, 15, 2, 0, '0000-00-00 00:00:00'),
(423, 15, 3, 0, '0000-00-00 00:00:00'),
(424, 15, 4, 0, '0000-00-00 00:00:00'),
(425, 15, 5, 0, '0000-00-00 00:00:00'),
(426, 15, 6, 0, '0000-00-00 00:00:00'),
(427, 15, 7, 0, '0000-00-00 00:00:00'),
(428, 15, 8, 0, '0000-00-00 00:00:00'),
(429, 15, 9, 0, '0000-00-00 00:00:00'),
(430, 15, 10, 0, '0000-00-00 00:00:00'),
(431, 15, 11, 0, '0000-00-00 00:00:00'),
(432, 15, 12, 0, '0000-00-00 00:00:00'),
(433, 15, 1, 0, '0000-00-00 00:00:00'),
(434, 15, 2, 0, '0000-00-00 00:00:00'),
(435, 15, 3, 0, '0000-00-00 00:00:00'),
(436, 15, 4, 0, '0000-00-00 00:00:00'),
(437, 15, 5, 0, '0000-00-00 00:00:00'),
(438, 15, 6, 0, '0000-00-00 00:00:00'),
(439, 15, 7, 0, '0000-00-00 00:00:00'),
(440, 15, 8, 0, '0000-00-00 00:00:00'),
(441, 15, 9, 0, '0000-00-00 00:00:00'),
(442, 15, 10, 0, '0000-00-00 00:00:00'),
(443, 15, 11, 0, '0000-00-00 00:00:00'),
(444, 15, 12, 0, '0000-00-00 00:00:00'),
(445, 15, 1, 0, '0000-00-00 00:00:00'),
(446, 15, 2, 0, '0000-00-00 00:00:00'),
(447, 15, 3, 0, '0000-00-00 00:00:00'),
(448, 15, 4, 0, '0000-00-00 00:00:00'),
(449, 15, 5, 0, '0000-00-00 00:00:00'),
(450, 15, 6, 0, '0000-00-00 00:00:00'),
(451, 15, 7, 0, '0000-00-00 00:00:00'),
(452, 15, 8, 0, '0000-00-00 00:00:00'),
(453, 15, 9, 0, '0000-00-00 00:00:00'),
(454, 15, 10, 0, '0000-00-00 00:00:00'),
(455, 15, 11, 0, '0000-00-00 00:00:00'),
(456, 15, 12, 0, '0000-00-00 00:00:00'),
(457, 15, 1, 0, '0000-00-00 00:00:00'),
(458, 15, 2, 0, '0000-00-00 00:00:00'),
(459, 15, 3, 0, '0000-00-00 00:00:00'),
(460, 15, 4, 0, '0000-00-00 00:00:00'),
(461, 15, 5, 0, '0000-00-00 00:00:00'),
(462, 15, 6, 0, '0000-00-00 00:00:00'),
(463, 15, 7, 0, '0000-00-00 00:00:00'),
(464, 15, 8, 0, '0000-00-00 00:00:00'),
(465, 15, 9, 0, '0000-00-00 00:00:00'),
(466, 15, 10, 0, '0000-00-00 00:00:00'),
(467, 15, 11, 0, '0000-00-00 00:00:00'),
(468, 15, 12, 0, '0000-00-00 00:00:00'),
(469, 15, 1, 0, '0000-00-00 00:00:00'),
(470, 15, 2, 0, '0000-00-00 00:00:00'),
(471, 15, 3, 0, '0000-00-00 00:00:00'),
(472, 15, 4, 0, '0000-00-00 00:00:00'),
(473, 15, 5, 0, '0000-00-00 00:00:00'),
(474, 15, 6, 0, '0000-00-00 00:00:00'),
(475, 15, 7, 0, '0000-00-00 00:00:00'),
(476, 15, 8, 0, '0000-00-00 00:00:00'),
(477, 15, 9, 0, '0000-00-00 00:00:00'),
(478, 15, 10, 0, '0000-00-00 00:00:00'),
(479, 15, 11, 0, '0000-00-00 00:00:00'),
(480, 15, 12, 0, '0000-00-00 00:00:00'),
(481, 15, 1, 0, '0000-00-00 00:00:00'),
(482, 15, 2, 0, '0000-00-00 00:00:00'),
(483, 15, 3, 0, '0000-00-00 00:00:00'),
(484, 15, 4, 0, '0000-00-00 00:00:00'),
(485, 15, 5, 0, '0000-00-00 00:00:00'),
(486, 15, 6, 0, '0000-00-00 00:00:00'),
(487, 15, 7, 0, '0000-00-00 00:00:00'),
(488, 15, 8, 0, '0000-00-00 00:00:00'),
(489, 15, 9, 0, '0000-00-00 00:00:00'),
(490, 15, 10, 0, '0000-00-00 00:00:00'),
(491, 15, 11, 0, '0000-00-00 00:00:00'),
(492, 15, 12, 0, '0000-00-00 00:00:00'),
(493, 15, 1, 0, '0000-00-00 00:00:00'),
(494, 15, 2, 0, '0000-00-00 00:00:00'),
(495, 15, 3, 0, '0000-00-00 00:00:00'),
(496, 15, 4, 0, '0000-00-00 00:00:00'),
(497, 15, 5, 0, '0000-00-00 00:00:00'),
(498, 15, 6, 0, '0000-00-00 00:00:00'),
(499, 15, 7, 0, '0000-00-00 00:00:00'),
(500, 15, 8, 0, '0000-00-00 00:00:00'),
(501, 15, 9, 0, '0000-00-00 00:00:00'),
(502, 15, 10, 0, '0000-00-00 00:00:00'),
(503, 15, 11, 0, '0000-00-00 00:00:00'),
(504, 15, 12, 0, '0000-00-00 00:00:00'),
(505, 15, 1, 0, '0000-00-00 00:00:00'),
(506, 15, 2, 0, '0000-00-00 00:00:00'),
(507, 15, 3, 0, '0000-00-00 00:00:00'),
(508, 15, 4, 0, '0000-00-00 00:00:00'),
(509, 15, 5, 0, '0000-00-00 00:00:00'),
(510, 15, 6, 0, '0000-00-00 00:00:00'),
(511, 15, 7, 0, '0000-00-00 00:00:00'),
(512, 15, 8, 0, '0000-00-00 00:00:00'),
(513, 15, 9, 0, '0000-00-00 00:00:00'),
(514, 15, 10, 0, '0000-00-00 00:00:00'),
(515, 15, 11, 0, '0000-00-00 00:00:00'),
(516, 15, 12, 0, '0000-00-00 00:00:00'),
(517, 15, 1, 0, '0000-00-00 00:00:00'),
(518, 15, 2, 0, '0000-00-00 00:00:00'),
(519, 15, 3, 0, '0000-00-00 00:00:00'),
(520, 15, 4, 0, '0000-00-00 00:00:00'),
(521, 15, 5, 0, '0000-00-00 00:00:00'),
(522, 15, 6, 0, '0000-00-00 00:00:00'),
(523, 15, 7, 0, '0000-00-00 00:00:00'),
(524, 15, 8, 0, '0000-00-00 00:00:00'),
(525, 15, 9, 0, '0000-00-00 00:00:00'),
(526, 15, 10, 0, '0000-00-00 00:00:00'),
(527, 15, 11, 0, '0000-00-00 00:00:00'),
(528, 15, 12, 0, '0000-00-00 00:00:00'),
(529, 15, 1, 0, '0000-00-00 00:00:00'),
(530, 15, 2, 0, '0000-00-00 00:00:00'),
(531, 15, 3, 0, '0000-00-00 00:00:00'),
(532, 15, 4, 0, '0000-00-00 00:00:00'),
(533, 15, 5, 0, '0000-00-00 00:00:00'),
(534, 15, 6, 0, '0000-00-00 00:00:00'),
(535, 15, 7, 0, '0000-00-00 00:00:00'),
(536, 15, 8, 0, '0000-00-00 00:00:00'),
(537, 15, 9, 0, '0000-00-00 00:00:00'),
(538, 15, 10, 0, '0000-00-00 00:00:00'),
(539, 15, 11, 0, '0000-00-00 00:00:00'),
(540, 15, 12, 0, '0000-00-00 00:00:00'),
(541, 15, 1, 0, '0000-00-00 00:00:00'),
(542, 15, 2, 0, '0000-00-00 00:00:00'),
(543, 15, 3, 0, '0000-00-00 00:00:00'),
(544, 15, 4, 0, '0000-00-00 00:00:00'),
(545, 15, 5, 0, '0000-00-00 00:00:00'),
(546, 15, 6, 0, '0000-00-00 00:00:00'),
(547, 15, 7, 0, '0000-00-00 00:00:00'),
(548, 15, 8, 0, '0000-00-00 00:00:00'),
(549, 15, 9, 0, '0000-00-00 00:00:00'),
(550, 15, 10, 0, '0000-00-00 00:00:00'),
(551, 15, 11, 0, '0000-00-00 00:00:00'),
(552, 15, 12, 0, '0000-00-00 00:00:00'),
(553, 15, 1, 0, '0000-00-00 00:00:00'),
(554, 15, 2, 0, '0000-00-00 00:00:00'),
(555, 15, 3, 0, '0000-00-00 00:00:00'),
(556, 15, 4, 0, '0000-00-00 00:00:00'),
(557, 15, 5, 0, '0000-00-00 00:00:00'),
(558, 15, 6, 0, '0000-00-00 00:00:00'),
(559, 15, 7, 0, '0000-00-00 00:00:00'),
(560, 15, 8, 0, '0000-00-00 00:00:00'),
(561, 15, 9, 0, '0000-00-00 00:00:00'),
(562, 15, 10, 0, '0000-00-00 00:00:00'),
(563, 15, 11, 0, '0000-00-00 00:00:00'),
(564, 15, 12, 0, '0000-00-00 00:00:00'),
(565, 15, 1, 0, '0000-00-00 00:00:00'),
(566, 15, 2, 0, '0000-00-00 00:00:00'),
(567, 15, 3, 0, '0000-00-00 00:00:00'),
(568, 15, 4, 0, '0000-00-00 00:00:00'),
(569, 15, 5, 0, '0000-00-00 00:00:00'),
(570, 15, 6, 0, '0000-00-00 00:00:00'),
(571, 15, 7, 0, '0000-00-00 00:00:00'),
(572, 15, 8, 0, '0000-00-00 00:00:00'),
(573, 15, 9, 0, '0000-00-00 00:00:00'),
(574, 15, 10, 0, '0000-00-00 00:00:00'),
(575, 15, 11, 0, '0000-00-00 00:00:00'),
(576, 15, 12, 0, '0000-00-00 00:00:00'),
(577, 15, 1, 0, '0000-00-00 00:00:00'),
(578, 15, 2, 0, '0000-00-00 00:00:00'),
(579, 15, 3, 0, '0000-00-00 00:00:00'),
(580, 15, 4, 0, '0000-00-00 00:00:00'),
(581, 15, 5, 0, '0000-00-00 00:00:00'),
(582, 15, 6, 0, '0000-00-00 00:00:00'),
(583, 15, 7, 0, '0000-00-00 00:00:00'),
(584, 15, 8, 0, '0000-00-00 00:00:00'),
(585, 15, 9, 0, '0000-00-00 00:00:00'),
(586, 15, 10, 0, '0000-00-00 00:00:00'),
(587, 15, 11, 0, '0000-00-00 00:00:00'),
(588, 15, 12, 0, '0000-00-00 00:00:00'),
(589, 15, 1, 0, '0000-00-00 00:00:00'),
(590, 15, 2, 0, '0000-00-00 00:00:00'),
(591, 15, 3, 0, '0000-00-00 00:00:00'),
(592, 15, 4, 0, '0000-00-00 00:00:00'),
(593, 15, 5, 0, '0000-00-00 00:00:00'),
(594, 15, 6, 0, '0000-00-00 00:00:00'),
(595, 15, 7, 0, '0000-00-00 00:00:00'),
(596, 15, 8, 0, '0000-00-00 00:00:00'),
(597, 15, 9, 0, '0000-00-00 00:00:00'),
(598, 15, 10, 0, '0000-00-00 00:00:00'),
(599, 15, 11, 0, '0000-00-00 00:00:00'),
(600, 15, 12, 0, '0000-00-00 00:00:00'),
(601, 7, 1, 0, '0000-00-00 00:00:00'),
(602, 7, 2, 0, '0000-00-00 00:00:00'),
(603, 7, 3, 0, '0000-00-00 00:00:00'),
(604, 7, 4, 0, '0000-00-00 00:00:00'),
(605, 7, 5, 0, '0000-00-00 00:00:00'),
(606, 7, 6, 0, '0000-00-00 00:00:00'),
(607, 7, 7, 0, '0000-00-00 00:00:00'),
(608, 7, 8, 0, '0000-00-00 00:00:00'),
(609, 7, 9, 0, '0000-00-00 00:00:00'),
(610, 7, 10, 0, '0000-00-00 00:00:00'),
(611, 7, 11, 0, '0000-00-00 00:00:00'),
(612, 7, 12, 0, '0000-00-00 00:00:00'),
(613, 7, 1, 0, '0000-00-00 00:00:00'),
(614, 7, 2, 0, '0000-00-00 00:00:00'),
(615, 7, 3, 0, '0000-00-00 00:00:00'),
(616, 7, 4, 0, '0000-00-00 00:00:00'),
(617, 7, 5, 0, '0000-00-00 00:00:00'),
(618, 7, 6, 0, '0000-00-00 00:00:00'),
(619, 7, 7, 0, '0000-00-00 00:00:00'),
(620, 7, 8, 0, '0000-00-00 00:00:00'),
(621, 7, 9, 0, '0000-00-00 00:00:00'),
(622, 7, 10, 0, '0000-00-00 00:00:00'),
(623, 7, 11, 0, '0000-00-00 00:00:00'),
(624, 7, 12, 0, '0000-00-00 00:00:00'),
(625, 7, 1, 0, '0000-00-00 00:00:00'),
(626, 7, 2, 0, '0000-00-00 00:00:00'),
(627, 7, 3, 0, '0000-00-00 00:00:00'),
(628, 7, 4, 0, '0000-00-00 00:00:00'),
(629, 7, 5, 0, '0000-00-00 00:00:00'),
(630, 7, 6, 0, '0000-00-00 00:00:00'),
(631, 7, 7, 0, '0000-00-00 00:00:00'),
(632, 7, 8, 0, '0000-00-00 00:00:00'),
(633, 7, 9, 0, '0000-00-00 00:00:00'),
(634, 7, 10, 0, '0000-00-00 00:00:00'),
(635, 7, 11, 0, '0000-00-00 00:00:00'),
(636, 7, 12, 0, '0000-00-00 00:00:00'),
(637, 15, 1, 0, '0000-00-00 00:00:00'),
(638, 15, 2, 0, '0000-00-00 00:00:00'),
(639, 15, 3, 0, '0000-00-00 00:00:00'),
(640, 15, 4, 0, '0000-00-00 00:00:00'),
(641, 15, 5, 0, '0000-00-00 00:00:00'),
(642, 15, 6, 0, '0000-00-00 00:00:00'),
(643, 15, 7, 0, '0000-00-00 00:00:00'),
(644, 15, 8, 0, '0000-00-00 00:00:00'),
(645, 15, 9, 0, '0000-00-00 00:00:00'),
(646, 15, 10, 0, '0000-00-00 00:00:00'),
(647, 15, 11, 0, '0000-00-00 00:00:00'),
(648, 15, 12, 0, '0000-00-00 00:00:00'),
(649, 15, 1, 0, '0000-00-00 00:00:00'),
(650, 15, 2, 0, '0000-00-00 00:00:00'),
(651, 15, 3, 0, '0000-00-00 00:00:00'),
(652, 15, 4, 0, '0000-00-00 00:00:00'),
(653, 15, 5, 0, '0000-00-00 00:00:00'),
(654, 15, 6, 0, '0000-00-00 00:00:00'),
(655, 15, 7, 0, '0000-00-00 00:00:00'),
(656, 15, 8, 0, '0000-00-00 00:00:00'),
(657, 15, 9, 0, '0000-00-00 00:00:00'),
(658, 15, 10, 0, '0000-00-00 00:00:00'),
(659, 15, 11, 0, '0000-00-00 00:00:00'),
(660, 15, 12, 0, '0000-00-00 00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buddy_sessions`
--
ALTER TABLE `buddy_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `goal_daily_tracking`
--
ALTER TABLE `goal_daily_tracking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `goal_id` (`goal_id`,`day_number`),
  ADD KEY `idx_goal_id` (`goal_id`);

--
-- Indexes for table `habits`
--
ALTER TABLE `habits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `habit_daily_log`
--
ALTER TABLE `habit_daily_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification_settings`
--
ALTER TABLE `notification_settings`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `register`
--
ALTER TABLE `register`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tips`
--
ALTER TABLE `tips`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tip_history`
--
ALTER TABLE `tip_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trophies`
--
ALTER TABLE `trophies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_goals`
--
ALTER TABLE `user_goals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `habit_id` (`habit_id`);

--
-- Indexes for table `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_progress`
--
ALTER TABLE `user_progress`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `user_selected_habits`
--
ALTER TABLE `user_selected_habits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_trophies`
--
ALTER TABLE `user_trophies`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buddy_sessions`
--
ALTER TABLE `buddy_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `goal_daily_tracking`
--
ALTER TABLE `goal_daily_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `habits`
--
ALTER TABLE `habits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `habit_daily_log`
--
ALTER TABLE `habit_daily_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `register`
--
ALTER TABLE `register`
  MODIFY `id` int(190) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tips`
--
ALTER TABLE `tips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT for table `tip_history`
--
ALTER TABLE `tip_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `trophies`
--
ALTER TABLE `trophies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_goals`
--
ALTER TABLE `user_goals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `user_notifications`
--
ALTER TABLE `user_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_progress`
--
ALTER TABLE `user_progress`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user_selected_habits`
--
ALTER TABLE `user_selected_habits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `user_trophies`
--
ALTER TABLE `user_trophies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=661;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `goal_daily_tracking`
--
ALTER TABLE `goal_daily_tracking`
  ADD CONSTRAINT `fk_tracking_goal` FOREIGN KEY (`goal_id`) REFERENCES `user_goals` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_goals`
--
ALTER TABLE `user_goals`
  ADD CONSTRAINT `user_goals_ibfk_1` FOREIGN KEY (`habit_id`) REFERENCES `habits` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
