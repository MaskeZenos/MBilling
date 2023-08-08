CREATE TABLE `MBilling` (
  `id` int(255) NOT NULL,
  `TargetIdentifier` varchar(255) NOT NULL,
  `TargetName` varchar(255) NOT NULL,
  `SenderIdentifier` varchar(255) NOT NULL,
  `SenderName` varchar(255) NOT NULL,
  `raison` varchar(255) NOT NULL,
  `montant` int(255) NOT NULL,
  `job` varchar(255) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 0,
  `date` varchar(255) NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `MBilling`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `MBilling`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;
