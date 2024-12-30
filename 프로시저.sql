DELIMITER $$

CREATE PROCEDURE InsertChatRoom(
    IN chat_name VARCHAR(255), 
    IN address VARCHAR(255), 
    IN max_people_num INT, 
    IN store_no INT
)
BEGIN
    INSERT INTO `chat_room` (chat_name, address, max_people_num, store_no)
    VALUES (chat_name, address, max_people_num, store_no);
END $$

DELIMITER ;


CALL InsertChatRoom(
    '짜장면 먹을 사람 여기 모여라~!!', 
    '서울특별시 동작구 보라매로87 신이빌딩 5층', 
    3, 
    2
);


DELIMITER $$
CREATE OR REPLACE PROCEDURE chatRoomEnter(
	IN enterChatRoomNum INT,
	IN enterMemberNum INT
)
BEGIN
	DECLARE chatRoomCurrentNum INT;
	DECLARE chatRoomMaxNum INT;
	
	SET chatRoomCurrentNum = 
		(SELECT current_people_num
		FROM chat_room
		WHERE chat_room_no = enterChatRoomNum
		)
		;
	SET chatRoomMaxNum = 
		(SELECT max_people_num
		FROM chat_room
		WHERE chat_room_no = enterChatRoomNum
		)
		;
	IF 
		chatRoomCurrentNum < chatRoomMaxNum
	THEN 
		INSERT INTO `groups`(chat_room_no, member_no)
		VALUES (enterChatRoomNum, enterMemberNum)
		;
		UPDATE chat_room
      SET current_people_num = current_people_num + 1
      WHERE chat_room_no = enterChatRoomNum
		;
	END IF;
END$$
DELIMITER ;

CALL chatRoomEnter(3, 1);

CALL chatRoomEnter(3, 2);

CALL chatRoomEnter(3, 3);

INSERT INTO cart (chat_room_no)
VALUES (3);

DELIMITER $$
CREATE PROCEDURE CreatePersonalCart(
    IN p_member_no INT,
    IN p_menu_name VARCHAR(255),
    IN p_quantity INT,
    IN p_cart_no INT
)
BEGIN
    INSERT INTO personal_cart (total_cart_num,
                               store_no,
                               menu_no,
                               member_no,
                               cart_no,
                               total_cart_price)
    SELECT
        p_quantity
        m.store_no, 
        m.menu_no, 
        p_member_no
        p_cart_no
        p_quantity * m.menu_price
    FROM menu m
    WHERE m.menu_name = p_menu_name;
END $$
DELIMITER ;

CALL createPersonalCart(1, '짜장면', 1, 2);

CALL createPersonalCart(2, '짬뽕', 2, 2);

CALL createPersonalCart(3, '볶음밥', 1, 2);
CALL createPersonalCart(3, '군만두', 1, 2);

INSERT INTO orders (order_status,
                    total_price,
                    member_no,
                    store_no,
                    cart_no)
SELECT 'Y',
       SUM(pc.total_cart_price) + (s.delivery_charge / 		 
		 	(SELECT COUNT(DISTINCT a.member_no )
   	 	FROM personal_cart a
   	 	WHERE a.cart_no = pc.cart_no)),
       pc.member_no,
       pc.store_no,
       pc.cart_no
FROM personal_cart pc
INNER JOIN stores s ON s.store_no = pc.store_no
GROUP BY member_no;

DELIMITER $$
CREATE OR REPLACE PROCEDURE insertMannerLevel(
    IN p_manner_score TINYINT,
    IN p_evaluatee_no INT,
    IN p_evaluator_no INT
)
BEGIN
    INSERT INTO manner_level (manner_score, evaluatee_no, evaluator_no)
    VALUES (p_manner_score, p_evaluatee_no, p_evaluator_no)
	 ;
END$$
DELIMITER ;

CALL insertMannerLevel(2, 3, 1);



DELIMITER $$

CREATE OR REPLACE TRIGGER updateMemberAfterMannerInsert
AFTER INSERT ON manner_level
FOR EACH ROW
BEGIN
    UPDATE `member`
    SET manner_total_score = manner_total_score + NEW.manner_score
    WHERE member_no = NEW.evaluatee_no;
END$$

DELIMITER ;

INSERT INTO manner_level 
(manner_score, evaluatee_no, evaluator_no )
VALUES 
(-2,1,2);
