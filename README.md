# Welcome to PlanetKart Data Warehouse & Analytics

This dbt project implements a data warehouse solution for PlanetKart, an interplanetary e-commerce company operating across Earth, Mars, and Venus.

## Project Overview

We’ve built a robust data pipeline using Airbyte, Snowflake, and dbt, applying key data warehousing concepts:

- **Airbyte** used to ingest raw data into Snowflake
- **Star Schema** implemented with fact and dimension models
- **Surrogate Keys** generated using `dbt_utils.generate_surrogate_key`
- **Type 2 SCD** applied to customer dimension via `dbt snapshots`
- **Freshness Testing** applied on source table using `dbt source freshness`
- **DRY Logic** via custom macro `format_full_name`
- **All models built and materialized using Snowflake & dbt Core**
- **Looker Studio Dashboard** powered by `region_order_summary` model



## Project Structure

```bash
models/
├── staging/
│   ├── stg_customers.sql
│   ├── stg_orders.sql
│   ├── ...
│   └── schema.yml
├── finalmodel/
│   ├── dim_customers.sql
│   ├── dim_products.sql
│   ├── dim_regions.sql
│   ├── fact_orders.sql
│   ├── dim_demo_dry_customers.sql
│   └── region_order_summary.sql
snapshots/
├── snapshot_customers.sql
macros/
├── generate_key.sql
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

### Step 4. Run snapshot
```bash
dbt snapshot
```

### Step 5. Run freshness test
```bash
dbt source freshness
```

### Step 6. View documentation
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

---

## Features Implemented

### Star Schema
- Fact table: `fact_orders`
- Dimension tables: `dim_customers`, `dim_products`, `dim_regions`

###  Type 2 SCD
- `snapshot_customers.sql` tracks historical changes in customer records

###  Freshness Check
- Applied to Airbyte-loaded view `vw_orders`
- Uses `order_date_cast` as the loaded_at field

### DRY Logic (Custom Macro)
- `format_full_name(first_name, last_name)` used in `dim_demo_dry_customers`

---
## Aggregated Insights Model

###  `region_order_summary.sql`

This model calculates:
- Total orders and revenue by `planet` and `zone`
- Used in dashboard for geographic-level KPIs

---

## Dashboard Layer (Looker Studio)

A dashboard was built using **Google Looker Studio** on top of the `region_order_summary` model.

### Includes:
-  Bar Chart: Orders by Planet
-  Pie Chart: Revenue by Zone
- Table: Orders + Revenue by Planet & Zone
-  Filter controls for zone selection

### Data Source:
```sql
PLANETKART_ANALYTICS.REGION_ORDER_SUMMARY
```
---
##  Assumptions Made:

- Orders represent a complete transaction, associated with exactly one customer.
- Products and regions are static dimensions with no history tracking required (no SDC applied).
- Customer data frequently changes, hence Type 2 SCD applied using snapshots.
- The primary grain of the fact table is at the order level (one row per order).
- Freshness interval configured to simulate stale/pass scenarios.
- Revenue calculated as quantity × price (from order items).

---

## Tools and Technologies Used

- **Airbyte**
- **Snowflake**
- **dbt Core**
- **dbt_utils**

##  Refrences

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt_utils Package](https://github.com/dbt-labs/dbt-utils)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [Airbyte Documentation](https://docs.airbyte.com/)

## Other Learning Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

