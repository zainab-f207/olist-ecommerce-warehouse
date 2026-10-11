# Olist E-commerce Data Warehouse

An end-to-end data engineering project that loads Brazilian Olist e-commerce CSV data into PostgreSQL, transforms it using dbt, and orchestrates the pipeline with Apache Airflow and Docker.

## Technologies

- Python and pandas
- PostgreSQL
- Apache Airflow 2.10.4
- dbt Core with the PostgreSQL adapter
- Docker and Docker Compose
- Git and GitHub

## Project Architecture

1. **Data source:** Olist e-commerce CSV files.
2. **Data loading:** `load_staging.py` loads the CSV files into PostgreSQL staging tables.
3. **Data transformation:** dbt builds staging models, dimension tables, and fact tables.
4. **Orchestration:** Airflow runs the loading, transformation, and testing tasks in order.
5. **Data quality:** dbt runs data tests to check null values, uniqueness, accepted values, and relationships.

## Project Structure

```text
olist-ecommerce-warehouse/
├── airflow/
│   ├── dags/
│   │   └── olist_pipeline.py
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   └── .env.example
├── data/                       # Local CSV files; not committed
├── load_staging.py
├── olist_warehouse/
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   ├── dbt_project.yml
│   └── profiles.yml
├── .gitignore
└── README.md
```

## Pipeline Tasks

The Airflow DAG is named `olist_warehouse_pipeline` and runs three tasks in order:

1. `load_staging` — loads CSV data into PostgreSQL.
2. `dbt_run` — builds the dbt data models.
3. `dbt_test` — executes the dbt data quality tests.

## Data Warehouse Models

The project includes staging models and analytical models such as:

- Dimensions: customers, products, sellers, and dates.
- Fact tables: orders, order items, payments, and reviews.

## Validation Results

The pipeline has completed successfully twice in the new Docker setup.

Latest recorded dbt test result:

- Passed: 32
- Warnings in data tests: 0
- Errors: 0
- Skipped: 0

## Local Setup

### Prerequisites

- Docker Desktop
- Git
- The Olist e-commerce dataset CSV files
- A PostgreSQL database for the Olist staging tables

### 1. Clone the repository

```bash
git clone https://github.com/zainab-f207/olist-ecommerce-warehouse.git
cd olist-ecommerce-warehouse
```

### 2. Add the dataset

Create the `data/` directory and place these eight CSV files inside it:

- `olist_customers_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_products_dataset.csv`
- `olist_sellers_dataset.csv`
- `product_category_name_translation.csv`

The dataset is not included in this repository.

### 3. Configure environment variables

Copy `airflow/.env.example` to `airflow/.env` and set your own database and Airflow credentials. Never commit the real `.env` file.

### 4. Prepare the PostgreSQL database

Make sure your PostgreSQL database is running and accessible to the Airflow containers. The existing Olist database container must be reachable using the hostname `de_postgres` on the Docker network.

The loader uses these environment variables:

- `PG_HOST`
- `PG_USER`
- `PG_PASSWORD`

### 5. Start Airflow

Open a terminal in the `airflow/` directory and run:

```bash
docker compose up -d --build
```

Wait for the Airflow services to initialize. Then open `http://localhost:8080` in your browser and sign in using your configured Airflow credentials.

Trigger the `olist_warehouse_pipeline` DAG and confirm that `load_staging`, `dbt_run`, and `dbt_test` succeed.

**Note:** Ensure the existing `de_postgres` container is connected to the `olist_airflow_default` Docker network before running the pipeline.

### 6. Check data quality

The dbt test suite checks data quality and relationships between warehouse models. In the latest successful run, all 32 tests passed without warnings or errors.

