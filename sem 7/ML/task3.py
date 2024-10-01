from google.colab import files
import io
uploaded = files.upload()
data = io.BytesIO(uploaded['mental_health_and_technology_usage_2024.csv'])

import pandas as pd

# task 1
df = pd.read_csv('mental_health_and_technology_usage_2024.csv')
print(df.head(10))

#task 2
print(len(df.columns))
print(len(df))
print(df.info())

# task 3

print(df.columns)

# task 4

df.select_dtypes(include='number').describe()

# task 5

df.select_dtypes(exclude='number').describe()

# task 6

df_ = df.select_dtypes(exclude='number')
for col in df_.columns:
    print(col)
    print(df_[col].unique()) # to print categories name only
    # print(df_[col].value_counts()) # to print count of every category


# task 7

grouped_to_gaming = df.groupby(['Mental_Health_Status']).agg({'Gaming_Hours': ['mean']})
grouped_to_screen = df.groupby(['Mental_Health_Status']).agg({'Screen_Time_Hours': ['mean']})
grouped_to_sleep = df.groupby(['Mental_Health_Status']).agg({'Sleep_Hours': ['mean']})
print(grouped_to_gaming)
print(grouped_to_screen)
print(grouped_to_sleep)