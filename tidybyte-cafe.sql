CREATE DATABASE tidybyte_cafe;
use tidybyte_cafe;

SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE suppliers (
  id TINYINT NOT NULL PRIMARY KEY,
  company_name VARCHAR(50) UNIQUE,
  address_line VARCHAR(50),
  city VARCHAR(50),
  email VARCHAR(50),
  phone_number CHAR(15)
);


CREATE TABLE ingredients (
  id TINYINT NOT NULL PRIMARY KEY,
  i_name VARCHAR(50),
  cost NUMERIC(7,2),
  volume BIGINT,
  supplier_id TINYINT,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);


CREATE TABLE staff (
  id TINYINT NOT NULL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  position VARCHAR(50),
  hourly_rate DECIMAL(7,2)
);


CREATE TABLE transactions (
  id BIGINT NOT NULL PRIMARY KEY,
  date_time DATETIME,
  on_shift1 TINYINT,
  on_shift2 TINYINT,
  amount DECIMAL(5,2),
  FOREIGN KEY (on_shift1) REFERENCES staff(id),
  FOREIGN KEY (on_shift2) REFERENCES staff(id),
  CONSTRAINT chk_different_staff CHECK (on_shift1 <> on_shift2)
);



CREATE TABLE item (
  id TINYINT PRIMARY KEY,
  recipe_id TINYINT,
  item_name VARCHAR(50),
  price DECIMAL(3,2),
  category VARCHAR(50)
);

CREATE INDEX idx_recipe_id ON item(recipe_id);



CREATE TABLE recipe (
  id TINYINT NOT NULL PRIMARY KEY,
  recipe_id TINYINT,
  ingredient_id TINYINT,
  amount DECIMAL(7,2),
  FOREIGN KEY (recipe_id) REFERENCES item(recipe_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);





CREATE TABLE inventory (
  id TINYINT PRIMARY KEY,
  ingredient_id TINYINT,
  quantity INT UNSIGNED,
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);


CREATE TABLE transaction_items (
  id BIGINT PRIMARY KEY,
  transaction_id BIGINT,
  item_id TINYINT,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id),
  FOREIGN KEY (item_id) REFERENCES item(id)
);






INSERT INTO staff (id, first_name, last_name, position, hourly_rate)
VALUES
  (1, 'Gunther', 'Smith', 'Manager', 41.75),
  (2, 'Ross', 'Geller', 'Part-Time', 25.75),
  (3, 'Rachel', 'Green', 'Part-Time', 25.75),
  (4, 'Phoebe', 'Buffay', 'Part-Time', 25.75),
  (5, 'Chandler', 'Bing', 'Casual', 27.55),
  (6, 'Monica', 'Geller', 'Casual', 27.55),
  (7, 'Joe', 'Tribbiani', 'Casual', 27.55);



INSERT INTO suppliers (id, company_name, address_line, city, email, phone_number)
VALUES
(1, 'Coffee Suppliers Inc', '123 Coffee st', 'Sydney', 'contact@coffeesuppliers.com', '+61-214-333-222'),
(2, 'Milk Suppliers Ltd', '456 Milk Cct', 'Sydney', 'contact@milksuppliers.com', '+61-432-765-098'),
(3, 'Food Supplier Pty', '789 Food Ave', 'Sydney', 'contact@foodsupplier.com', '+61-999-888-777');




INSERT INTO ingredients (id, i_name, cost, volume, supplier_id)
VALUES 
  -- Coffee Beans
  (1, 'Coffee Beans', 25.00, 1000, 1), -- 1kg, comes in 6 x 1kg boxes for $150
  -- Caramel Syrup
  (2, 'Caramel Syrup', 9.17, 500, 1), -- 500ml, comes in 6 x 500ml bottles for $55
  -- Almond Syrup
  (3, 'Almond Syrup', 9.17, 500, 1), -- 500ml, comes in 6 x 500ml bottles for $55
  -- Large Takeaway Cups (340mL)
  (4, 'Large Takeaway Cups', 78, 500, 1), -- 500 cups for $78
  -- Small Takeaway Cups (245mL)
  (5, 'Small Takeaway Cups', 68, 500, 1), -- 500 cups for $68
  -- Espresso Cups
  (6, 'Espresso Cups', 30, 250, 1), -- 250 cups for $30
  -- Brown Sugar Sachets
  (7, 'Brown Sugar Sachets', 62, 1000, 1), -- 1000 sachets for $62
  -- Full Cream Milk
  (8, 'Full Cream Milk', 3.25, 2000, 2), -- 2L, comes in 9 x 2L crates for $3.25 each
  -- Skim Milk
  (9, 'Skim Milk', 3.25, 2000, 2), -- 2L, comes in 9 x 2L crates for $3.25 each
  -- Almond Milk
  (10, 'Almond Milk', 2.55, 1000, 2), -- 1L, comes in 6 x 1L packs for $2.55 each
  -- Oat Milk
  (11, 'Oat Milk', 2.55, 1000, 2), -- 1L, comes in 6 x 1L packs for $2.55 each
  -- Kale
  (12, 'Kale', 9.00, 1000, 3), -- 1kg for $9
  -- Teriyaki Marinated Roasted Chicken Breast (Shredded)
  (13, 'Teriyaki Chicken Breast', 28.00, 1000, 3), -- 1kg for $28
  -- Cherry Tomatoes
  (14, 'Cherry Tomatoes', 7.00, 1000, 3), -- 1kg for $7
  -- Cheddar Cheese Slices
  (15, 'Cheddar Cheese Slices', 6.50, 24, 3), -- 24 slices for $6.50
  -- Rustic White Sourdough Bread
  (16, 'Sourdough Bread', 7.55, 14, 3), -- 14 slices for $7.55
  -- Nutritional Yeast
  (17, 'Nutritional Yeast', 5.00, 100, 3), -- 100g, comes in 6 x 100g packs for $30
  -- Date/Choc Chip/Almond Italian Biscuits (Assortment)
  (18, 'Italian Biscuits', 27.35, 30, 3); -- 30 pack (10/10/10 split) for $27.35
  
  
  
  
