import os
import pandas as pd
from sqlalchemy import create_engine, text, inspect

PG_HOST = os.environ.get("PG_HOST", "localhost")
PG_USER = os.environ.get("PG_USER", "postgres")
PG_PASSWORD = os.environ["PG_PASSWORD"]

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
engine = create_engine(f"postgresql://{PG_USER}:{PG_PASSWORD}@{PG_HOST}:5432/postgres")

files_to_load = {
    "staging_customers": "data/olist_customers_dataset.csv",
    "staging_orders": "data/olist_orders_dataset.csv",
    "staging_order_items": "data/olist_order_items_dataset.csv",
    "staging_order_payments": "data/olist_order_payments_dataset.csv",
    "staging_order_reviews": "data/olist_order_reviews_dataset.csv",
    "staging_products": "data/olist_products_dataset.csv",
    "staging_sellers": "data/olist_sellers_dataset.csv",
    "staging_category_translation": "data/product_category_name_translation.csv",
}

for table_name, file_path in files_to_load.items():
    df = pd.read_csv(os.path.join(BASE_DIR, file_path))
    with engine.begin() as conn:
        if inspect(engine).has_table(table_name):
            conn.execute(text(f"TRUNCATE TABLE {table_name}"))
        df.to_sql(table_name, conn, if_exists="append", index=False)
    print(f"Loaded {len(df)} rows into {table_name}")

print("All files loaded.")