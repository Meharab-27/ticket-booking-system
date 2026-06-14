--Users table
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,

  role VARCHAR(30) NOT NULL 
    CHECK(role IN ('Ticket Manager', 'Football Fan')),
  phone_number VARCHAR(20) UNIQUE 
  
  
  
);

--Matches table

CREATE TABLE matches (
  match_id SERIAL PRIMARY KEY,
  fixture VARCHAR(100) NOT NULL,
  tournament_category VARCHAR(100) NOT NULL,
  base_ticket_price NUMERIC(10,2) NOT NULL
       CHECK (base_ticket_price > 0),

  match_status VARCHAR(30) NOT NULL
        CHECK(

     match_status IN (
     'Available',
     'Selling Fast',
     'Sold Out',
     'Postponed'
     )
        )
  
  );

--Bookings table
CREATE TABLE bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL
      REFERENCES users(user_id)
    ON DELETE CASCADE,
  match_id INT NOT NULL
      REFERENCES matches(match_id)
     ON DELETE CASCADE,
  seat_number VARCHAR(20) ,
  payment_status VARCHAR(20)
        CHECK(
        payment_status IN(
         'Pending',
          'Confirmed',
          'Cancelled',
          'Refunded'
        )
        ),
  total_cost NUMERIC(10,2) 
        CHECK (total_cost >= 0)
  
  );

  --Insert values to users

INSERT INTO users (user_id, full_name, email, role, phone_number)
VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- Insert values to matches
INSERT INTO matches (match_id, fixture, tournament_category
  , base_ticket_price, match_status)
VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80, 'Available');


--Insert values to bookings

INSERT INTO bookings (booking_id, user_id, match_id,
  seat_number, payment_status, total_cost)
VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150),
(502, 1, 102, 'B-04', 'Confirmed', 120),
(503, 2, 101, 'A-13', 'Confirmed', 150),
(504, 2, 101, NULL, NULL, 150),
(505, 3, 102, 'C-20', 'Pending', 120);


--Query1
select match_id,fixture,base_ticket_price from matches 
where tournament_category = 'Champions League' 
  and match_status = 'Available'

  --Query2
SELECT user_id,full_name,email
FROM users 
WHERE full_name LIKE 'Tanvir%'
OR full_name ILIKE '%Haque%'

--Query3
SELECT
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;




--Query4
SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN matches m ON b.match_id = m.match_id;


--Query5
SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id;

--Query6

SELECT booking_id, match_id, total_cost
FROM bookings
WHERE total_cost > (
    SELECT AVG(total_cost) FROM bookings
);

--Query7

SELECT match_id, fixture, base_ticket_price
FROM matches
ORDER BY base_ticket_price DESC
OFFSET 1
LIMIT 2;
