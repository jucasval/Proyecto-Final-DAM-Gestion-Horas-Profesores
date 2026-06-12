-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: sql110.infinityfree.com
-- Tiempo de generación: 12-06-2026 a las 09:21:24
-- Versión del servidor: 11.4.12-MariaDB
-- Versión de PHP: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `if0_42009562_asignacion_horas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignacion`
--

CREATE TABLE `asignacion` (
  `id` int(11) NOT NULL,
  `curso_id` int(11) NOT NULL,
  `profesor_id` int(11) NOT NULL,
  `modulo_id` int(11) NOT NULL,
  `grupo_id` int(11) NOT NULL,
  `horas` decimal(4,1) NOT NULL DEFAULT 0.0,
  `es_desdoble` tinyint(1) NOT NULL DEFAULT 0,
  `observaciones` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `asignacion`
--

INSERT INTO `asignacion` (`id`, `curso_id`, `profesor_id`, `modulo_id`, `grupo_id`, `horas`, `es_desdoble`, `observaciones`) VALUES
(358, 1, 2, 97, 1, '5.0', 0, NULL),
(359, 1, 9, 97, 1, '3.0', 0, NULL),
(360, 1, 1, 98, 1, '6.0', 0, NULL),
(361, 1, 2, 98, 1, '1.0', 0, NULL),
(362, 1, 8, 99, 1, '8.0', 0, NULL),
(363, 1, 5, 99, 1, '4.0', 0, NULL),
(364, 1, 10, 100, 1, '3.0', 0, NULL),
(365, 1, 10, 101, 1, '1.0', 0, NULL),
(366, 1, 11, 102, 1, '3.0', 0, NULL),
(367, 1, 12, 103, 1, '2.0', 0, NULL),
(368, 1, 12, 110, 1, '3.0', 0, NULL),
(369, 1, 12, 111, 1, '1.0', 0, NULL),
(370, 1, 12, 112, 1, '2.0', 0, NULL),
(371, 1, 9, 107, 1, '7.0', 0, NULL),
(373, 1, 5, 97, 2, '5.0', 0, NULL),
(374, 1, 9, 97, 2, '1.0', 0, NULL),
(375, 1, 13, 105, 2, '6.0', 0, NULL),
(376, 1, 13, 106, 2, '4.0', 0, NULL),
(377, 1, 4, 107, 2, '7.0', 0, NULL),
(378, 1, 12, 108, 2, '3.0', 0, NULL),
(379, 1, 12, 110, 2, '3.0', 0, NULL),
(380, 1, 12, 109, 2, '3.0', 0, NULL),
(381, 1, 12, 112, 2, '1.0', 0, NULL),
(382, 1, 9, 107, 2, '7.0', 0, NULL),
(384, 1, 9, 97, 3, '5.0', 0, NULL),
(385, 1, 17, 97, 3, '3.0', 0, NULL),
(386, 1, 2, 103, 3, '2.0', 0, NULL),
(387, 1, 4, 98, 3, '6.0', 0, NULL),
(388, 1, 2, 98, 3, '1.0', 0, NULL),
(389, 1, 8, 98, 3, '2.0', 0, NULL),
(390, 1, 8, 99, 3, '8.0', 0, NULL),
(391, 1, 5, 99, 3, '4.0', 0, NULL),
(392, 1, 1, 100, 3, '3.0', 0, NULL),
(393, 1, 1, 101, 3, '1.0', 0, NULL),
(394, 1, 7, 102, 3, '3.0', 0, NULL),
(396, 1, 6, 113, 4, '7.0', 0, NULL),
(397, 1, 11, 114, 4, '2.0', 0, NULL),
(398, 1, 6, 112, 4, '2.0', 0, NULL),
(399, 1, 16, 115, 4, '6.0', 0, NULL),
(400, 1, 14, 116, 4, '5.0', 0, NULL),
(401, 1, 14, 110, 4, '3.0', 0, NULL),
(402, 1, 15, 103, 4, '1.0', 0, NULL),
(403, 1, 6, 107, 4, '7.0', 0, NULL),
(404, 1, 14, 107, 4, '0.0', 0, NULL),
(406, 1, 21, 117, 5, '7.0', 0, NULL),
(407, 1, 19, 117, 5, '3.0', 0, NULL),
(408, 1, 18, 117, 5, '1.0', 0, NULL),
(409, 1, 16, 118, 5, '3.0', 0, NULL),
(410, 1, 3, 103, 5, '1.0', 0, NULL),
(411, 1, 2, 103, 5, '1.0', 0, NULL),
(412, 1, 3, 119, 5, '6.0', 0, NULL),
(413, 1, 11, 119, 5, '3.0', 0, NULL),
(414, 1, 4, 120, 5, '6.0', 0, NULL),
(415, 1, 11, 120, 5, '3.0', 0, NULL),
(416, 1, 1, 100, 5, '3.0', 0, NULL),
(417, 1, 1, 101, 5, '1.0', 0, NULL),
(419, 1, 19, 121, 6, '8.0', 0, NULL),
(420, 1, 19, 112, 6, '1.0', 0, NULL),
(421, 1, 10, 112, 6, '1.0', 0, NULL),
(422, 1, 10, 122, 6, '5.0', 0, NULL),
(423, 1, 6, 123, 6, '4.0', 0, NULL),
(424, 1, 6, 124, 6, '3.0', 0, NULL),
(425, 1, 3, 125, 6, '3.0', 0, NULL),
(426, 1, 3, 110, 6, '3.0', 0, NULL),
(427, 1, 3, 103, 6, '1.0', 0, NULL),
(428, 1, 19, 107, 6, '0.0', 0, NULL),
(429, 1, 10, 107, 6, '7.0', 0, NULL),
(431, 1, 18, 126, 7, '6.0', 0, NULL),
(432, 1, 9, 126, 7, '1.0', 0, NULL),
(433, 1, 17, 126, 7, '1.0', 0, NULL),
(434, 1, 20, 126, 7, '1.0', 0, NULL),
(435, 1, 15, 127, 7, '5.0', 0, NULL),
(436, 1, 17, 128, 7, '7.0', 0, NULL),
(437, 1, 26, 128, 7, '4.0', 0, NULL),
(438, 1, 11, 103, 7, '2.0', 0, NULL),
(439, 1, 2, 142, 7, '1.0', 0, NULL),
(440, 1, 13, 129, 7, '7.0', 0, NULL),
(441, 1, 7, 129, 7, '3.0', 0, NULL),
(443, 1, 19, 130, 9, '6.0', 0, NULL),
(444, 1, 18, 130, 9, '3.0', 0, NULL),
(445, 1, 16, 110, 9, '3.0', 0, NULL),
(446, 1, 1, 131, 9, '4.0', 0, NULL),
(447, 1, 10, 132, 9, '4.0', 0, NULL),
(448, 1, 10, 133, 9, '6.0', 0, NULL),
(449, 1, 13, 133, 9, '3.0', 0, NULL),
(450, 1, 13, 112, 9, '2.0', 0, NULL),
(451, 1, 7, 103, 9, '1.0', 0, NULL),
(452, 1, 2, 103, 9, '1.0', 0, NULL),
(453, 1, 10, 107, 9, '7.0', 0, NULL),
(454, 1, 13, 107, 9, '7.0', 0, NULL),
(455, 1, 1, 107, 9, '7.0', 0, NULL),
(457, 1, 16, 126, 8, '6.0', 0, NULL),
(458, 1, 20, 127, 8, '5.0', 0, NULL),
(459, 1, 17, 128, 8, '7.0', 0, NULL),
(460, 1, 11, 103, 8, '1.0', 0, NULL),
(461, 1, 11, 129, 8, '7.0', 0, NULL),
(462, 1, 2, 142, 8, '1.0', 0, NULL),
(464, 1, 24, 134, 10, '9.0', 0, NULL),
(465, 1, 22, 135, 10, '7.0', 0, NULL),
(466, 1, 22, 103, 10, '1.0', 0, NULL),
(468, 1, 26, 136, 11, '10.0', 0, NULL),
(469, 1, 18, 137, 11, '8.0', 0, NULL),
(470, 1, 26, 112, 11, '2.0', 0, NULL),
(471, 1, 26, 103, 11, '1.0', 0, NULL),
(473, 1, 22, 134, 12, '9.0', 0, NULL),
(474, 1, 24, 135, 12, '7.0', 0, NULL),
(475, 1, 24, 103, 12, '1.0', 0, NULL),
(477, 1, 20, 138, 13, '10.0', 0, NULL),
(478, 1, 15, 137, 13, '8.0', 0, NULL),
(479, 1, 15, 112, 13, '2.0', 0, NULL),
(480, 1, 15, 103, 13, '1.0', 0, NULL),
(482, 1, 21, 134, 14, '9.0', 0, NULL),
(483, 1, 23, 135, 14, '7.0', 0, NULL),
(484, 1, 23, 138, 15, '10.0', 0, NULL),
(485, 1, 25, 137, 15, '8.0', 0, NULL),
(486, 1, 21, 112, 15, '1.0', 0, NULL),
(487, 1, 23, 112, 15, '1.0', 0, NULL),
(488, 1, 7, 139, 16, '2.0', 0, NULL),
(489, 1, 7, 139, 17, '2.0', 0, NULL),
(490, 1, 2, 139, 18, '2.0', 0, NULL),
(491, 1, 2, 140, 19, '3.0', 0, NULL),
(492, 1, 5, 140, 20, '3.0', 0, NULL),
(493, 1, 5, 141, 21, '2.0', 0, NULL),
(498, 26, 681, 923, 21, '2.0', 0, NULL),
(500, 1, 739, 124, 6, '3.0', 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargo`
--

CREATE TABLE `cargo` (
  `id` int(11) NOT NULL,
  `curso_id` int(11) NOT NULL DEFAULT 1,
  `nombre` varchar(100) NOT NULL,
  `horas` decimal(4,1) NOT NULL DEFAULT 0.0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `cargo`
--

INSERT INTO `cargo` (`id`, `curso_id`, `nombre`, `horas`) VALUES
(1, 1, 'Jefatura de Estudios', '10.0'),
(2, 1, 'Secretaría', '10.0'),
(3, 1, 'Coordinación TDE', '5.0'),
(4, 1, 'Escuela 4.0', '1.0'),
(5, 1, 'Jefatura Dpto. Internacional', '1.0'),
(6, 1, 'Reducción Mayores 55', '2.0'),
(7, 1, 'Liberado Sindical', '2.0'),
(15, 1, 'Tutor/a', '1.0'),
(104, 26, 'Coordinación TDE', '5.0'),
(105, 26, 'Escuela 4.0', '1.0'),
(106, 26, 'Jefatura de Estudios', '10.0'),
(107, 26, 'Jefatura Dpto. Internacional', '1.0'),
(108, 26, 'Liberado Sindical', '2.0'),
(109, 26, 'Reducción Mayores 55', '2.0'),
(110, 26, 'Secretaría', '10.0'),
(111, 26, 'Tutor/a', '1.0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `curso_escolar`
--

CREATE TABLE `curso_escolar` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `curso_escolar`
--

INSERT INTO `curso_escolar` (`id`, `nombre`, `fecha_inicio`, `fecha_fin`, `activo`) VALUES
(1, '2025-2026', '2025-09-01', '2026-06-30', 1),
(26, 'sdfadsw', '2026-06-14', '2026-06-26', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupo`
--

CREATE TABLE `grupo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `ciclo` varchar(20) NOT NULL,
  `curso` tinyint(4) NOT NULL,
  `modalidad` enum('Presencial','Semipresencial') NOT NULL DEFAULT 'Presencial'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `grupo`
--

INSERT INTO `grupo` (`id`, `nombre`, `ciclo`, `curso`, `modalidad`) VALUES
(5, '1º ASIR', 'ASIR', 1, 'Presencial'),
(21, '1º BTO G1', 'BTO', 1, 'Presencial'),
(1, '1º DAM', 'DAM', 1, 'Presencial'),
(3, '1º DAW', 'DAW', 1, 'Presencial'),
(16, '1º ESO G1', 'ESO', 1, 'Presencial'),
(10, '1º FPB IC', 'FPB', 1, 'Presencial'),
(12, '1º FPB OFICINA', 'FPB', 1, 'Presencial'),
(14, '1º FPB-E OFICINA', 'FPB', 1, 'Presencial'),
(7, '1º SMR A', 'SMR', 1, 'Presencial'),
(8, '1º SMR B', 'SMR', 1, 'Presencial'),
(6, '2º ASIR', 'ASIR', 2, 'Presencial'),
(2, '2º DAM', 'DAM', 2, 'Presencial'),
(4, '2º DAW', 'DAW', 2, 'Presencial'),
(17, '2º ESO G1', 'ESO', 2, 'Presencial'),
(11, '2º FPB IC', 'FPB', 2, 'Presencial'),
(13, '2º FPB OFICINA', 'FPB', 2, 'Presencial'),
(15, '2º FPB-E OFICINA', 'FPB', 2, 'Presencial'),
(9, '2º SMR A', 'SMR', 2, 'Presencial'),
(18, '3º ESO G1', 'ESO', 3, 'Presencial'),
(19, '4º ESO G1', 'ESO', 4, 'Presencial'),
(20, '4º ESO G2', 'ESO', 4, 'Presencial'),
(133, 'DAM-SP', 'DAM', 1, 'Semipresencial'),
(44, 'DAW-SP', 'DAW', 1, 'Semipresencial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupo_modulo`
--

CREATE TABLE `grupo_modulo` (
  `id` int(11) NOT NULL,
  `grupo_id` int(11) NOT NULL,
  `modulo_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `grupo_modulo`
--

INSERT INTO `grupo_modulo` (`id`, `grupo_id`, `modulo_id`) VALUES
(254, 1, 97),
(245, 1, 98),
(271, 1, 99),
(289, 1, 100),
(290, 1, 101),
(296, 1, 102),
(301, 1, 103),
(250, 1, 104),
(287, 1, 107),
(304, 1, 110),
(306, 1, 111),
(307, 1, 112),
(1219, 1, 879),
(1220, 1, 880),
(1221, 1, 881),
(1222, 1, 882),
(1223, 1, 883),
(1224, 1, 884),
(1225, 1, 885),
(1226, 1, 886),
(1227, 1, 889),
(1228, 1, 892),
(1229, 1, 893),
(1230, 1, 894),
(270, 2, 97),
(309, 2, 104),
(311, 2, 105),
(312, 2, 106),
(268, 2, 107),
(302, 2, 108),
(303, 2, 109),
(305, 2, 110),
(308, 2, 112),
(1231, 2, 879),
(1232, 2, 886),
(1233, 2, 887),
(1234, 2, 888),
(1235, 2, 889),
(1236, 2, 890),
(1237, 2, 891),
(1238, 2, 892),
(1239, 2, 894),
(286, 3, 97),
(255, 3, 98),
(272, 3, 99),
(246, 3, 100),
(248, 3, 101),
(281, 3, 102),
(256, 3, 103),
(285, 3, 104),
(1240, 3, 879),
(1241, 3, 880),
(1242, 3, 881),
(1243, 3, 882),
(1244, 3, 883),
(1245, 3, 884),
(1246, 3, 885),
(1247, 3, 886),
(316, 4, 103),
(275, 4, 104),
(276, 4, 107),
(314, 4, 110),
(277, 4, 112),
(278, 4, 113),
(299, 4, 114),
(323, 4, 115),
(315, 4, 116),
(1248, 4, 885),
(1249, 4, 886),
(1250, 4, 889),
(1251, 4, 892),
(1252, 4, 894),
(1253, 4, 895),
(1254, 4, 896),
(1255, 4, 897),
(1256, 4, 898),
(1425, 5, 101),
(1411, 5, 107),
(1412, 5, 131),
(1413, 5, 139),
(1424, 5, 142),
(1420, 5, 971),
(263, 6, 103),
(264, 6, 104),
(291, 6, 107),
(265, 6, 110),
(292, 6, 112),
(332, 6, 121),
(293, 6, 122),
(279, 6, 123),
(280, 6, 124),
(267, 6, 125),
(1257, 6, 885),
(1258, 6, 886),
(1259, 6, 889),
(1260, 6, 892),
(1261, 6, 894),
(1262, 6, 903),
(1263, 6, 904),
(1264, 6, 905),
(1265, 6, 906),
(1266, 6, 907),
(297, 7, 103),
(326, 7, 104),
(288, 7, 126),
(320, 7, 127),
(327, 7, 128),
(282, 7, 129),
(261, 7, 142),
(1267, 7, 885),
(1268, 7, 886),
(1269, 7, 908),
(1270, 7, 909),
(1271, 7, 910),
(1272, 7, 911),
(1273, 7, 924),
(298, 8, 103),
(333, 8, 104),
(325, 8, 126),
(334, 8, 127),
(328, 8, 128),
(300, 8, 129),
(262, 8, 142),
(1274, 8, 885),
(1275, 8, 886),
(1276, 8, 908),
(1277, 8, 909),
(1278, 8, 910),
(1279, 8, 911),
(1280, 8, 924),
(258, 9, 103),
(310, 9, 104),
(252, 9, 107),
(322, 9, 110),
(313, 9, 112),
(330, 9, 130),
(253, 9, 131),
(294, 9, 132),
(295, 9, 133),
(1281, 9, 885),
(1282, 9, 886),
(1283, 9, 889),
(1284, 9, 892),
(1285, 9, 894),
(1286, 9, 912),
(1287, 9, 913),
(1288, 9, 914),
(1289, 9, 915),
(339, 10, 103),
(340, 10, 104),
(347, 10, 134),
(342, 10, 135),
(1290, 10, 885),
(1291, 10, 886),
(1292, 10, 916),
(1293, 10, 917),
(350, 11, 103),
(351, 11, 104),
(352, 11, 112),
(353, 11, 136),
(331, 11, 137),
(1294, 11, 885),
(1295, 11, 886),
(1296, 11, 894),
(1297, 11, 918),
(1298, 11, 919),
(345, 12, 103),
(346, 12, 104),
(341, 12, 134),
(348, 12, 135),
(1299, 12, 885),
(1300, 12, 886),
(1301, 12, 916),
(1302, 12, 917),
(317, 13, 103),
(318, 13, 104),
(319, 13, 112),
(321, 13, 137),
(335, 13, 138),
(1303, 13, 885),
(1304, 13, 886),
(1305, 13, 894),
(1306, 13, 919),
(1307, 13, 920),
(336, 14, 104),
(338, 14, 134),
(343, 14, 135),
(1308, 14, 886),
(1309, 14, 916),
(1310, 14, 917),
(1427, 16, 107),
(283, 16, 139),
(284, 17, 139),
(1312, 17, 921),
(260, 19, 140),
(1313, 19, 922),
(274, 21, 141),
(1314, 21, 923),
(1414, 133, 110);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulo`
--

CREATE TABLE `modulo` (
  `id` int(11) NOT NULL,
  `curso_id` int(11) NOT NULL DEFAULT 1,
  `nombre` varchar(200) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `horas_pes` decimal(4,1) DEFAULT 0.0,
  `horas_ptfp` decimal(4,1) DEFAULT 0.0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `modulo`
--

INSERT INTO `modulo` (`id`, `curso_id`, `nombre`, `codigo`, `horas_pes`, `horas_ptfp`) VALUES
(97, 1, 'Sistemas Informáticos', 'SI', '0.0', '5.0'),
(98, 1, 'Bases de datos', 'BD', '6.0', '0.0'),
(99, 1, 'Programación', 'PROG', '8.0', '0.0'),
(100, 1, 'Lenguajes de marcas y Sistemas de Gestión de la Información', 'LMSGI', '3.0', '0.0'),
(101, 1, 'Digitalización Aplicada al Sistema Productivo', 'DIG', '1.0', '0.0'),
(102, 1, 'Entornos de desarrollo', 'ED', '3.0', '0.0'),
(103, 1, 'Coord. y Seguim. FP Dual', 'DUAL', '2.0', '0.0'),
(104, 1, 'Tutor/a', 'TUT', '0.0', '0.0'),
(105, 1, 'Desarrollo de interfaces', 'DI', '0.0', '6.0'),
(106, 1, 'Sistemas de gestión empresarial', 'SGE', '0.0', '4.0'),
(107, 1, 'Acceso a datos', 'AD', '7.0', '0.0'),
(108, 1, 'Programación multimedia y de dispositivos móviles', 'PMDM', '3.0', '0.0'),
(109, 1, 'Programación de servicios y procesos', 'PSP', '3.0', '0.0'),
(110, 1, 'Optativa', 'OPT', '3.0', '0.0'),
(111, 1, 'Proyecto', 'PROY', '1.0', '0.0'),
(112, 1, 'FCT', 'FCT', '0.0', '2.0'),
(113, 1, 'Desarrollo web en entorno servidor', 'DWES', '7.0', '0.0'),
(114, 1, 'Despliegue de aplicaciones web', 'DAW', '2.0', '0.0'),
(115, 1, 'Desarrollo web en entorno cliente', 'DWEC', '0.0', '6.0'),
(116, 1, 'Diseño de interfaces web', 'DIW', '0.0', '5.0'),
(117, 1, 'Implantación de sistemas operativos', 'ISO', '0.0', '7.0'),
(118, 1, 'Fundamentos Hardware', 'FH', '0.0', '3.0'),
(119, 1, 'Planificación y Administración de Redes', 'PAR', '6.0', '0.0'),
(120, 1, 'Gestión de Bases de Datos', 'GBD', '6.0', '0.0'),
(121, 1, 'Administración de sistemas operativos', 'ASO', '0.0', '8.0'),
(122, 1, 'Servicios en red e Internet', 'SRI', '5.0', '0.0'),
(123, 1, 'Implantación de aplicaciones Web', 'IAW', '4.0', '0.0'),
(124, 1, 'Administración de sistemas gestores de bases de datos', 'ASGBD', '3.0', '0.0'),
(125, 1, 'Seguridad y Alta disponibilidad', 'SAD', '3.0', '0.0'),
(126, 1, 'Montaje y mantenimiento de equipos', 'MME', '0.0', '6.0'),
(127, 1, 'Sistemas operativos monopuesto', 'SOM', '0.0', '5.0'),
(128, 1, 'Aplicaciones ofimáticas', 'AO', '0.0', '7.0'),
(129, 1, 'Redes Locales', 'RL', '7.0', '0.0'),
(130, 1, 'Sistemas Operativos en red', 'SOR', '0.0', '6.0'),
(131, 1, 'Aplicaciones web', 'AW', '4.0', '0.0'),
(132, 1, 'Seguridad Informática', 'SEGINFO', '4.0', '0.0'),
(133, 1, 'Servicios en red', 'SR', '6.0', '0.0'),
(134, 1, 'Montaje y mantenimiento de sistemas y componentes informáticos', 'MMSCI', '0.0', '9.0'),
(135, 1, 'Operaciones auxiliares para la configuración y explotación', 'OACE', '0.0', '7.0'),
(136, 1, 'Equipos electrónicos y eléctricos', 'EEE', '0.0', '10.0'),
(137, 1, 'Instalación y mantenimiento de redes para transmisión de datos', 'IMRD', '0.0', '8.0'),
(138, 1, 'Ofimática y archivo de documentos', 'OAD', '0.0', '10.0'),
(139, 1, 'Computación y Robótica', 'COMP', '2.0', '0.0'),
(140, 1, 'Digitalización', 'DIGIT', '3.0', '0.0'),
(141, 1, 'Creación Digital y Pensamiento Computacional', 'CDPC', '2.0', '0.0'),
(142, 1, 'Digitalización Aplicada a los Sistemas Productivos', 'DIG-SMR', '1.0', '0.0'),
(879, 26, 'Sistemas Informáticos', 'SI', '0.0', '5.0'),
(880, 26, 'Bases de datos', 'BD', '6.0', '0.0'),
(881, 26, 'Programación', 'PROG', '8.0', '0.0'),
(882, 26, 'Lenguajes de marcas y Sistemas de Gestión de la Información', 'LMSGI', '3.0', '0.0'),
(883, 26, 'Digitalización Aplicada al Sistema Productivo', 'DIG', '1.0', '0.0'),
(884, 26, 'Entornos de desarrollo', 'ED', '3.0', '0.0'),
(885, 26, 'Coord. y Seguim. FP Dual', 'DUAL', '2.0', '0.0'),
(886, 26, 'Tutor/a', 'TUT', '0.0', '0.0'),
(887, 26, 'Desarrollo de interfaces', 'DI', '0.0', '6.0'),
(888, 26, 'Sistemas de gestión empresarial', 'SGE', '0.0', '4.0'),
(889, 26, 'Acceso a datos', 'AD', '4.0', '0.0'),
(890, 26, 'Programación multimedia y de dispositivos móviles', 'PMDM', '3.0', '0.0'),
(891, 26, 'Programación de servicios y procesos', 'PSP', '3.0', '0.0'),
(892, 26, 'Optativa', 'OPT', '3.0', '0.0'),
(893, 26, 'Proyecto', 'PROY', '1.0', '0.0'),
(894, 26, 'FCT', 'FCT', '0.0', '2.0'),
(895, 26, 'Desarrollo web en entorno servidor', 'DWES', '7.0', '0.0'),
(896, 26, 'Despliegue de aplicaciones web', 'DAW', '2.0', '0.0'),
(897, 26, 'Desarrollo web en entorno cliente', 'DWEC', '0.0', '6.0'),
(898, 26, 'Diseño de interfaces web', 'DIW', '0.0', '5.0'),
(899, 26, 'Implantación de sistemas operativos', 'ISO', '0.0', '7.0'),
(900, 26, 'Fundamentos Hardware', 'FH', '0.0', '3.0'),
(901, 26, 'Planificación y Administración de Redes', 'PAR', '6.0', '0.0'),
(902, 26, 'Gestión de Bases de Datos', 'GBD', '6.0', '0.0'),
(903, 26, 'Administración de sistemas operativos', 'ASO', '0.0', '8.0'),
(904, 26, 'Servicios en red e Internet', 'SRI', '5.0', '0.0'),
(905, 26, 'Implantación de aplicaciones Web', 'IAW', '4.0', '0.0'),
(906, 26, 'Administración de sistemas gestores de bases de datos', 'ASGBD', '3.0', '0.0'),
(907, 26, 'Seguridad y Alta disponibilidad', 'SAD', '3.0', '0.0'),
(908, 26, 'Montaje y mantenimiento de equipos', 'MME', '0.0', '6.0'),
(909, 26, 'Sistemas operativos monopuesto', 'SOM', '0.0', '5.0'),
(910, 26, 'Aplicaciones ofimáticas', 'AO', '0.0', '7.0'),
(911, 26, 'Redes Locales', 'RL', '7.0', '0.0'),
(912, 26, 'Sistemas Operativos en red', 'SOR', '0.0', '6.0'),
(913, 26, 'Aplicaciones web', 'AW', '4.0', '0.0'),
(914, 26, 'Seguridad Informática', 'SEGINFO', '4.0', '0.0'),
(915, 26, 'Servicios en red', 'SR', '6.0', '0.0'),
(916, 26, 'Montaje y mantenimiento de sistemas y componentes informáticos', 'MMSCI', '0.0', '9.0'),
(917, 26, 'Operaciones auxiliares para la configuración y explotación', 'OACE', '0.0', '7.0'),
(918, 26, 'Equipos electrónicos y eléctricos', 'EEE', '0.0', '10.0'),
(919, 26, 'Instalación y mantenimiento de redes para transmisión de datos', 'IMRD', '0.0', '8.0'),
(920, 26, 'Ofimática y archivo de documentos', 'OAD', '0.0', '10.0'),
(921, 26, 'Computación y Robótica', 'COMP', '2.0', '0.0'),
(922, 26, 'Digitalización', 'DIGIT', '3.0', '0.0'),
(923, 26, 'Creación Digital y Pensamiento Computacional', 'CDPC', '2.0', '0.0'),
(924, 26, 'Digitalización Aplicada a los Sistemas Productivos', 'DIG-SMR', '1.0', '0.0'),
(971, 1, 'modulo 1', NULL, '0.0', '0.0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesor`
--

CREATE TABLE `profesor` (
  `id` int(11) NOT NULL,
  `curso_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(150) NOT NULL,
  `puesto` enum('PES','PTFP') NOT NULL,
  `horas_totales` int(11) DEFAULT 18
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `profesor`
--

INSERT INTO `profesor` (`id`, `curso_id`, `nombre`, `apellidos`, `puesto`, `horas_totales`) VALUES
(1, 1, 'Ana', 'García Pérez', 'PES', 18),
(2, 1, 'Luis', 'Martínez Ruiz', 'PES', 18),
(3, 1, 'Carmen', 'López Díaz', 'PES', 18),
(4, 1, 'Javier', 'Sánchez Gómez', 'PES', 18),
(5, 1, 'Elena', 'Fernández Moreno', 'PES', 18),
(6, 1, 'Miguel', 'Rodríguez Núñez', 'PES', 18),
(7, 1, 'Lucía', 'González Ortega', 'PES', 18),
(8, 1, 'Pablo', 'Hernández Vega', 'PES', 18),
(9, 1, 'Marta', 'Jiménez Castro', 'PES', 18),
(10, 1, 'Sergio', 'Díaz Romero', 'PES', 18),
(11, 1, 'Laura', 'Moreno Gil', 'PES', 18),
(12, 1, 'Daniel', 'Muñoz Serrano', 'PES', 18),
(13, 1, 'Cristina', 'Álvarez Ramos', 'PES', 18),
(14, 1, 'Alberto', 'Romero Flores', 'PTFP', 18),
(15, 1, 'Raquel', 'Navarro Cano', 'PTFP', 16),
(16, 1, 'Andrés', 'Torres Molina', 'PTFP', 18),
(17, 1, 'Beatriz', 'Domínguez Rubio', 'PTFP', 18),
(18, 1, 'Óscar', 'Vázquez Soto', 'PTFP', 18),
(19, 1, 'Silvia', 'Ramos Pascual', 'PTFP', 18),
(20, 1, 'Jorge', 'Gil Iglesias', 'PTFP', 18),
(21, 1, 'Nuria', 'Serrano Medina', 'PTFP', 18),
(22, 1, 'Iván', 'Blanco Garrido', 'PTFP', 18),
(23, 1, 'Patricia', 'Suárez Cortés', 'PTFP', 18),
(24, 1, 'Rubén', 'Molina Santos', 'PTFP', 18),
(25, 1, 'Eva', 'Ortega Lozano', 'PTFP', 18),
(26, 1, 'Víctor', 'Delgado Marín', 'PTFP', 18),
(185, 1, 'Sonia', 'Castro Vidal', 'PES', 18),
(186, 1, 'Adrián', 'Rubio Calvo', 'PTFP', 18),
(215, 1, 'Isabel', 'Marín Pastor', 'PES', 18),
(680, 26, 'Hugo', 'Iglesias Bravo', 'PES', 18),
(681, 26, 'Teresa', 'Pastor Aguilar', 'PES', 18),
(682, 26, 'Mario', 'Vidal Crespo', 'PES', 18),
(683, 26, 'Alicia', 'Santos Reyes', 'PES', 18),
(684, 26, 'Raúl', 'Lozano Herrera', 'PES', 18),
(685, 26, 'Pilar', 'Aguilar Méndez', 'PES', 18),
(686, 26, 'Ana', 'García Pérez', 'PES', 18),
(687, 26, 'Luis', 'Martínez Ruiz', 'PES', 18),
(688, 26, 'Carmen', 'López Díaz', 'PES', 18),
(689, 26, 'Javier', 'Sánchez Gómez', 'PES', 18),
(690, 26, 'Elena', 'Fernández Moreno', 'PES', 18),
(691, 26, 'Miguel', 'Rodríguez Núñez', 'PES', 18),
(692, 26, 'Lucía', 'González Ortega', 'PES', 18),
(693, 26, 'Pablo', 'Hernández Vega', 'PTFP', 18),
(694, 26, 'Marta', 'Jiménez Castro', 'PTFP', 16),
(695, 26, 'Sergio', 'Díaz Romero', 'PTFP', 18),
(696, 26, 'Laura', 'Moreno Gil', 'PTFP', 18),
(697, 26, 'Daniel', 'Muñoz Serrano', 'PTFP', 18),
(698, 26, 'Cristina', 'Álvarez Ramos', 'PTFP', 18),
(699, 26, 'Alberto', 'Romero Flores', 'PTFP', 18),
(700, 26, 'Raquel', 'Navarro Cano', 'PTFP', 18),
(701, 26, 'Andrés', 'Torres Molina', 'PTFP', 18),
(702, 26, 'Beatriz', 'Domínguez Rubio', 'PTFP', 18),
(703, 26, 'Óscar', 'Vázquez Soto', 'PTFP', 18),
(704, 26, 'Silvia', 'Ramos Pascual', 'PTFP', 18),
(705, 26, 'Jorge', 'Gil Iglesias', 'PTFP', 18),
(706, 26, 'Nuria', 'Serrano Medina', 'PES', 18),
(707, 26, 'Iván', 'Blanco Garrido', 'PTFP', 18),
(708, 26, 'Patricia', 'Suárez Cortés', 'PES', 18),
(738, 1, 'Rubén', 'Molina Santos', 'PES', 54),
(739, 1, 'Eva', 'Ortega Lozano', 'PES', 18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesor_cargo`
--

CREATE TABLE `profesor_cargo` (
  `id` int(11) NOT NULL,
  `curso_id` int(11) NOT NULL,
  `profesor_id` int(11) NOT NULL,
  `cargo_id` int(11) NOT NULL,
  `horas` decimal(4,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `profesor_cargo`
--

INSERT INTO `profesor_cargo` (`id`, `curso_id`, `profesor_id`, `cargo_id`, `horas`) VALUES
(3, 1, 12, 1, '10.0'),
(4, 1, 11, 3, '5.0'),
(10, 1, 9, 15, '1.0'),
(12, 1, 8, 15, '1.0'),
(13, 1, 6, 15, '1.0'),
(16, 1, 17, 15, '1.0'),
(17, 1, 20, 15, '1.0'),
(18, 1, 13, 15, '1.0'),
(20, 1, 26, 15, '1.0'),
(23, 1, 21, 15, '1.0'),
(26, 1, 22, 5, '1.0'),
(37, 1, 18, 4, '1.0'),
(42, 1, 8, 3, '5.0'),
(123, 26, 691, 106, '10.0'),
(124, 26, 690, 104, '5.0'),
(125, 26, 701, 107, '1.0'),
(126, 26, 697, 105, '1.0'),
(127, 26, 687, 104, '5.0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `username`, `password`, `nombre`, `activo`, `created_at`) VALUES
(1, 'admin', '$2y$10$S5CiHeA9uBRFtEZ3SN5clO.ItSnTCB6FWnwlItqPPSKkqHd/l4v6S', 'Administrador', 1, '2026-06-06 14:06:51'),
(2, 'jucasval', '$2y$10$S5CiHeA9uBRFtEZ3SN5clO.ItSnTCB6FWnwlItqPPSKkqHd/l4v6S', 'Juan Fran', 1, '2026-06-06 14:07:52');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignacion`
--
ALTER TABLE `asignacion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_asignacion` (`curso_id`,`profesor_id`,`modulo_id`,`grupo_id`),
  ADD KEY `profesor_id` (`profesor_id`),
  ADD KEY `modulo_id` (`modulo_id`),
  ADD KEY `grupo_id` (`grupo_id`);

--
-- Indices de la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `curso_id` (`curso_id`,`nombre`);

--
-- Indices de la tabla `curso_escolar`
--
ALTER TABLE `curso_escolar`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `grupo`
--
ALTER TABLE `grupo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_grupo` (`nombre`,`ciclo`,`curso`,`modalidad`);

--
-- Indices de la tabla `grupo_modulo`
--
ALTER TABLE `grupo_modulo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_grupo_modulo` (`grupo_id`,`modulo_id`),
  ADD KEY `modulo_id` (`modulo_id`);

--
-- Indices de la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `curso_id` (`curso_id`);

--
-- Indices de la tabla `profesor`
--
ALTER TABLE `profesor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `curso_id` (`curso_id`);

--
-- Indices de la tabla `profesor_cargo`
--
ALTER TABLE `profesor_cargo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `curso_id` (`curso_id`),
  ADD KEY `profesor_id` (`profesor_id`),
  ADD KEY `cargo_id` (`cargo_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asignacion`
--
ALTER TABLE `asignacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=501;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT de la tabla `curso_escolar`
--
ALTER TABLE `curso_escolar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `grupo`
--
ALTER TABLE `grupo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=250;

--
-- AUTO_INCREMENT de la tabla `grupo_modulo`
--
ALTER TABLE `grupo_modulo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1429;

--
-- AUTO_INCREMENT de la tabla `modulo`
--
ALTER TABLE `modulo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=973;

--
-- AUTO_INCREMENT de la tabla `profesor`
--
ALTER TABLE `profesor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=740;

--
-- AUTO_INCREMENT de la tabla `profesor_cargo`
--
ALTER TABLE `profesor_cargo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignacion`
--
ALTER TABLE `asignacion`
  ADD CONSTRAINT `asignacion_ibfk_1` FOREIGN KEY (`curso_id`) REFERENCES `curso_escolar` (`id`),
  ADD CONSTRAINT `asignacion_ibfk_2` FOREIGN KEY (`profesor_id`) REFERENCES `profesor` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `asignacion_ibfk_3` FOREIGN KEY (`modulo_id`) REFERENCES `modulo` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `asignacion_ibfk_4` FOREIGN KEY (`grupo_id`) REFERENCES `grupo` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD CONSTRAINT `cargo_ibfk_1` FOREIGN KEY (`curso_id`) REFERENCES `curso_escolar` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `grupo_modulo`
--
ALTER TABLE `grupo_modulo`
  ADD CONSTRAINT `grupo_modulo_ibfk_1` FOREIGN KEY (`grupo_id`) REFERENCES `grupo` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grupo_modulo_ibfk_2` FOREIGN KEY (`modulo_id`) REFERENCES `modulo` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD CONSTRAINT `modulo_ibfk_1` FOREIGN KEY (`curso_id`) REFERENCES `curso_escolar` (`id`);

--
-- Filtros para la tabla `profesor`
--
ALTER TABLE `profesor`
  ADD CONSTRAINT `profesor_ibfk_1` FOREIGN KEY (`curso_id`) REFERENCES `curso_escolar` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `profesor_cargo`
--
ALTER TABLE `profesor_cargo`
  ADD CONSTRAINT `profesor_cargo_ibfk_1` FOREIGN KEY (`curso_id`) REFERENCES `curso_escolar` (`id`),
  ADD CONSTRAINT `profesor_cargo_ibfk_2` FOREIGN KEY (`profesor_id`) REFERENCES `profesor` (`id`),
  ADD CONSTRAINT `profesor_cargo_ibfk_3` FOREIGN KEY (`cargo_id`) REFERENCES `cargo` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
