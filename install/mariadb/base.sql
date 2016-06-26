-- phpMyAdmin SQL Dump
-- version 4.6.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Czas generowania: 26 Cze 2016, 15:50
-- Wersja serwera: 10.0.25-MariaDB-0+deb8u1
-- Wersja PHP: 5.6.22-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Baza danych: `openhcp`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `client`
--

CREATE TABLE `client` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'client ID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gid` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `client_data`
--

CREATE TABLE `client_data` (
  `client_id` int(10) UNSIGNED NOT NULL COMMENT 'client ID',
  `data_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ftp`
--

CREATE TABLE `ftp` (
  `id` int(10) UNSIGNED NOT NULL,
  `uiddb_uid` int(10) UNSIGNED NOT NULL,
  `login` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `directory` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quota_files` int(11) DEFAULT NULL,
  `quota_size` int(11) DEFAULT NULL,
  `upload_ratio` int(11) DEFAULT NULL,
  `download_ratio` int(11) DEFAULT NULL,
  `upload_bandwidth` int(11) DEFAULT NULL COMMENT 'KB/s',
  `download_bandwidth` int(11) DEFAULT NULL COMMENT 'KB/s',
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `http`
--

CREATE TABLE `http` (
  `id` int(10) UNSIGNED NOT NULL,
  `uiddb_uid` int(10) UNSIGNED NOT NULL,
  `directory` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mail_access`
--

CREATE TABLE `mail_access` (
  `id` int(10) UNSIGNED NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL,
  `type` enum('recipient','sender','client','') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mail_domain`
--

CREATE TABLE `mail_domain` (
  `id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mail_forwarding`
--

CREATE TABLE `mail_forwarding` (
  `id` int(11) UNSIGNED NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mail_relay_recipient`
--

CREATE TABLE `mail_relay_recipient` (
  `id` int(10) UNSIGNED NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mail_transport`
--

CREATE TABLE `mail_transport` (
  `id` int(10) UNSIGNED NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transport` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mail_user`
--

CREATE TABLE `mail_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `uiddb_uid` int(10) UNSIGNED NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `maildir` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quota` bigint(20) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `server`
--

CREATE TABLE `server` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `spamfilter_policy`
--

CREATE TABLE `spamfilter_policy` (
  `id` int(11) UNSIGNED NOT NULL,
  `policy_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `virus_lover` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_lover` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unchecked_lover` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banned_files_lover` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bad_header_lover` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bypass_virus_checks` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bypass_spam_checks` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bypass_banned_checks` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bypass_header_checks` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_modifies_subj` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `virus_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banned_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unchecked_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bad_header_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `clean_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `archive_quarantine_to` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_tag_level` float DEFAULT NULL,
  `spam_tag2_level` float DEFAULT NULL,
  `spam_tag3_level` float DEFAULT NULL,
  `spam_kill_level` float DEFAULT NULL,
  `spam_dsn_cutoff_level` float DEFAULT NULL,
  `spam_quarantine_cutoff_level` float DEFAULT NULL,
  `addr_extension_virus` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `addr_extension_spam` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `addr_extension_banned` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `addr_extension_bad_header` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warnvirusrecip` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warnbannedrecip` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warnbadhrecip` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `newvirus_admin` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `virus_admin` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banned_admin` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bad_header_admin` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_admin` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_subject_tag` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_subject_tag2` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spam_subject_tag3` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message_size_limit` int(11) UNSIGNED DEFAULT NULL,
  `banned_rulenames` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `disclaimer_options` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forward_method` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sa_userconf` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sa_username` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `spamfilter_policy`
--

INSERT INTO `spamfilter_policy` (`id`, `policy_name`, `virus_lover`, `spam_lover`, `unchecked_lover`, `banned_files_lover`, `bad_header_lover`, `bypass_virus_checks`, `bypass_spam_checks`, `bypass_banned_checks`, `bypass_header_checks`, `spam_modifies_subj`, `virus_quarantine_to`, `spam_quarantine_to`, `banned_quarantine_to`, `unchecked_quarantine_to`, `bad_header_quarantine_to`, `clean_quarantine_to`, `archive_quarantine_to`, `spam_tag_level`, `spam_tag2_level`, `spam_tag3_level`, `spam_kill_level`, `spam_dsn_cutoff_level`, `spam_quarantine_cutoff_level`, `addr_extension_virus`, `addr_extension_spam`, `addr_extension_banned`, `addr_extension_bad_header`, `warnvirusrecip`, `warnbannedrecip`, `warnbadhrecip`, `newvirus_admin`, `virus_admin`, `banned_admin`, `bad_header_admin`, `spam_admin`, `spam_subject_tag`, `spam_subject_tag2`, `spam_subject_tag3`, `message_size_limit`, `banned_rulenames`, `disclaimer_options`, `forward_method`, `sa_userconf`, `sa_username`) VALUES
(1, 'Non-paying', 'N', 'N', NULL, 'N', 'N', 'Y', 'Y', 'Y', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 7, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Uncensored', 'Y', 'Y', NULL, 'Y', 'Y', 'N', 'N', 'N', 'N', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, -9999, 9999, NULL, 9999, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'Wants all spam', 'N', 'Y', NULL, 'N', 'N', 'N', 'N', 'N', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, -9999, 9999, NULL, 9999, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'Wants viruses', 'Y', 'N', NULL, 'Y', 'Y', 'N', 'N', 'N', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6.9, NULL, 6.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 'Normal', 'N', 'N', NULL, 'N', 'N', 'N', 'N', 'N', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6.9, NULL, 6.9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'Trigger happy', 'N', 'N', NULL, 'N', 'N', 'N', 'N', 'N', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 5, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'Permissive', 'N', 'N', NULL, 'N', 'Y', 'N', 'N', 'N', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 10, NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, '6.5/7.8', 'N', 'N', NULL, 'N', 'N', 'N', 'N', 'N', 'N', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6.5, NULL, 7.8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 'userB', 'N', 'N', NULL, 'N', 'Y', 'N', 'N', 'N', 'N', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6.3, NULL, 6.3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 'userC', 'N', 'N', NULL, 'N', 'N', 'N', 'N', 'N', 'N', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 6, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'userD', 'Y', 'N', NULL, 'Y', 'Y', 'N', 'N', 'N', 'N', 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 7, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `spamfilter_users`
--

CREATE TABLE `spamfilter_users` (
  `id` int(11) UNSIGNED NOT NULL,
  `priority` tinyint(3) UNSIGNED NOT NULL DEFAULT '7',
  `policy_id` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fullname` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `local` enum('N','Y') COLLATE utf8mb4_unicode_ci DEFAULT 'Y'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `spamfilter_wblist`
--

CREATE TABLE `spamfilter_wblist` (
  `wblist_id` int(11) UNSIGNED NOT NULL,
  `wb` enum('W','B') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'W',
  `rid` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `priority` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uiddb`
--

CREATE TABLE `uiddb` (
  `uid` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQUE` (`gid`);

--
-- Indexes for table `client_data`
--
ALTER TABLE `client_data`
  ADD UNIQUE KEY `UNIQUE` (`client_id`,`data_key`);

--
-- Indexes for table `ftp`
--
ALTER TABLE `ftp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `INDEX` (`uiddb_uid`);

--
-- Indexes for table `http`
--
ALTER TABLE `http`
  ADD PRIMARY KEY (`id`),
  ADD KEY `INDEX` (`uiddb_uid`) USING BTREE;

--
-- Indexes for table `mail_access`
--
ALTER TABLE `mail_access`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mail_domain`
--
ALTER TABLE `mail_domain`
  ADD PRIMARY KEY (`id`),
  ADD KEY `INDEX` (`client_id`,`active`);

--
-- Indexes for table `mail_forwarding`
--
ALTER TABLE `mail_forwarding`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mail_relay_recipient`
--
ALTER TABLE `mail_relay_recipient`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mail_transport`
--
ALTER TABLE `mail_transport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mail_user`
--
ALTER TABLE `mail_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `INDEX` (`id`,`uiddb_uid`,`quota`,`active`),
  ADD KEY `uiddb_uid` (`uiddb_uid`);

--
-- Indexes for table `server`
--
ALTER TABLE `server`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `spamfilter_policy`
--
ALTER TABLE `spamfilter_policy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `spamfilter_users`
--
ALTER TABLE `spamfilter_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `INDEX` (`priority`,`policy_id`),
  ADD KEY `policy_id` (`policy_id`);

--
-- Indexes for table `spamfilter_wblist`
--
ALTER TABLE `spamfilter_wblist`
  ADD PRIMARY KEY (`wblist_id`),
  ADD UNIQUE KEY `INDEX` (`rid`,`priority`,`active`);

--
-- Indexes for table `uiddb`
--
ALTER TABLE `uiddb`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `INDEX` (`client_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `client`
--
ALTER TABLE `client`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'client ID', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT dla tabeli `ftp`
--
ALTER TABLE `ftp`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT dla tabeli `http`
--
ALTER TABLE `http`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT dla tabeli `mail_access`
--
ALTER TABLE `mail_access`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `mail_domain`
--
ALTER TABLE `mail_domain`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT dla tabeli `mail_forwarding`
--
ALTER TABLE `mail_forwarding`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `mail_relay_recipient`
--
ALTER TABLE `mail_relay_recipient`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `mail_transport`
--
ALTER TABLE `mail_transport`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `mail_user`
--
ALTER TABLE `mail_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT dla tabeli `server`
--
ALTER TABLE `server`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `spamfilter_policy`
--
ALTER TABLE `spamfilter_policy`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT dla tabeli `spamfilter_users`
--
ALTER TABLE `spamfilter_users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT dla tabeli `spamfilter_wblist`
--
ALTER TABLE `spamfilter_wblist`
  MODIFY `wblist_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `uiddb`
--
ALTER TABLE `uiddb`
  MODIFY `uid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;
--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `client_data`
--
ALTER TABLE `client_data`
  ADD CONSTRAINT `client_data_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `ftp`
--
ALTER TABLE `ftp`
  ADD CONSTRAINT `ftp_ibfk_1` FOREIGN KEY (`uiddb_uid`) REFERENCES `uiddb` (`uid`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `http`
--
ALTER TABLE `http`
  ADD CONSTRAINT `http_ibfk_1` FOREIGN KEY (`uiddb_uid`) REFERENCES `uiddb` (`uid`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `mail_domain`
--
ALTER TABLE `mail_domain`
  ADD CONSTRAINT `mail_domain_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `mail_user`
--
ALTER TABLE `mail_user`
  ADD CONSTRAINT `mail_user_ibfk_1` FOREIGN KEY (`uiddb_uid`) REFERENCES `uiddb` (`uid`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `spamfilter_users`
--
ALTER TABLE `spamfilter_users`
  ADD CONSTRAINT `spamfilter_users_ibfk_1` FOREIGN KEY (`policy_id`) REFERENCES `spamfilter_policy` (`id`);

--
-- Ograniczenia dla tabeli `spamfilter_wblist`
--
ALTER TABLE `spamfilter_wblist`
  ADD CONSTRAINT `spamfilter_wblist_ibfk_1` FOREIGN KEY (`rid`) REFERENCES `spamfilter_users` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `uiddb`
--
ALTER TABLE `uiddb`
  ADD CONSTRAINT `uiddb_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE;
