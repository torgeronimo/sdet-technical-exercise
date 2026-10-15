from selenium import webdriver

def get_chrome_options():
    options = webdriver.ChromeOptions()
    options.add_experimental_option("prefs", {
        "profile.password_manager_leak_detection": False
    })
    return options
