-- Create Database
CREATE DATABASE Financial_Analytics;
USE Financial_Analytics;

-- 1. Customers Table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    segment VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL,
    region VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(customer_id)
);

-- 2. Vendors Table
CREATE TABLE vendors (
    vendor_id VARCHAR(50) PRIMARY KEY,
    vendor_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    active VARCHAR(1) NOT NULL CHECK (active IN ('Y', 'N')),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(vendor_id)
);

-- 3. Headcount Table
CREATE TABLE headcount (
    employee_id VARCHAR(50) PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    business_unit VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    region VARCHAR(100) NOT NULL,
    cost_to_company DECIMAL(15,2) NOT NULL CHECK (cost_to_company >= 0),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id)
);

-- 4. Budget Table
CREATE TABLE budget (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL CHECK (year BETWEEN 2000 AND 2100),
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    business_unit VARCHAR(100) NOT NULL,
    budgeted_revenue DECIMAL(15,2) NOT NULL,
    budgeted_expense DECIMAL(15,2) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(year, month, business_unit)
);

-- 5. Financial_Transactions Table (Main Fact Table)
CREATE TABLE financial_transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    transaction_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    account_type VARCHAR(50) NOT NULL CHECK (account_type IN ('Revenue', 'Expense', 'Asset', 'Liability', 'Equity')),
    category VARCHAR(100) NOT NULL,
    business_unit VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    customer_id VARCHAR(50),
    vendor_id VARCHAR(50),
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(transaction_id),
    
    -- Foreign Key Constraints
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

-- Create Indexes for Performance
CREATE INDEX idx_transactions_date ON financial_transactions(transaction_date);
CREATE INDEX idx_transactions_business_unit ON financial_transactions(business_unit);
CREATE INDEX idx_transactions_region ON financial_transactions(region);
CREATE INDEX idx_transactions_category ON financial_transactions(category);
CREATE INDEX idx_budget_period ON budget(year, month);
CREATE INDEX idx_customers_region ON customers(region);
CREATE INDEX idx_vendors_category ON vendors(category);