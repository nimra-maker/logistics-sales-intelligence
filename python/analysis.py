
import pandas as pd
from pathlib import Path

# Locate the dataset relative to this script
DATA_FILE = Path(__file__).resolve().parents[1] / "data" / "logistics_data.csv"

df = pd.read_csv(DATA_FILE)

# Convert date columns to datetime
date_columns = [
    "Inquiry_Date",
    "On_Board_Date",
    "ETA_Date",
    "Actual_Arrival_Date",
]

for column in date_columns:
    df[column] = pd.to_datetime(df[column], errors="coerce")

# Create useful analysis columns
df["Profit_USD"] = df["Revenue_USD"] - df["Cost_USD"]

df["Arrival_Delay_Days"] = (
    df["Actual_Arrival_Date"] - df["ETA_Date"]
).dt.days

print("\n--- DATASET OVERVIEW ---")
print(f"Total inquiries: {len(df)}")
print(f"Total columns: {len(df.columns)}")
print(f"Duplicate rows: {df.duplicated().sum()}")

print("\n--- SALES PERFORMANCE ---")
print(f"Total revenue: ${df['Revenue_USD'].sum():,.2f}")
print(f"Total cost: ${df['Cost_USD'].sum():,.2f}")
print(f"Total profit: ${df['Profit_USD'].sum():,.2f}")

print("\n--- JOB STATUS ---")
print(df["Job_Status"].value_counts(dropna=False))

print("\n--- REVENUE BY SALES PERSON ---")
print(
    df.groupby("Salesperson")["Revenue_USD"]
    .sum()
    .sort_values(ascending=False)
)

print("\n--- SHIPMENT MODE ---")
print(df.groupby("Mode")["Inquiry_ID"].count())

print("\n--- FOLLOW-UP REQUIRED ---")
print(df["Follow_Up_Required"].value_counts(dropna=False))

print("\n--- ARRIVAL PERFORMANCE ---")
print(f"Average arrival delay: {df['Arrival_Delay_Days'].mean():.2f} days")
print(f"Records with arrival dates: {df['Arrival_Delay_Days'].notna().sum()}")