INSERT INTO recipe (id, recipe_id, ingredient_id, amount) VALUES 
-- Toasted Chicken Teriyaki Sandwich
  (1, 1, 13, 100), -- 100g Teriyaki Chicken Breast
  (2, 1, 12, 45), -- 45g Kale
  (3, 1, 15, 1), -- 1 slice Cheddar Cheese
  (4, 1, 16, 2), -- 2 slices of bread
-- Cheese and Tomato Sandwich
  (5, 2, 15, 2), -- 2 slices Cheddar Cheese
  (6, 2, 17, 15), -- 15g Nutritional Yeast
  (7, 2, 14, 85), -- 85g Cherry Tomatoes
  (8, 2, 16, 2), -- 2 slices of bread
-- Large Coffee
  (9, 3, 1, 18), -- 18g Coffee Beans (2 shots)
  (10, 3, 8, 280), -- Full Cream Milk
  (11, 3, 4, 1), -- Large cup
-- Small Coffee
  (12, 4, 1, 9), -- 9g Coffee Beans (1 shot)
  (13, 4, 8, 215), -- Full Cream Milk
  (14, 4, 5, 1), -- Small cup
-- Large Skim Milk Coffee
  (15, 5, 1, 18), -- 18g Coffee Beans (2 shots)
  (16, 5, 9, 280), -- Skim Milk
  (17, 5, 4, 1), -- Large cup
-- Small Skim Milk Coffee
  (18, 6, 1, 9), -- 9g Coffee Beans (1 shot)
  (19, 6, 9, 215), -- Skim Milk
  (20, 6, 5, 1), -- Small cup
-- Large Oat Milk Coffee
  (21, 7, 1, 18), -- 18g Coffee Beans (2 shots)
  (22, 7, 11, 280), -- Oat Milk
  (23, 7, 4, 1), -- Large cup
-- Small Oat Milk Coffee
  (24, 8, 1, 9), -- 9g Coffee Beans (1 shot)
  (25, 8, 11, 215), -- Oat Milk
  (26, 8, 5, 1), -- Small cup
-- Large Almond Milk Coffee
  (27, 9, 1, 18), -- 18g Coffee Beans (2 shots)
  (28, 9, 10, 280), -- Almond Milk
  (29, 9, 4, 1), -- Large cup
-- Small Almond Milk Coffee
  (30, 10, 1, 9), -- 9g Coffee Beans (1 shot)
  (31, 10, 10, 215), -- Almond Milk
  (32, 10, 5, 1), -- Small cup
-- Small Long Black
  (33, 11, 1, 9), -- 9g Coffee Beans (1 shot)
  (34, 11, 5, 1), -- Small cup
-- Large Long Black
  (35, 12, 1, 18), -- 18g Coffee Beans (2 shots)
  (36, 12, 4, 1), -- Large cup
-- Small Espresso
  (37, 13, 1, 9), -- 9g Coffee Beans (1 shot)
  (38, 13, 6, 1), -- espresso cup
-- Double Espresso
  (39, 14, 1, 18), -- 18g Coffee Beans (2 shots)
  (40, 14, 6, 1), -- espresso cup
-- Biscuits 
  (41, 15, 18, 1), -- 1 biscuit from the assortment
-- Caramel Syrup Add-on
  (42, 16, 2, 1), -- 1 portion of Caramel Syrup
-- Almond Syrup Add-on
  (43, 17, 3, 1), -- 1 portion of Almond Syrup
-- Brown Sugar Add-on
  (44, 18, 7, 1), -- 1 sachet of Brown Sugar
-- Extra Shot of Coffee Add-on
  (45, 19, 1, 9); -- 9g Coffee Beans (1 extra shot)





