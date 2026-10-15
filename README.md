# SauceDemo SDET Automation Framework

An automated web UI testing project built using **Robot Framework, Python, and SeleniumLibrary**.

## Application Under Test

- Website: https://www.saucedemo.com/
- Application: SauceDemo (Swag Labs)
- Type: E-commerce demonstration application

## Technologies

- Python
- Robot Framework
- SeleniumLibrary
- Selenium WebDriver
- Git and GitHub

## Project Structure

- `tests/` — Automated test cases
- `resources/` — Reusable keywords and browser interactions
- `libraries/` — Custom Python testing utilities
- `variables/` — Test configuration
- `results/` — Generated test reports and logs
- `.github/workflows/` — Continuous integration configuration

## Getting Started

### 1. Create a virtual environment

```powershell
python -m venv .venv
```

### 2. Activate the environment

```powershell
.\.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```powershell
python -m pip install -r requirements.txt
```

## Running Tests

Once the automated tests have been implemented, run the complete test suite using:

```powershell
python -m robot -d results tests/
```

## Test Reports

Robot Framework generates the following files after test execution:

- `report.html` — High-level execution summary
- `log.html` — Detailed execution log
- `output.xml` — Machine-readable test results

## Test Coverage

Planned coverage includes:

- Login authentication and validation
- Product inventory and sorting
- Shopping cart operations
- Checkout form validation
- End-to-end purchase workflow

## Continuous Integration

GitHub Actions integration is planned to automate test execution.

## Project Status

Under active development as part of an SDET technical exercise.