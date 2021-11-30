# ST443 Project Section 1

## Structure of the file

Folder Factor_data contains manually downloaded factor return data from WRDS.

Paper_and_Thoughts is intended to get insights from some papers, which can be used in our report.

stock_monthly_data contains all monthly return

Columns_fetcher gets factor return of all factors(each factor has a csv containing its return) from the folder Factor_data and alsp FF 5 factors from the csv and merge them with date.

Fetch_data gets stock monthly return from using quantmod and TSR. 

merge_data_for_regression select stock returns from the folder stock_monthly_data and merge the stock return with the factor return, finally produces a matrix which can be directly used for machine learning analysis.

factor_data_sum contains all of factor returns.
