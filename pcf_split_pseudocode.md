# PCF Split Pseudocode

1. Load data into dataframe
2. Clean data
   1. Convert all PNs to string types
3. Extract months into array
4. Loop through each month:
   1. Filter dataframe for that month
   2. Open a new CSV
   3. Write header line to CSV
   4. For each row in filtered DF:
      1. Write that row to CSV
   5. Save CSV, go to next.