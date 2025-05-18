# Replicating Aguiar & Gopinath (2007) – GMM Estimation in Python

This repository contains a Python-based framework for estimating a small open economy Real Business Cycle (RBC) model with trend shocks, based on:

**Aguiar, M. & Gopinath, G. (2007)**  
*Emerging Market Business Cycles: The Cycle is the Trend.* Journal of Political Economy.

## Project Overview

The project performs:

- **Extraction of empirical macroeconomic data** from FRED using the `fredapi`.
- **Preprocessing and detrending** using the Hodrick-Prescott (HP) filter.
- **Calculation of empirical moments** (e.g., standard deviations and correlations).
- **GMM estimation of structural parameters** by:
  - Writing parameters to a `.mod` file,
  - Running **Dynare** inside **Octave** from Python in each GMM iteration,
  - Reading back simulated model moments from Dynare output.

The estimation is done by minimizing the loss function between empirical and simulated moments.

## Components

- `main_script.py`: Python script that automates the entire process (data loading, moment calculation, GMM estimation).
- `ag3.mod`: A modified Dynare implementation of the Aguiar & Gopinath (2007) model. Based on the version by Jonathan Pfeifer ([link](https://github.com/JohannesPfeifer/DSGE_mod)).
- `LICENSE`: GNU General Public License v3.
- `param2.m`: Parameter file written by Python, used by Dynare in each run.

## 🛠️ Requirements

- Python 3.8+
- `fredapi`, `numpy`, `pandas`, `scipy`, `statsmodels`
- **Octave** with **Dynare** installed and accessible via command line

Install required Python packages:

```bash
pip install -r requirements.txt