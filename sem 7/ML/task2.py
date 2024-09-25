import numpy as np
# task 1
df = np.loadtxt(fname='wind-data-1969.csv', comments='%', delimiter=',')

# task 2.1

current_year = 69
bad_year = 0

df[df[:, 0] == bad_year, 0] = current_year

print(df[:, 0])

# task 2.2

for i in range(-1, -13, -1):
  current_mean = np.nanmean(df[:, i])
  df[np.isnan(df[:, i]), i] = current_mean

print(df)
np.count_nonzero(np.isnan(df))

# task 3

print(np.max(df[:, 3:]))
print(np.min(df[:, 3:]))
print(np.mean(df[:, 3:]))
print(np.std(df[:, 3:]))

# task 4

print(np.array([
    np.max(df[:, 3:], axis=0),
    np.min(df[:, 3:], axis=0),
    np.mean(df[:, 3:], axis=0),
    np.std(df[:, 3:], axis=0)
]).T)

# task 5

days_stat = np.array([
    np.max(df[:, 3:], axis=1),
    np.min(df[:, 3:], axis=1),
    np.mean(df[:, 3:], axis=1),
    np.std(df[:, 3:], axis=1)
])

print(days_stat.T)
print(np.hstack((df, days_stat[0, None].T)))

# task 6

np.argmax(df[:, 3:].T, axis=0)

# task 7
import datetime

ind = np.unravel_index(np.argmax(df[:, 3:]), df.shape)
date = np.int_(df[ind[0], 0:3])
print(datetime.datetime(date[0] + 1900, date[1], date[2]))

# task 8

print(np.mean(df[df.T[1] == 1, 3:].T, axis=1))

# task 9

formatted = []
for row in df:
  formatted_row = []
  for val in row:
    if float(val).is_integer():
      formatted_row.append(f"{int(val)}") 
    else: 
      formatted_row.append(f"{val:.4f}")
  formatted.append(formatted_row)

print(formatted)
with open("result.csv", "wb") as f:
    np.savetxt(f, formatted, fmt='%s', delimiter=',')

# task 10

for i in range(1, 13):
  print(np.mean(df[df.T[1] == i, 3:].T))