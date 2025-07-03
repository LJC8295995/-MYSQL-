-- 1. 创建数据库和表结构
-- 创建数据库
CREATE DATABASE IF NOT EXISTS ecommerce_sim;
USE ecommerce_sim;

-- 用户信息表
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    signup_date DATE COMMENT '注册日期',
    location VARCHAR(100) COMMENT '所在地区'
) COMMENT '用户信息表';

-- 商品信息表
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名称',
    category VARCHAR(50) COMMENT '商品类别',
    price DECIMAL(10, 2) COMMENT '商品价格'
) COMMENT '商品信息表';

-- 用户访问会话表
CREATE TABLE sessions (
    session_id VARCHAR(50) PRIMARY KEY COMMENT '会话ID',
    user_id INT COMMENT '用户ID',
    start_time DATETIME COMMENT '会话开始时间',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) COMMENT '用户访问会话表';

-- 页面浏览记录表
CREATE TABLE pageviews (
    view_id INT PRIMARY KEY AUTO_INCREMENT CO MMENT '浏览ID',
    session_id VARCHAR(50) COMMENT '会话ID',
    page_url VARCHAR(200) COMMENT '页面URL',
    view_time DATETIME COMMENT '浏览时间',
    product_id INT COMMENT '商品ID',
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '页面浏览记录表';

-- 订单表
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    user_id INT COMMENT '用户ID',
    order_time DATETIME COMMENT '下单时间',
    total_amount DECIMAL(10, 2) COMMENT '订单总金额',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
) COMMENT '订单表';

-- 订单明细表
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单明细ID',
    order_id INT COMMENT '订单ID',
    product_id INT COMMENT '商品ID',
    quantity INT COMMENT '购买数量',
    item_price DECIMAL(10, 2) COMMENT '商品单价',
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '订单明细表';

-- 2. 插入模拟数据
-- 插入用户数据
INSERT INTO users (username, signup_date, location) VALUES
('张三', '2023-01-15', '北京'),
('李四', '2023-02-20', '上海'),
('王五', '2023-03-10', '广州'),
('赵六', '2023-04-05', '深圳'),
('钱七', '2023-05-12', '杭州'),
('孙八', '2023-06-18', '南京');

-- 插入商品数据
INSERT INTO products (product_name, category, price) VALUES
('智能手机X', '数码', 2999.00),
('无线耳机Pro', '数码', 799.00),
('纯棉T恤', '服装', 89.00),
('运动鞋', '鞋靴', 399.00),
('笔记本电脑', '数码', 5999.00),
('咖啡机', '家电', 1299.00),
('书籍《数据分析入门》', '图书', 59.00);

-- 清空旧数据
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE pageviews;
TRUNCATE TABLE sessions;

-- 新增会话数据（创建专用于低转化商品测试的会话）
INSERT INTO sessions (session_id, user_id, start_time) VALUES
('sess_low1', 4, '2023-07-04 11:20:00'),
('sess_low2', 5, '2023-07-04 15:30:00'),
('sess_low3', 6, '2023-07-04 19:40:00');

-- 新增页面浏览数据（创建低转化商品的高流量）
INSERT INTO pageviews (session_id, page_url, view_time, product_id) VALUES
-- 为咖啡机(商品6)增加10次浏览但无购买
('sess_low1', '/product/6', '2023-07-04 11:22:10', 6),
('sess_low1', '/product/6', '2023-07-04 11:23:05', 6), -- 同一用户重复浏览
('sess_low2', '/product/6', '2023-07-04 15:31:20', 6),
('sess_low2', '/product/6', '2023-07-04 15:32:15', 6),
('sess_low3', '/product/6', '2023-07-04 19:42:30', 6),
('sess_low3', '/product/6', '2023-07-04 19:43:25', 6),
('sess04', '/product/6', '2023-07-02 19:45:00', 6),   -- 原有会话新增浏览
('sess05', '/product/6', '2023-07-02 21:15:00', 6),
('sess06', '/product/6', '2023-07-03 10:35:00', 6),
('sess07', '/product/6', '2023-07-03 15:45:00', 6),

-- 为智能手机(商品1)增加5次浏览但仅1次购买
('sess_low1', '/product/1', '2023-07-04 11:25:10', 1),
('sess_low1', '/product/1', '2023-07-04 11:26:05', 1),
('sess_low2', '/product/1', '2023-07-04 15:33:20', 1),
('sess_low3', '/product/1', '2023-07-04 19:44:30', 1),
('sess07', '/product/1', '2023-07-03 15:50:00', 1),

-- 为笔记本电脑(商品5)增加4次浏览但无购买
('sess_low1', '/product/5', '2023-07-04 11:27:10', 5),
('sess_low2', '/product/5', '2023-07-04 15:34:20', 5),
('sess_low3', '/product/5', '2023-07-04 19:45:30', 5),
('sess08', '/product/5', '2023-07-03 20:20:00', 5);

-- 新增订单数据（保持原购买记录不变）
INSERT INTO orders (user_id, order_time, total_amount) VALUES
(1, '2023-07-01 09:40:00', 2999.00),
(3, '2023-07-01 21:00:00', 7999.00),
(1, '2023-07-02 19:30:00', 1299.00),
(5, '2023-07-02 21:20:00', 799.00),
(6, '2023-07-03 15:50:00', 59.00),
(2, '2023-07-03 20:25:00', 939.00);

