# SauceDemo SDET Automation Framework

A web UI automation project using **Robot Framework**, **Python**, **SeleniumLibrary**, and **Selenium WebDriver** to test the [SauceDemo (Swag Labs)](https://www.saucedemo.com/) demonstration e-commerce application.

This repository was developed as an SDET technical exercise. Its focus is readable test cases, reusable keywords, meaningful assertions, isolated browser sessions, and reproducible execution.


**Latest reported regression result:** **25 tests passed, 0 failed** 

## Contents

- [Technology stack](#technology-stack)
- [Requirements](#requirements)
- [Project structure](#project-structure)
- [Quick start (Windows PowerShell)](#quick-start-windows-powershell)
- [Run tests](#run-tests)
- [Test coverage](#test-coverage)
- [How the framework works](#how-the-framework-works)
- [Configuration](#configuration)
- [Reports and debugging](#reports-and-debugging)
- [Troubleshooting](#troubleshooting)
- [Version control](#version-control)
- [Limitations and future improvements](#limitations-and-future-improvements)

## Technology stack

| Tool | Role |
| --- | --- |
| Python | Runtime for Robot Framework and optional custom libraries |
| Robot Framework | Test runner, test syntax, assertions, reporting |
| SeleniumLibrary | Robot Framework keywords for browser automation |
| Selenium WebDriver | Browser interaction through the browser driver |
| Google Chrome | Browser used for local test execution |
| Git and GitHub | Version control and code review |

The project was developed on Windows with Python 3.13.5 and Chrome. Exact installed package versions are defined by `requirements.txt`; install from that file rather than assuming the versions shown here.

## Requirements

- Python 3 installed and available through the `python` command (Python 3.13.5 used during development)
- Google Chrome installed
- Git (for cloning and version control)
- Internet connection to access SauceDemo and download Python dependencies
- Windows PowerShell for the commands below

Modern Selenium generally uses Selenium Manager to locate or obtain a compatible browser driver. If driver setup fails, check your Chrome installation, network access, and Selenium version.

## Project structure

```text
saucedemo-sdet/
├── tests/
│   ├── 00_smoke.robot
│   ├── 01_login.robot
│   ├── 02_inventory.robot
│   └── 03_cart_checkout.robot
├── resources/
│   ├── common.resource
│   ├── login.resource
│   ├── inventory.resource
│   └── checkout.resource
├── variables/
│   └── config.py
├── results/                    # Generated locally; should be Git-ignored
├── requirements.txt
├── .gitignore
└── README.md
```


## Quick start (Windows PowerShell)

Run these commands from a terminal. If you already cloned the repository, skip the clone step.

### 1. Clone and enter the repository

```powershell
git clone https://github.com/torgeronimo/sdet-technical-exercise.git
cd sdet-technical-exercise
```

If your local folder has a different name (for example `saucedemo-sdet`), open that folder instead. All subsequent commands assume the terminal is at the repository root, where `requirements.txt` exists.

### 2. Verify Python

```powershell
python --version
```

### 3. Create a virtual environment

```powershell
python -m venv .venv
```

A virtual environment keeps project dependencies separate from globally installed packages.

### 4. Install dependencies

You can install packages **without activating** the virtual environment. This avoids PowerShell execution-policy issues:

```powershell
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Alternatively, activate the environment and use `python` normally:

```powershell
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

If activation is blocked, use the explicit `.venv\Scripts\python.exe` commands throughout this README. Do not change your machine's execution policy just to run the tests.

### 5. Confirm Robot Framework is installed

```powershell
.\.venv\Scripts\python.exe -m robot --version
```

### 6. Run the complete suite

```powershell
.\.venv\Scripts\python.exe -m robot -d results tests/
```

Chrome will open during browser-based tests. The command creates the `results/` folder if necessary.

## Run tests

All commands below use the virtual environment's Python directly. From an activated virtual environment, you may replace `.\.venv\Scripts\python.exe` with `python`.

### Run all test suites

```powershell
.\.venv\Scripts\python.exe -m robot -d results tests/
```

### Run one suite

```powershell
# Smoke tests
.\.venv\Scripts\python.exe -m robot -d results tests/00_smoke.robot

# Login tests
.\.venv\Scripts\python.exe -m robot -d results tests/01_login.robot

# Inventory tests
.\.venv\Scripts\python.exe -m robot -d results tests/02_inventory.robot

# Cart and checkout tests
.\.venv\Scripts\python.exe -m robot -d results tests/03_cart_checkout.robot

# Test Everything
.\.venv\Scripts\python.exe -m robot -d results tests
```

### Run a single test by ID

The `-t` option matches the test name. The `*` wildcard allows the descriptive part of the test name to vary.

```powershell
.\.venv\Scripts\python.exe -m robot -d results -t "INV-007*" tests/02_inventory.robot
.\.venv\Scripts\python.exe -m robot -d results -t "INV-009*" tests/02_inventory.robot
.\.venv\Scripts\python.exe -m robot -d results -t "CHECKOUT-003*" tests/03_cart_checkout.robot
```

### Run multiple selected tests

```powershell
.\.venv\Scripts\python.exe -m robot -d results -t "INV-007*" -t "INV-009*" -t "INV-010*" tests/02_inventory.robot
```



### Validate syntax without opening Chrome

```powershell
.\.venv\Scripts\python.exe -m robot --dryrun -d results tests/
```

A dry run checks whether tests and keywords can be parsed and resolved. **It does not prove that locators work or that application behavior is correct.**

### Keep results from separate runs

Robot Framework overwrites its usual report files in `results/` on subsequent runs. Use distinct output directories when you need to preserve both runs:

```powershell
.\.venv\Scripts\python.exe -m robot -d results/inventory tests/02_inventory.robot
.\.venv\Scripts\python.exe -m robot -d results/full tests/
```

## Test coverage

The following scenarios are implemented. The project author reports a successful complete regression run with 25/25 tests passing.

| Suite | Test IDs | Coverage |
| --- | --- | --- |
| Smoke | 1 smoke test | Basic application access / smoke behavior |
| Login | LOG suite (7 tests) | Valid and invalid credentials, required fields, logout and related validation |
| Inventory | INV-001–INV-010 (10 tests in enhanced branch) | Product visibility, information, sorting, details, navigation, details-page cart actions |
| Cart and checkout | CART-001–CART-004, CHK-001–CHK-003 | Add/remove cart behavior, cart contents, required checkout fields, successful purchase |

**Latest reported result: 25 passed, 0 failed** (1 smoke + 7 login + 10 inventory + 7 cart/checkout). The earlier baseline contained 22 tests; three new product-details scenarios increased coverage to 25, while INV-007 was expanded. The latest result was reported by the author; it was not independently executed while preparing this README.

### Login Testing (7 Tests)

| Test ID | Test Scenario | Expected Result |
|---------|---------------|-----------------|
| LOGIN-001 | Login With Valid Credentials | User successfully logs in and is redirected to the inventory page. |
| LOGIN-002 | Login With Invalid Password | An appropriate authentication error message is displayed. |
| LOGIN-003 | Login With Invalid Username | Login is rejected and an error message is displayed. |
| LOGIN-004 | Login With Empty Username | Username required validation message is displayed. |
| LOGIN-005 | Login With Empty Password | Password required validation message is displayed. |
| LOGIN-006 | Login With Locked-Out User | Access is denied and the locked-out account error is displayed. |
| LOGIN-007 | User Can Logout | User successfully logs out and returns to the login page. |

### Inventory scenarios (10 Tests)

| ID | Scenario |
| --- | --- |
| INV-001 | Inventory page displays products |
| INV-002 | Product cards display required information and valid prices |
| INV-003 | Sort names A to Z |
| INV-004 | Sort names Z to A |
| INV-005 | Sort prices low to high |
| INV-006 | Sort prices high to low |
| INV-007 | Details page matches inventory name, description, price, and image URL |
| INV-008 | Back to Products returns to inventory |
| INV-009 | Add to Cart from details updates button and badge |
| INV-010 | Remove from Cart from details restores button and clears badge |

### Shopping Cart Testing (4 Tests)

| Test ID | Test Scenario | Expected Result |
|---------|---------------|-----------------|
| CART-001 | Add Item Updates Cart Badge | Adding a product updates the cart badge to display 1. |
| CART-002 | Removing Item Clears Cart Badge | Removing the product removes the cart badge. |
| CART-003 | Added Item Appears In Cart | The selected product is displayed in the shopping cart with the correct product information. |
| CART-004 | Removing Item From Cart Empties Cart | Removing the product from the cart leaves the cart empty. |

### Checkout Testing (3 Tests)

| Test ID | Test Scenario | Expected Result |
|---------|---------------|-----------------|
| CHECKOUT-001 | Checkout Requires First Name | An error message is displayed when the first name is missing. |
| CHECKOUT-002 | Checkout Requires Postal Code | An error message is displayed when the postal code is missing. |
| CHECKOUT-003 | Customer Can Complete Checkout | The customer completes the checkout process and receives a successful order confirmation. |

### Viewing Test Reports

After execution, Robot Framework generates the following files inside the `results/` directory:

- `report.html` — Test execution summary and statistics.
- `log.html` — Detailed keyword execution logs and failure information.
- `output.xml` — Machine-readable execution results.

Open the HTML report in your browser:

```powershell
start results/report.html
```

## How the framework works

The project uses a **keyword-driven** structure:

1. `tests/*.robot` expresses the scenarios and expected behavior.
2. `resources/*.resource` contains reusable browser actions and assertions.
3. `variables/config.py` defines the application URL, browser, and timeout.
4. SeleniumLibrary passes browser commands to Selenium WebDriver.
5. Robot Framework produces execution logs and reports.

Each inventory test uses a setup keyword to open the browser, log in, and verify the inventory page. Teardown closes browsers after each test, helping avoid shared cart or login state between tests.

Example:

```robotframework
INV-008 Back To Products Button Works
    Open Product Details    ${TEST_PRODUCT}
    Return To Inventory
    Verify Returned To Inventory
```

The test describes *what* is being checked; the resource keywords contain *how* the browser performs each action.

## Configuration

`variables/config.py` currently defines values similar to:

```python
BASE_URL = "https://www.saucedemo.com/"
BROWSER = "chrome"
TIMEOUT = "10s"
```

Change these only if you need to target a different supported browser or environment. SauceDemo's published demonstration credentials are used by the tests; they are not private account credentials.

## Reports and debugging

After a run, Robot Framework generates:

| File | Purpose |
| --- | --- |
| `results/report.html` | Summary, counts, pass/fail overview |
| `results/log.html` | Detailed step-by-step keyword execution and failures |
| `results/output.xml` | Machine-readable execution results |

Open the reports in PowerShell:

```powershell
start results\report.html
start results\log.html
```


### Browser driver errors

Verify Chrome is installed, reinstall project dependencies, and check that Selenium can access or obtain a compatible driver.

## Version control

Work was organized into feature branches and pull requests for individual milestones (login, inventory, cart/checkout, and product-details enhancement). A typical workflow is:

```powershell
git switch main
git pull origin main
git switch -c feature/(*Branch Name*)
git add .
git commit -m "docs: document test framework and execution"
git push -u origin feature/(*Branch Name*)
```

Open a pull request on GitHub after reviewing the diff and validating the changes. Do not commit `.venv/`, generated results, or local secrets.




## Latest regression verification

The project author reported a successful full run on **October 15, 2026**:

| Suite | Tests | Passed | Failed |
| --- | ---: | ---: | ---: |
| Smoke (`00_smoke.robot`) | 1 | 1 | 0 |
| Login (`01_login.robot`) | 7 | 7 | 0 |
| Inventory (`02_inventory.robot`) | 10 | 10 | 0 |
| Cart and checkout (`03_cart_checkout.robot`) | 7 | 7 | 0 |
| **Total** | **25** | **25** | **0** |

Reproduce the result from the repository root:

```powershell
.\.venv\Scripts\python.exe -m robot -d results tests/
```