INSERT INTO item (id, recipe_id, item_name, price, category) 
VALUES 
  (1, 3, 'Large Cappuccino', 5.25, 'Beverage'),   -- Large Cappuccino -> Large coffee recipe
  (2, 4, 'Small Cappuccino', 4.40, 'Beverage'),   -- Small Cappuccino -> Small coffee recipe
  (3, 3, 'Large Flat White', 5.25, 'Beverage'),   -- Large Flat White -> Large coffee recipe
  (4, 4, 'Small Flat White', 4.40, 'Beverage'),   -- Small Flat White -> Small coffee recipe
  (5, 3, 'Large Latte', 5.25, 'Beverage'),   -- Large Latte -> Large coffee recipe
  (6, 4, 'Small Latte', 4.40, 'Beverage'),   -- Small Latte -> Small coffee recipe
  (7, 5, 'Large Skim Milk Cappuccino', 5.25, 'Beverage'),   -- Large Skim Milk Cappuccino -> Large Skim Milk coffee recipe
  (8, 6, 'Small Skim Milk Cappuccino', 4.40, 'Beverage'),   -- Small Skim Milk Cappuccino -> Small Skim Milk coffee recipe
  (9, 5, 'Large Skim Milk Flat White', 5.25, 'Beverage'),   -- Large Skim Milk Flat White -> Large Skim Milk coffee recipe
  (10, 6, 'Small Skim Milk Flat White', 4.40, 'Beverage'), -- Small Skim Milk Flat White -> Small Skim Milk coffee recipe
  (11, 5, 'Large Skim Milk Latte', 5.25, 'Beverage'), -- Large Skim Milk Latte -> Large Skim Milk coffee recipe
  (12, 6, 'Small Skim Milk Latte', 4.40, 'Beverage'), -- Small Skim Milk Latte -> Small Skim Milk coffee recipe
  (13, 7, 'Large Oat Milk Cappuccino', 5.25, 'Beverage'), -- Large Oat Milk Cappuccino -> Large Oat Milk coffee recipe
  (14, 8, 'Small Oat Milk Cappuccino', 4.40, 'Beverage'), -- Small Oat Milk Cappuccino -> Small Oat Milk coffee recipe
  (15, 7, 'Large Oat Milk Flat White', 5.25, 'Beverage'), -- Large Oat Milk Flat White -> Large Oat Milk coffee recipe
  (16, 8, 'Small Oat Milk Flat White', 4.40, 'Beverage'), -- Small Oat Milk Flat White -> Small Oat Milk coffee recipe
  (17, 7, 'Large Oat Milk Latte', 5.25, 'Beverage'), -- Large Oat Milk Latte -> Large Oat Milk coffee recipe
  (18, 8, 'Small Oat Milk Latte', 4.40, 'Beverage'), -- Small Oat Milk Latte -> Small Oat Milk coffee recipe
  (19, 9, 'Large Almond Milk Cappuccino', 5.25, 'Beverage'),-- Large Almond Milk Cappuccino -> Large Almond Milk coffee recipe
  (20, 10, 'Small Almond Milk Cappuccino', 4.40, 'Beverage'),-- Small Almond Milk Cappuccino -> Small Almond Milk coffee recipe
  (21, 9, 'Large Almond Milk Flat White', 5.25, 'Beverage'),-- Large Almond Milk Flat White -> Large Almond Milk coffee recipe
  (22, 10, 'Small Almond Milk Flat White', 4.40, 'Beverage'),-- Small Almond Milk Flat White -> Small Almond Milk coffee recipe
  (23, 9, 'Large Almond Milk Latte', 5.25, 'Beverage'),-- Large Almond Milk Latte -> Large Almond Milk coffee recipe
  (24, 10, 'Small Almond Milk Latte', 4.40, 'Beverage'),-- Small Almond Milk Latte -> Small Almond Milk coffee recipe
  (25, 11, 'Small Long Black', 3.90, 'Beverage'),
  (26, 12, 'Large Long Black', 4.65, 'Beverage'),
  (27, 13, 'Small Espresso', 2.90, 'Beverage'),
  (28, 14, 'Double Espresso', 3.90, 'Beverage'),
  (29, 19, 'Extra Shot of Coffee', 0.75, 'Beverage Add-on'),
  (30, 16, 'Caramel Syrup Add-on', 0.75, 'Beverage Add-on'),
  (31, 17, 'Almond Syrup Add-on', 0.75, 'Beverage Add-on'),
  (32, 18, 'Brown Sugar Add-on', 0.00, 'Beverage Add-on'),
  (33, 15, 'Date Biscuit', 3.20, 'Food'), -- Date Biscuit -> Biscuits Recipe
  (34, 15, 'Choc-Chip Biscuit', 3.20, 'Food'), -- Choc-Chip Biscuit -> Biscuits Recipe
  (35, 15, 'Almond Biscuit', 3.20, 'Food'), -- Almond Biscuit -> Biscuits Recipe
  (36, 1, 'Toasted Chicken Teriyaki Sandwich', 9.50, 'Food'), 
  (37, 2, 'Cheese and Tomato Sandwich', 9.00, 'Food'); 

  
# after loading in transactions
UPDATE transactions
SET date_time = DATE_SUB(date_time, INTERVAL 1 SECOND)
WHERE TIME(date_time) = '15:00:00';


SET FOREIGN_KEY_CHECKS = 1;