## PWTLoader

**PWTLoader** is a Python Package built as a lightweight loader for the main .dta file as well as additional .dta files from the Penn World Tables datasets hosted at dataverse into a pandas pd. 

This project uses data from the **Penn World Table (PWT), version 10.01**, developed by  
**Robert C. Feenstra, Robert Inklaar, and Marcel P. Timmer**  
at the **Groningen Growth and Development Centre**.

## Features

- Allows the download of the latest Penn World Table data from the dataverse
- Parse and preprocess data for further economic analysis.
- Work with data in pandas `DataFrame` format.

## Example 

Here's an example of how to run PWTLoader

```python
from PWTLoader import PWTLoader

# Create an instance of the loader
pwt = PWTLoader()

# Load the main dataset
df = pwt.load_data()

# If you want additional data
additional_data = pwt.additional_data(merge=True)

# To understand the structure of the additional data
pwt.describe_additional()

# Print out a preview of the data
print(df.head())
```

## Example 

Here's an example of how to run PWTLoader

```python
from PWTLoader import PWTLoader

# Create an instance of the loader
pwt = PWTLoader()

# Load the main dataset
df = pwt.load_data()

# If you want additional data
additional_data = pwt.additional_data(merge=True)

# To understand the structure of the additional data
pwt.describe_additional()

# Print out a preview of the data
print(df.head())
```

## 📘 Method Overview & Output

### `PWTLoader.load_data()`----------------------------------------------
- **Description**:  
  Downloads and loads the **main `.dta` file** from the latest Penn World Table version hosted on Dataverse.

- **Returns**:  
  A **`pandas.DataFrame`** containing the main dataset.  
  You can use the `PWTLoader.labels["variable_name"]` to access the description of a specific variable in the dataset.

- **Example**:
  ```python
  df = pwt.load_data()
  print(df.head())
  print(pwt.labels["cgdpo"])  # Description of the "cgdpo" variable


### `PWTLoader.additional_data(merge=False)`---------------------------
- **Description**:  
  Loads additional `.dta` files (from the same version) that complement the main dataset. If `merge=True`, it merges all compatible files together on common keys (`countrycode`, `year`).

- **Parameters**:
  - `merge` (bool) — If `True`, merges all additional datasets into one. If `False`, returns each dataset separately.

- **Returns**:
  - `merge=True` → A **dict** with a single key `"merge"` and a **merged `DataFrame`**.
  - `merge=False` → A **dict** of **dataframes** keyed by a short name (e.g., `'trade-detail'`, `'na_data'`, etc.).

- **Example**:
  ```python
  # Get separate dataframes
  addl_data = pwt.additional_data()
  print(addl_data.keys())
  print(addl_data["na_data"]["df"].head())  # Access specific dataframes

  # Get merged dataframe
  merged = pwt.additional_data(merge=True)
  print(merged["merged"].head())  # View merged dataframe

### `PWTLoader.describe_additional(data_dict)`-------------------------
- **Description**:  
  Prints a concise summary of additional data files in the given dictionary, including:
  - Dataset name
  - Description
  - Number of rows/columns

- **Parameters**:
  - `data_dict` (dict) — The dictionary returned from `additional_data()` (with `merged=False`).

- **Returns**:  
  - Nothing (just prints to console).

- **Example**:
  ```python
  # Get additional data
  addl_data = pwt.additional_data()

  # Print a summary of each dataset
  pwt.describe_additional(addl_data)

## Installation

You can install PWTLoader directly via pip;
```bash
pip install PWTLoader
```

To install the necessary dependencies, you can use the `requirements.txt` file:

```bash
pip install -r PWTLoader/requirements.txt
```
## Requirements

- Python 3.7 or higher
- pandas
- requests
- lxml
- beautifulsoup4
- html5lib


## Overview of Directory Structure
PWTLoader/
│
├── __init__.py            # Package initialization
├── loader.py              # Main logic to load PWT data
├── requirements.txt       # Dependencies
├── setup.py               # Package setup
├── README.md              # Project documentation
├── .gitignore             # Files to ignore

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Credits and Citation

This project uses data from the Penn World Table (PWT), version 10.01, which includes information on relative levels of income, output, input, and productivity, covering 183 countries from 1950 to 2019.

The data can be accessed from Dataverse: https://doi.org/10.34894/QT5BCC.

# Citation

## Citation

When using this data (for any purpose), please use the following citation:

**Feenstra, Robert C., Robert Inklaar, and Marcel P. Timmer (2015)**, “The Next Generation of the Penn World Table,” *American Economic Review*, 105(10), 3150-3182, [DOI: 10.1257/aer.20130954](https://doi.org/10.1257/aer.20130954).

## License

The data is licensed under CC-BY-4.0, which allows you to share and adapt the data as long as you give appropriate credit.
