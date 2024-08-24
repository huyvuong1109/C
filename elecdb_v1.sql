-- create database
CREATE DATABASE elecdb_v1;
\c elecdb_v1

-- TABLE DEFINITION
-- Customer (customer_id, customer_name, address, phone, service_id)
-- Meter (meter_id, customer_id, invoice_period, old_index, new_index, multiplier, electric_consumption, customer_name)
-- Service (service_id, service_name)
-- ServicePricing (pricing_id, service_id, tier, unit_price)
-- Invoice (invoice_id, meter_id, service_id, service_name, electric_consumption, VAT, total_amount, invoice_date, payment_due_date, meter_name)
-- InvoiceDetail (invoice_detail_id, invoice_id, tier, consumption_output)

/************************************************************************************
************************************************************************************/

-- Service (service_id, service_name)
CREATE TABLE Service (
    service_id INT NOT NULL,
    service_name VARCHAR(50) NOT NULL,
    CONSTRAINT Service_pk PRIMARY KEY (service_id)
);

-- Customer (customer_id, customer_name, address, phone, service_id)
CREATE TABLE Customer (
    customer_id CHAR(10) NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    service_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT Customer_pk PRIMARY KEY (customer_id),
	CONSTRAINT Customer_fk_Service FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- Meter (meter_id, customer_id, service_id, invoice_period, old_index, new_index, multiplier, electric_consumption, customer_name)
CREATE TABLE Meter (
    meter_id CHAR(10) NOT NULL,
    customer_id CHAR(10) NOT NULL,
	service_id INT NOT NULL,
    invoice_period VARCHAR(30),
    old_index INT,
    new_index INT,
    multiplier FLOAT,
    electric_consumption NUMERIC,
    customer_name VARCHAR(50) NOT NULL,
    CONSTRAINT Meter_pk PRIMARY KEY (meter_id),
	CONSTRAINT Meter_fk_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
	CONSTRAINT Meter_fk_Service FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- ServicePricing (pricing_id, service_id, price_tier_1, price_tier_2, price_tier_3, price_tier_4, price_tier_5)
CREATE TABLE ServicePricing (
    pricing_id CHAR(10) NOT NULL,
    service_id INT NOT NULL,
    price_tier_1 NUMERIC,
    price_tier_2 NUMERIC,
    price_tier_3 NUMERIC,
    price_tier_4 NUMERIC,
    price_tier_5 NUMERIC,
    price_tier_6 NUMERIC,
    CONSTRAINT Pricing_pk PRIMARY KEY (pricing_id),
	CONSTRAINT ServicePricing_fk_Service FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- Invoice (invoice_id, customer_id, meter_id, service_id, service_name, electric_consumption, vat, invoice_date, payment_due_date)
CREATE TABLE Invoice (
    invoice_id CHAR(10) NOT NULL,
	customer_id CHAR(10) NOT NULL,
    meter_id CHAR(10) NOT NULL,
    service_id INT NOT NULL,
    service_name VARCHAR(50),
    electric_consumption FLOAT,
    vat NUMERIC,
    invoice_date DATE,
    payment_due_date DATE,
    CONSTRAINT Invoice_pk PRIMARY KEY (invoice_id),
	CONSTRAINT Invoice_fk_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
	CONSTRAINT Invoice_fk_Meter FOREIGN KEY (meter_id) REFERENCES Meter(meter_id),
	CONSTRAINT Invoice_fk_Service FOREIGN KEY (service_id) REFERENCES Service(service_id)
);


-- InvoiceDetail (invoice_detail_id, customer_id, payment_method, invoice_id)
CREATE TABLE InvoiceDetail (
    invoice_detail_id CHAR(10) NOT NULL,
    customer_id CHAR(10) NOT NULL,
    payment_method VARCHAR(50),
    invoice_id CHAR(10) NOT NULL,
    CONSTRAINT InvoiceDetail_pk PRIMARY KEY (invoice_detail_id),
	CONSTRAINT InvoiceDetail_fk_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
	CONSTRAINT InvoiceDetail_fk_Invoice FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);



/************************************************************************************
************************************************************************************/


-- Data
\encoding 'UTF8'


-- Service (service_id, service_name)
INSERT INTO Service (service_id, service_name) VALUES (1, 'Điện sinh hoạt');
INSERT INTO Service (service_id, service_name) VALUES (2, 'Điện kinh doanh');


-- Customer (customer_id, customer_name, address, phone, service_id)
INSERT INTO Customer (customer_id, customer_name, address, phone, service_id) VALUES 
('C001', 'Nguyễn Văn An', 'Số 12, đường Trần Hưng Đạo, Hà Nội', '0987654321', 1),
('C002', 'Nguyễn Xuân Bách', 'Số 25, đường Nguyễn Trãi, Thành phố Hồ Chí Minh', '0123456789', 2),
('C003', 'Lê Văn Chính', 'Số 38, đường Lý Thái Tổ, Đà Nẵng', '0908765432', 1),
('C004', 'Phạm Thị Kỳ Duyên', 'Số 41, đường Hai Bà Trưng, Hải Phòng', '0123456789', 2),
('C005', 'Võ Văn Toàn', 'Số 52, đường Lê Duẩn, Cần Thơ', '0987654321', 1),
('C006', 'Phan Văn Hùng', 'Số 63, đường Nguyễn Huệ, Nha Trang', '0912345678', 2),
('C007', 'Đặng Thị Minh', 'Số 74, đường Lê Lợi, Huế', '0934567890', 1),
('C008', 'Ngô Văn Khánh', 'Số 85, đường Trần Quang Khải, Buôn Ma Thuột', '0981234567', 2),
('C009', 'Lý Thị Hương', 'Số 96, đường Điện Biên Phủ, Vũng Tàu', '0976543210', 1),
('C010', 'Dương Văn Kiên', 'Số 107, đường Phan Chu Trinh, Quy Nhơn', '0965432109', 2),
('C011', 'Hoàng Thị Lan', 'Số 118, đường Bạch Đằng, Đà Lạt', '0954321098', 1),
('C012', 'Nguyễn Thị Mai', 'Số 129, đường Trường Chinh, Vinh', '0943210987', 2),
('C013', 'Trần Văn Bình', 'Số 140, đường Hùng Vương, Thanh Hóa', '0932109876', 1),
('C014', 'Lê Thị Thu', 'Số 151, đường Lý Tự Trọng, Biên Hòa', '0921098765', 2),
('C015', 'Phạm Văn Thành', 'Số 162, đường Phan Bội Châu, Vĩnh Long', '0910987654', 1);


-- Meter (meter_id, customer_id, service_id, invoice_period, old_index, new_index, multiplier, electric_consumption, customer_name)
INSERT INTO Meter (meter_id, customer_id, service_id, invoice_period, old_index, new_index, multiplier, electric_consumption, customer_name) VALUES
('M001', 'C001', 1, 'Tháng 6/2024', 1200, 1850, 1, (1850-1200)*1, 'Nguyễn Văn A'),
('M002', 'C002', 2, 'Tháng 7/2024', 2500, 3150, 1, (3150-2500)*1, 'Nguyễn Xuân Bách'),
('M003', 'C003', 1, 'Tháng 8/2024', 3000, 3700, 1, (3700-3000)*1, 'Lê Văn Chính'),
('M004', 'C004', 2, 'Tháng 5/2024', 1400, 2050, 1, (2050-1400)*1, 'Phạm Thị Kỳ Duyên'),
('M005', 'C005', 1, 'Tháng 6/2024', 1600, 2350, 1, (2350-1600)*1, 'Võ Văn Toàn'),
('M006', 'C006', 2, 'Tháng 7/2024', 2300, 3000, 1, (3000-2300)*1, 'Phan Văn Hùng'),
('M007', 'C007', 1, 'Tháng 8/2024', 3500, 4200, 1, (4200-3500)*1, 'Đặng Thị Minh'),
('M008', 'C008', 2, 'Tháng 5/2024', 3800, 4450, 1, (4450-3800)*1, 'Ngô Văn Khánh'),
('M009', 'C009', 1, 'Tháng 6/2024', 2100, 2800, 1, (2800-2100)*1, 'Lý Thị Hương'),
('M010', 'C010', 2, 'Tháng 7/2024', 3900, 4550, 1, (4550-3900)*1, 'Dương Văn Kiên'),
('M011', 'C011', 1, 'Tháng 8/2024', 2200, 2950, 1, (2950-2200)*1, 'Hoàng Thị Lan'),
('M012', 'C012', 2, 'Tháng 5/2024', 2500, 3250, 1, (3250-2500)*1, 'Nguyễn Thị Mai'),
('M013', 'C013', 1, 'Tháng 6/2024', 2600, 3300, 1, (3300-2600)*1, 'Trần Văn Bình'),
('M014', 'C014', 2, 'Tháng 7/2024', 3300, 4000, 1, (4000-3300)*1, 'Lê Thị Thu'),
('M015', 'C015', 1, 'Tháng 8/2024', 2700, 3450, 1, (3450-2700)*1, 'Phạm Văn Thành');


-- ServicePricing (pricing_id, service_id, price_tier_1, price_tier_2, price_tier_3, price_tier_4, price_tier_5)
INSERT INTO ServicePricing (pricing_id, service_id, price_tier_1, price_tier_2, price_tier_3, price_tier_4, price_tier_5, price_tier_6) VALUES 
('P01', 1, 1806, 1866, 2167, 2729, 3050, 3151);


-- Invoice (invoice_id, customer_id, meter_id, service_id, service_name, electric_consumption, vat, invoice_date, payment_due_date)
INSERT INTO Invoice (invoice_id, customer_id, meter_id, service_id, service_name, electric_consumption, vat, invoice_date, payment_due_date) VALUES
('I001', 'C001', 'M001', 1, 'Điện sinh hoạt', (1850-1200)*1, 0.1, '2024-05-14', '2024-06-14'),
('I002', 'C002', 'M002', 2, 'Điện kinh doanh', (3150-2500)*1, 0.1, '2024-05-14', '2024-06-14'),
('I003', 'C003', 'M003', 1, 'Điện sinh hoạt', (3700-3000)*1, 0.1, '2024-05-14', '2024-06-14'),
('I004', 'C004', 'M004', 2, 'Điện kinh doanh', (2050-1400)*1, 0.1, '2024-05-14', '2024-06-14'),
('I005', 'C005', 'M005', 1, 'Điện sinh hoạt', (2350-1600)*1, 0.1, '2024-05-14', '2024-06-14'),
('I006', 'C006', 'M006', 2, 'Điện kinh doanh', (3000-2300)*1, 0.1, '2024-05-16', '2024-06-16'),
('I007', 'C007', 'M007', 1, 'Điện sinh hoạt', (4200-3500)*1, 0.1, '2024-05-15', '2024-06-18'),
('I008', 'C008', 'M008', 2, 'Điện kinh doanh', (4450-3800)*1, 0.1, '2024-05-20', '2024-06-20'),
('I009', 'C009', 'M009', 1, 'Điện sinh hoạt', (2800-2100)*1, 0.1, '2024-05-22', '2024-06-22'),
('I010', 'C010', 'M010', 2, 'Điện kinh doanh', (4550-3900)*1, 0.1, '2024-05-24', '2024-06-24'),
('I011', 'C011', 'M011', 1, 'Điện sinh hoạt', (2950-2200)*1, 0.1, '2024-05-26', '2024-06-26'),
('I012', 'C012', 'M012', 2, 'Điện kinh doanh', (3250-2500)*1, 0.1, '2024-05-28', '2024-06-28'),
('I013', 'C013', 'M013', 1, 'Điện sinh hoạt', (3300-2600)*1, 0.1, '2024-05-30', '2024-06-30'),
('I014', 'C014', 'M014', 2, 'Điện kinh doanh', (4000-3300)*1, 0.1, '2024-06-01', '2024-07-01'),
('I015', 'C015', 'M015', 1, 'Điện sinh hoạt', (3450-2700)*1, 0.1, '2024-06-02', '2024-07-02');


-- InvoiceDetail (invoice_detail_id, customer_id, payment_method, invoice_id)
INSERT INTO InvoiceDetail (invoice_detail_id, customer_id, payment_method, invoice_id) VALUES
('ID001', 'C001', 'Tiền mặt', 'I001'),
('ID002', 'C002', 'Chuyển khoản', 'I002'),
('ID003', 'C003', 'Tiền mặt', 'I003'),
('ID004', 'C004', 'Tiền mặt', 'I004'),
('ID005', 'C005', 'Tiền mặt', 'I005'),
('ID006', 'C006', 'Chuyển khoản', 'I006'),
('ID007', 'C007', 'Tiền mặt', 'I007'),
('ID008', 'C008', 'Chuyển khoản', 'I008'),
('ID009', 'C009', 'Tiền mặt', 'I009'),
('ID010', 'C010', 'Chuyển khoản', 'I010'),
('ID011', 'C011', 'Tiền mặt', 'I011'),
('ID012', 'C012', 'Chuyển khoản', 'I012'),
('ID013', 'C013', 'Tiền mặt', 'I013'),
('ID014', 'C014', 'Chuyển khoản', 'I014'),
('ID015', 'C015', 'Tiền mặt', 'I015');


-- Thêm giá trị mặc định cho cột total_amount_with_vat
ALTER TABLE Invoice ADD COLUMN total_amount_with_vat NUMERIC DEFAULT 0;

-- Sửa đổi hàm calculate_total_amount_with_vat
CREATE OR REPLACE FUNCTION calculate_total_amount_with_vat()
RETURNS TRIGGER AS $$
DECLARE 
    V_price_tier_1 NUMERIC;
    V_price_tier_2 NUMERIC;
    V_price_tier_3 NUMERIC;
    V_price_tier_4 NUMERIC;
    V_price_tier_5 NUMERIC;
    V_price_tier_6 NUMERIC;
    consumption NUMERIC;
    vat_value NUMERIC;
BEGIN
    SELECT price_tier_1, price_tier_2, price_tier_3, price_tier_4, price_tier_5, price_tier_6
    INTO V_price_tier_1, V_price_tier_2, V_price_tier_3, V_price_tier_4, V_price_tier_5, V_price_tier_6
    FROM ServicePricing
    WHERE service_id = NEW.service_id;
   
    consumption := NEW.electric_consumption;
    vat_value := NEW.vat;

    IF consumption <= 50 THEN
        NEW.total_amount_with_vat := consumption * V_price_tier_1 * (1 + vat_value);
    ELSIF consumption <= 100 THEN
        NEW.total_amount_with_vat := (50 * V_price_tier_1 + (consumption - 50) * V_price_tier_2) * (1 + vat_value);
    ELSIF consumption <= 200 THEN
        NEW.total_amount_with_vat := (50 * V_price_tier_1 + 50 * V_price_tier_2 + (consumption - 100) * V_price_tier_3) * (1 + vat_value);
    ELSIF consumption <= 300 THEN
        NEW.total_amount_with_vat := (50 * V_price_tier_1 + 50 * V_price_tier_2 + 100 * V_price_tier_3 + (consumption - 200) * V_price_tier_4) * (1 + vat_value);
    ELSIF consumption <= 400 THEN
        NEW.total_amount_with_vat := (50 * V_price_tier_1 + 50 * V_price_tier_2 + 100 * V_price_tier_3 + 100 * V_price_tier_4 + (consumption - 300) * V_price_tier_5) * (1 + vat_value);
    ELSE
        NEW.total_amount_with_vat := (50 * V_price_tier_1 + 50 * V_price_tier_2 + 100 * V_price_tier_3 + 100 * V_price_tier_4 + 100 * V_price_tier_5 + (consumption - 400) * V_price_tier_6) * (1 + vat_value);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Kích hoạt trigger sau khi thêm dữ liệu vào bảng Invoice
CREATE TRIGGER trg_calculate_total_amount_with_vat
BEFORE INSERT ON Invoice
FOR EACH ROW
EXECUTE FUNCTION calculate_total_amount_with_vat();