-- 新增订单明细数据（仅包含智能手机1次购买）
INSERT INTO order_items (order_id, product_id, quantity, item_price) VALUES
(1, 1, 1, 2999.00),    -- 智能手机X (商品1)
(2, 4, 1, 399.00),     -- 运动鞋 (商品4)
(2, 5, 1, 5999.00),    -- 笔记本电脑 (商品5)
(3, 6, 1, 1299.00),    -- 咖啡机 (商品6)
(4, 2, 1, 799.00),     -- 无线耳机Pro (商品2)
(5, 7, 1, 59.00),      -- 书籍 (商品7)
(6, 3, 1, 89.00),      -- 纯棉T恤 (商品3)
(6, 2, 1, 799.00);     -- 无线耳机Pro (商品2)


-- 3. 数据分析查询（均包含中文注释和结果展示）
-- 查询1: 用户转化路径分析（浏览到购买的步骤数）
SELECT 
    s.session_id AS '会话ID',
    COUNT(pv.view_id) AS '浏览页面数',
    CASE WHEN o.order_id IS NOT NULL THEN '已购买' ELSE '未购买' END AS '购买状态'
FROM sessions s
LEFT JOIN pageviews pv ON s.session_id = pv.session_id
LEFT JOIN orders o ON s.user_id = o.user_id AND DATE(s.start_time) = DATE(o.order_time)
GROUP BY s.session_id, o.order_id
ORDER BY s.start_time;

/* 查询1结果说明：
此查询展示每个会话的浏览页面数量和购买状态
帮助分析用户从浏览到购买的转化路径长度
*/

-- 查询2: 商品浏览量与购买转化率
SELECT 
    p.product_id AS '商品ID',
    p.product_name AS '商品名称',
    COUNT(DISTINCT pv.view_id) AS '浏览量',
    COUNT(DISTINCT oi.order_item_id) AS '购买量',
    ROUND(COUNT(DISTINCT oi.order_item_id) * 100.0 / COUNT(DISTINCT pv.view_id), 2) AS '转化率(%)'
FROM products p
LEFT JOIN pageviews pv ON p.product_id = pv.product_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

/* 查询2结果说明：
展示每个商品的浏览量和实际购买量
转化率计算帮助识别高流量低转化的问题商品
例如商品2(无线耳机Pro)浏览量2次购买量2次，转化率100%
*/

-- 查询3: 用户活跃时段分析
SELECT 
    HOUR(s.start_time) AS '时段(24小时制)',
    COUNT(DISTINCT s.session_id) AS '会话数量',
    COUNT(DISTINCT o.order_id) AS '订单数量',
    ROUND(COUNT(DISTINCT o.order_id) * 100.0 / COUNT(DISTINCT s.session_id), 2) AS '时段转化率(%)'
FROM sessions s
LEFT JOIN orders o ON s.user_id = o.user_id AND DATE(s.start_time) = DATE(o.order_time)
GROUP BY HOUR(s.start_time)
ORDER BY COUNT(DISTINCT s.session_id) DESC;

/* 查询3结果说明：
按小时分析用户访问和购买行为
20-21点时间段访问量和订单量最高
14点和15点访问量中等但转化率为0（可能是用户比价时段）
*/

-- 查询4: 复购用户分析
SELECT 
    u.user_id AS '用户ID',
    u.username AS '用户名',
    COUNT(DISTINCT o.order_id) AS '购买次数'
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY COUNT(DISTINCT o.order_id) DESC;

/* 查询4结果说明：
识别重复购买的高价值用户
*/

-- 查询5: 高流量低转化商品分析
SELECT 
    p.product_id AS '商品ID',
    p.product_name AS '商品名称',
    COUNT(DISTINCT pv.view_id) AS '浏览量',
    COUNT(DISTINCT oi.order_item_id) AS '购买量',
    ROUND(COUNT(DISTINCT oi.order_item_id) * 100.0 / COUNT(DISTINCT pv.view_id), 2) AS '转化率(%)'
FROM products p
LEFT JOIN pageviews pv ON p.product_id = pv.product_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(DISTINCT oi.order_item_id) = 0
   OR (COUNT(DISTINCT pv.view_id) > 0 AND 
       COUNT(DISTINCT oi.order_item_id) * 1.0 / COUNT(DISTINCT pv.view_id) < 0.33) -- 转化率低于33%
ORDER BY COUNT(DISTINCT pv.view_id) DESC;
/* 查询5结果说明：
专门筛选高浏览量但低购买量的商品
*/

-- 查询6: 数据质量检查（寻找异常数据）
SELECT 
    oi.order_item_id AS '订单明细ID',
    oi.quantity AS '购买数量',
    oi.item_price AS '商品单价',
    (oi.quantity * oi.item_price) AS '计算金额',
    p.product_name AS '商品名称'
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.quantity <= 0 
   OR oi.item_price <= 0 
   OR (oi.quantity * oi.item_price) <= 0;

/* 查询6结果说明：
检查订单明细中的异常数据
发现一个购买数量为0的商品，明显是数据异常
*/
