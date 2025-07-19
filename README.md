# Welcome to PlanetKart Data Warehouse & Analytics

This dbt project implements a data warehouse solution for PlanetKart, an interplanetary e-commerce company operating across Earth, Mars, and Venus.

## Project Overview

We’ve built a robust data pipeline using Airbyte, Snowflake, and dbt, applying key data warehousing concepts:

- **Star Schema**: Fact (`fact_orders`) and Dimension tables (`dim_customers`, `dim_products`, `dim_regions`)
- **Surrogate Keys**: Generated using `dbt_utils.generate_surrogate_key`
- **Slowly Changing Dimensions**: Implemented Type 2 SCD on customers table using dbt snapshots.

## Project Structure

```bash
models/
├── staging
│   ├── stg_customers.sql
│   ├── stg_orders.sql
│   ├── stg_order_items.sql
│   ├── stg_products.sql
│   ├── stg_regions.sql
│   └── schema.yml
└── finalmodel
    ├── dim_customers.sql
    ├── dim_products.sql
    ├── dim_regions.sql
    └── fact_orders.sql

snapshots/
└── snapshot_customers.sql
```

##  Setup and Running Instructions

### Step 1: Install Dependencies

```bash
dbt deps
```

### Step 2: Run the models

```bash
dbt run
```

### Step 3: Run tests

```bash
dbt test
```

### Step 4: Generate and view documentation

```bash
dbt docs generate
dbt docs serve
```

##  Schema & Lineage Diagram

To view the star schema and lineage, run:

```bash
dbt docs serve
```

Navigate to the lineage graph to see the visual representation clearly outlining the relationships between fact and dimension tables.

##  Assumptions Made:

- Orders represent a complete transaction, associated with exactly one customer.
- Products and regions are static dimensions with no history tracking required.
- Customer data frequently changes, hence Type 2 SCD applied using snapshots.
- The primary grain of the fact table is at the order level (one row per order).

## Screenshots Included in Submission (doc shared):

- Airbyte pipeline configuration
- Snowflake data validation (raw and final tables)
- dbt snapshot (Type 2 SCD evidence)
- dbt lineage graph illustrating star schema

##  Enhancements (for future):

- Additional freshness and anomaly tests (dbt-utils)
- Macros to streamline repeated logic
- Dashboard visualization layer using tools like Power BI, Looker Studio, or Metabase

---

## Technologies Used

- **Airbyte**
- **Snowflake**
- **dbt Core**
- **dbt_utils**

##  Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt_utils Package](https://github.com/dbt-labs/dbt-utils)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [Airbyte Documentation](https://docs.airbyte.com/)


### Other Learning Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

