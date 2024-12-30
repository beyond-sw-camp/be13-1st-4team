-- 테이블 생성 sql

-- 회원

CREATE TABLE `member` (
	`member_no` INT(11) NOT NULL AUTO_INCREMENT,
	`member_code` CHAR(1) NOT NULL DEFAULT '1' COMMENT '일반회원:1/ 가게 주인:2/관리자:3' COLLATE 'utf8mb3_general_ci',
	`email` VARCHAR(100) NOT NULL COMMENT '회원 이메일' COLLATE 'utf8mb3_general_ci',
	`password` VARCHAR(100) NOT NULL COMMENT '회원 비밀번호' COLLATE 'utf8mb3_general_ci',
	`name` VARCHAR(100) NOT NULL COMMENT '회원이름' COLLATE 'utf8mb3_general_ci',
	`nickname` VARCHAR(100) NOT NULL COMMENT '회원 닉네임' COLLATE 'utf8mb3_general_ci',
	`identity_no` VARCHAR(20) NOT NULL COMMENT '주민등록번호' COLLATE 'utf8mb3_general_ci',
	`phone` VARCHAR(20) NOT NULL COMMENT '전화번호' COLLATE 'utf8mb3_general_ci',
	`profile_img` VARCHAR(900) NULL DEFAULT NULL COMMENT '프로필 이미지 (경로 저장)' COLLATE 'utf8mb3_general_ci',
	`address` VARCHAR(1000) NOT NULL COMMENT '회원 주소' COLLATE 'utf8mb3_general_ci',
	`enroll_date` DATE NOT NULL DEFAULT curdate() COMMENT '회원 가입일',
	`manner_total_score` INT(11) NOT NULL DEFAULT '25' COMMENT '매너 온도',
	`status` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '회원 탈퇴 여부 (Y / N / W) 관리자 승인 전까지 W 상태' COLLATE 'utf8mb3_general_ci',
	`member_flag` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '회원 경고 횟수 3회',
	PRIMARY KEY (`member_no`) USING BTREE,
	CONSTRAINT `CONSTRAINT_1` CHECK (`status` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`member_code` in ('1','2','3')),
	CONSTRAINT `CONSTRAINT_3` CHECK (`status` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_4` CHECK (`member_code` in ('1','2','3'))
)

/* COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=16008
;
*/


-- 가게

CREATE TABLE `stores` (
	`store_no` INT(11) NOT NULL AUTO_INCREMENT,
	`store_name` VARCHAR(150) NOT NULL COMMENT '가게 이름' COLLATE 'utf8mb3_general_ci',
	`store_address` VARCHAR(1000) NOT NULL COMMENT '가게 주소' COLLATE 'utf8mb3_general_ci',
	`phone` VARCHAR(20) NOT NULL COMMENT '가게 전화번호' COLLATE 'utf8mb3_general_ci',
	`store_info` VARCHAR(3000) NULL DEFAULT NULL COMMENT '가게 소개' COLLATE 'utf8mb3_general_ci',
	`store_img` VARCHAR(1000) NOT NULL COMMENT '가게 이미지' COLLATE 'utf8mb3_general_ci',
	`min_delivery_price` INT(11) NOT NULL COMMENT '최소 주문 금액',
	`delivery_charge` INT(11) NOT NULL DEFAULT '0' COMMENT '배달비',
	`deliver_address` VARCHAR(1000) NULL DEFAULT NULL COMMENT '배달 가능 지역' COLLATE 'utf8mb3_general_ci',
	`total_rating` FLOAT NOT NULL COMMENT '합산한 별점',
	`review_count` INT(11) NOT NULL DEFAULT '0' COMMENT '리뷰수( 이건 COUNT로 리뷰 조회해도됨 굳이 필요 X)',
	`operation_hours` VARCHAR(300) NULL DEFAULT NULL COMMENT '운영 시간' COLLATE 'utf8mb3_general_ci',
	`total_order` INT(11) NULL DEFAULT '0' COMMENT '주문수',
	`store_status` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '주문 가능 여부 (Y/N)' COLLATE 'utf8mb3_general_ci',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	`category_code` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`store_no`) USING BTREE,
	INDEX `FK_member_TO_stores_1` (`member_no`) USING BTREE,
	INDEX `FK_category_TO_stores` (`category_code`) USING BTREE,
	CONSTRAINT `FK_category_TO_stores` FOREIGN KEY (`category_code`) REFERENCES `category_type` (`category_code`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_stores_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `CONSTRAINT_1` CHECK (`store_status` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`store_status` in ('Y','N'))
)
/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;
*/

-- 가게 카테고리

CREATE TABLE `category_type` (
	`category_code` INT(11) NOT NULL DEFAULT '0',
	`category_name` VARCHAR(45) NOT NULL COMMENT '카테고리 이름' COLLATE 'utf8mb3_general_ci',
	PRIMARY KEY (`category_code`) USING BTREE
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
*/

-- 가게 검색

CREATE TABLE `search_history` (
	`search_no` INT(11) NOT NULL AUTO_INCREMENT,
	`query` TEXT NULL DEFAULT NULL COMMENT '검색 키워드' COLLATE 'utf8mb3_general_ci',
	`search_time` TIMESTAMP NOT NULL DEFAULT curdate() COMMENT '검색 시각',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	PRIMARY KEY (`search_no`) USING BTREE,
	INDEX `FK_member_TO_search_history_1` (`member_no`) USING BTREE,
	CONSTRAINT `FK_member_TO_search_history_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
*/


-- 채팅방

CREATE TABLE `chat_room` (
	`chat_room_no` INT(11) NOT NULL AUTO_INCREMENT,
	`chat_name` VARCHAR(150) NOT NULL COMMENT '채팅방 이름' COLLATE 'utf8mb3_general_ci',
	`address` VARCHAR(1000) NOT NULL COMMENT '배달 장소' COLLATE 'utf8mb3_general_ci',
	`current_people_num` TINYINT(4) NOT NULL DEFAULT '1' COMMENT '현재 인원수',
	`max_people_num` TINYINT(4) NOT NULL DEFAULT '1' COMMENT '최대 인원수',
	`created_date` DATE NOT NULL DEFAULT curdate() COMMENT '채팅방 생성일',
	`last_mes_date` DATE NOT NULL DEFAULT curdate() COMMENT '채팅방 가장 최근 메세지',
	`chat_del_fl` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '일주일 지나면 비활성화 / 상태 (N / Y )' COLLATE 'utf8mb3_general_ci',
	`store_no` INT(11) NOT NULL COMMENT '가게 번호',
	PRIMARY KEY (`chat_room_no`) USING BTREE,
	INDEX `FK_stores_TO_chat_room_1` (`store_no`) USING BTREE,
	CONSTRAINT `FK_stores_TO_chat_room_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `CONSTRAINT_1` CHECK (`chat_del_fl` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`chat_del_fl` in ('Y','N'))
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=4
;

*/


-- 채팅방 그룹

CREATE TABLE `groups` (
	`chat_room_no` INT(11) NOT NULL COMMENT '채팅방 번호',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	PRIMARY KEY (`chat_room_no`, `member_no`) USING BTREE,
	INDEX `FK_member_TO_groups_1` (`member_no`) USING BTREE,
	CONSTRAINT `FK_chat_room_TO_groups_1` FOREIGN KEY (`chat_room_no`) REFERENCES `chat_room` (`chat_room_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_groups_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;

*/

-- 채팅방 메시지

CREATE TABLE `messages` (
	`message_no` INT(11) NOT NULL AUTO_INCREMENT,
	`message_content` VARCHAR(3000) NOT NULL COMMENT '메세지 내용' COLLATE 'utf8mb3_general_ci',
	`is_read` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '읽음  상태 확인 (N/Y)' COLLATE 'utf8mb3_general_ci',
	`created_date` DATE NOT NULL DEFAULT curdate() COMMENT '메세지 생성일',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	`chat_room_no` INT(11) NOT NULL COMMENT '채팅방 번호',
	PRIMARY KEY (`message_no`) USING BTREE,
	INDEX `FK_member_TO_messages_1` (`member_no`) USING BTREE,
	INDEX `FK_chat_room_TO_messages_1` (`chat_room_no`) USING BTREE,
	CONSTRAINT `FK_chat_room_TO_messages_1` FOREIGN KEY (`chat_room_no`) REFERENCES `chat_room` (`chat_room_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_messages_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)
/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=4
;

*/

-- 알림

CREATE TABLE `notification` (
	`noti_no` INT(11) NOT NULL AUTO_INCREMENT,
	`noti_content` VARCHAR(3000) NOT NULL COMMENT '알림 내용' COLLATE 'utf8mb3_general_ci',
	`member_no` INT(11) NOT NULL COMMENT '관리자가 알림 보냄',
	`order_no` INT(11) NOT NULL COMMENT '주문 번호',
	`message_no` INT(11) NOT NULL COMMENT '메세지 번호',
	PRIMARY KEY (`noti_no`) USING BTREE,
	INDEX `FK_member_TO_notification_1` (`member_no`) USING BTREE,
	INDEX `FK_orders_TO_notification_1` (`order_no`) USING BTREE,
	INDEX `FK_messages_TO_notification_1` (`message_no`) USING BTREE,
	CONSTRAINT `FK_member_TO_notification_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_messages_TO_notification_1` FOREIGN KEY (`message_no`) REFERENCES `messages` (`message_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_orders_TO_notification_1` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;
*/

-- 메뉴

CREATE TABLE `menu` (
	`menu_no` INT(11) NOT NULL AUTO_INCREMENT,
	`menu_name` VARCHAR(300) NOT NULL COMMENT '메뉴' COLLATE 'utf8mb3_general_ci',
	`menu_price` INT(11) NOT NULL COMMENT '가격',
	`menu_content` VARCHAR(900) NULL DEFAULT NULL COMMENT '메뉴 설명' COLLATE 'utf8mb3_general_ci',
	`menu_img_url` VARCHAR(1000) NULL DEFAULT NULL COMMENT '메뉴 이미지' COLLATE 'utf8mb3_general_ci',
	`store_no` INT(11) NOT NULL COMMENT '가게 번호',
	PRIMARY KEY (`menu_no`) USING BTREE,
	INDEX `FK_stores_TO_menu_1` (`store_no`) USING BTREE,
	CONSTRAINT `FK_stores_TO_menu_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=39
;
*/


-- 개인 장바구니

CREATE TABLE `personal_cart` (
	`personal_cart_no` INT(11) NOT NULL AUTO_INCREMENT,
	`total_cart_num` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '장바구니 속 수량',
	`total_cart_price` INT(11) NOT NULL DEFAULT '0',
	`store_no` INT(11) NOT NULL COMMENT '가게 번호',
	`menu_no` INT(11) NOT NULL COMMENT '메뉴 번호',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	`cart_no` INT(11) NOT NULL,
	PRIMARY KEY (`personal_cart_no`) USING BTREE,
	INDEX `FK_menu_TO_cart_1` (`store_no`) USING BTREE,
	INDEX `FK_member_TO_cart_1` (`member_no`) USING BTREE,
	INDEX `FK_menu_TO_personal_cart_1` (`menu_no`) USING BTREE,
	INDEX `FK_cart_TO_personal_cart` (`cart_no`) USING BTREE,
	CONSTRAINT `FK_cart_TO_personal_cart` FOREIGN KEY (`cart_no`) REFERENCES `cart` (`cart_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_cart_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_menu_TO_cart_1` FOREIGN KEY (`store_no`) REFERENCES `menu` (`menu_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_menu_TO_personal_cart_1` FOREIGN KEY (`menu_no`) REFERENCES `menu` (`menu_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_store_TO_cart_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=21
;
*/


-- 장바구니

CREATE TABLE `cart` (
	`cart_no` INT(11) NOT NULL AUTO_INCREMENT,
	`chat_room_no` INT(11) NOT NULL,
	PRIMARY KEY (`cart_no`) USING BTREE,
	INDEX `FK_chat_room_TO_cart_1` (`chat_room_no`) USING BTREE,
	CONSTRAINT `FK_chat_room_TO_cart_1` FOREIGN KEY (`chat_room_no`) REFERENCES `chat_room` (`chat_room_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;
*/

-- 주문

CREATE TABLE `orders` (
	`order_no` INT(11) NOT NULL AUTO_INCREMENT,
	`order_status` VARCHAR(10) NOT NULL DEFAULT 'N' COMMENT '주문 상태 확인(배달시작/배달완료)' COLLATE 'utf8mb3_general_ci',
	`total_price` INT(11) NOT NULL DEFAULT '0' COMMENT '총 주문 금액',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	`store_no` INT(11) NOT NULL COMMENT '가게 번호',
	`cart_no` INT(11) NOT NULL,
	PRIMARY KEY (`order_no`) USING BTREE,
	INDEX `FK_member_TO_orders_1` (`member_no`) USING BTREE,
	INDEX `FK_cart_TO_orders` (`cart_no`) USING BTREE,
	INDEX `FK_store_TO_orders_1` (`store_no`) USING BTREE,
	CONSTRAINT `FK_cart_TO_orders` FOREIGN KEY (`cart_no`) REFERENCES `cart` (`cart_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_orders_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_stores_TO_orders_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `CONSTRAINT_1` CHECK (`order_status` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`order_status` in ('Y','N'))
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=42
;
*/





-- 매너 등급

CREATE TABLE `manner_grade` (
	`manner_grade_no` INT(11) NOT NULL AUTO_INCREMENT,
	`grade` VARCHAR(60) NOT NULL COMMENT '매너 등급' COLLATE 'utf8mb3_general_ci',
	`max_score` INT(11) NOT NULL COMMENT '최고 점수',
	PRIMARY KEY (`manner_grade_no`) USING BTREE
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=6
;
*/

-- 매너 평가

CREATE TABLE `manner_level` (
	`manner_no` INT(11) NOT NULL AUTO_INCREMENT,
	`manner_score` TINYINT(4) NULL DEFAULT NULL COMMENT '매너 평가 점수',
	`evaluatee_no` INT(11) NOT NULL COMMENT '회원 번호(FK)',
	`evaluator_no` INT(11) NOT NULL COMMENT '회원 번호(FK)',
	PRIMARY KEY (`manner_no`) USING BTREE,
	INDEX `FK_member_TO_manner_level_1` (`evaluatee_no`) USING BTREE,
	INDEX `FK_member_TO_manner_level_2` (`evaluator_no`) USING BTREE,
	CONSTRAINT `FK_member_TO_manner_level_1` FOREIGN KEY (`evaluatee_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_manner_level_2` FOREIGN KEY (`evaluator_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=5
;
*/

-- 게시판

CREATE TABLE `board` (
	`board_post_no` INT(11) NOT NULL AUTO_INCREMENT,
	`board_title` VARCHAR(300) NOT NULL COMMENT '게시글 제목' COLLATE 'utf8mb3_general_ci',
	`board_content` VARCHAR(6000) NOT NULL COMMENT '게시글 내용' COLLATE 'utf8mb3_general_ci',
	`board_write_date` DATE NOT NULL DEFAULT curdate() COMMENT '게시글 작성일',
	`board_modified_date` DATE NULL DEFAULT curdate() COMMENT '게시글 마지막 수정일',
	`read_count` INT(11) NOT NULL DEFAULT '0' COMMENT '조회수',
	`post_del_fl` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '게시글 삭제 여부 (Y/N)' COLLATE 'utf8mb3_general_ci',
	`post_img` VARCHAR(500) NULL DEFAULT NULL COMMENT '이미지 경로 저장' COLLATE 'utf8mb3_general_ci',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호',
	PRIMARY KEY (`board_post_no`) USING BTREE,
	INDEX `FK_member_TO_board_1` (`member_no`) USING BTREE,
	CONSTRAINT `FK_member_TO_board_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `CONSTRAINT_1` CHECK (`post_del_fl` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`post_del_fl` in ('Y','N'))
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=9
;
*/


-- 이미지

CREATE TABLE `images` (
	`image_no` INT(11) NOT NULL AUTO_INCREMENT,
	`image_path` VARCHAR(1000) NOT NULL COMMENT '이미지 경로' COLLATE 'utf8mb3_general_ci',
	`image_upload_date` DATE NOT NULL DEFAULT curdate() COMMENT '이미지 업로드 날짜',
	`image_order` INT(11) NOT NULL COMMENT '이미지 순서',
	`review_no` INT(11) NOT NULL COMMENT '리뷰 번호',
	`store_no` INT(11) NOT NULL COMMENT '가게 번호',
	`board_post_no` INT(11) NOT NULL COMMENT '게시글 번호',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호(PK)',
	PRIMARY KEY (`image_no`) USING BTREE,
	INDEX `FK_review_TO_images_1` (`review_no`) USING BTREE,
	INDEX `FK_stores_TO_images_1` (`store_no`) USING BTREE,
	INDEX `FK_board_TO_images_1` (`board_post_no`) USING BTREE,
	INDEX `FK_member_TO_images_1` (`member_no`) USING BTREE,
	CONSTRAINT `FK_board_TO_images_1` FOREIGN KEY (`board_post_no`) REFERENCES `board` (`board_post_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_member_TO_images_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_review_TO_images_1` FOREIGN KEY (`review_no`) REFERENCES `review` (`review_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_stores_TO_images_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
*/

-- 문의 

CREATE TABLE `question` (
	`question_no` INT(11) NOT NULL AUTO_INCREMENT,
	`content` VARCHAR(1000) NOT NULL COMMENT '문의 내용' COLLATE 'utf8mb3_general_ci',
	`question_date` DATE NOT NULL DEFAULT curdate() COMMENT '문의한 날짜',
	`question_del_fl` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '신고 처리 여부 (N / Y)' COLLATE 'utf8mb3_general_ci',
	`member_no` INT(11) NOT NULL COMMENT '회원 번호',
	`store_no` INT(11) NOT NULL COMMENT '가게 번호',
	`request_category_code` INT(11) NOT NULL COMMENT '문의 카테고리 코드',
	PRIMARY KEY (`question_no`) USING BTREE,
	INDEX `FK_member_TO_question_1` (`member_no`) USING BTREE,
	INDEX `FK_stores_TO_question_1` (`store_no`) USING BTREE,
	INDEX `FK_question_category_TO_question_1` (`request_category_code`) USING BTREE,
	CONSTRAINT `FK_member_TO_question_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_question_category_TO_question_1` FOREIGN KEY (`request_category_code`) REFERENCES `question_category` (`request_category_code`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_stores_TO_question_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `CONSTRAINT_1` CHECK (`question_del_fl` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`question_del_fl` in ('Y','N'))
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
*/

-- 문의 카테고리

CREATE TABLE `question_category` (
	`request_category_code` INT(11) NOT NULL AUTO_INCREMENT,
	`request_category_type` VARCHAR(60) NOT NULL COMMENT '문의 카테고리 종류, 신고하기도' COLLATE 'utf8mb3_general_ci',
	PRIMARY KEY (`request_category_code`) USING BTREE
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;
*/


-- 리뷰

CREATE TABLE `review` (
	`review_no` INT(11) NOT NULL AUTO_INCREMENT,
	`review_rating` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '밥ㅇㅁ 어플 내의 별점',
	`review_content` VARCHAR(1000) NOT NULL COMMENT '리뷰 내용' COLLATE 'utf8mb3_general_ci',
	`review_img` VARCHAR(900) NULL DEFAULT NULL COMMENT '리뷰 이미지' COLLATE 'utf8mb3_general_ci',
	`review_write_date` DATE NOT NULL DEFAULT curdate() COMMENT '리뷰 작성일',
	`review_del_fl` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '리뷰 삭제 여부(Y / N / W)' COLLATE 'utf8mb3_general_ci',
	`member_no` INT(11) NOT NULL COMMENT '리뷰 작성한 회원 번호',
	`store_no` INT(11) NOT NULL COMMENT '리뷰 남긴 가게 번호',
	`menu_no` INT(11) NOT NULL COMMENT '메뉴 번호',
	PRIMARY KEY (`review_no`) USING BTREE,
	INDEX `FK_member_TO_review_1` (`member_no`) USING BTREE,
	INDEX `FK_stores_TO_review_1` (`store_no`) USING BTREE,
	INDEX `FK_menu_TO_review_1` (`menu_no`) USING BTREE,
	CONSTRAINT `FK_member_TO_review_1` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_menu_TO_review_1` FOREIGN KEY (`menu_no`) REFERENCES `menu` (`menu_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `FK_stores_TO_review_1` FOREIGN KEY (`store_no`) REFERENCES `stores` (`store_no`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `CONSTRAINT_1` CHECK (`review_del_fl` in ('Y','N')),
	CONSTRAINT `CONSTRAINT_2` CHECK (`review_del_fl` in ('Y','N'))
)

/*
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
*/


