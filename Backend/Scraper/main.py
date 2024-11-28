import os
import sys
import json
import asyncio
from playwright.async_api import async_playwright, TimeoutError as PlaywrightTimeoutError
from requests import post
from amazon import get_product as get_amazon_product

AMAZON = "https://www.amazon.ca"

URLS = {
    AMAZON: {
        "search_field_query": 'input[name="field-keywords"]',
        "search_button_query": 'input#nav-search-submit-button',
        "product_selector": "div.s-result-item[data-component-type='s-search-result']",
        "main_content_selector": '#nav-main'
    }
}

def load_auth():
    FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'auth.json')
    try:
        with open(FILE, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"auth.json not found at {FILE}")
        raise

# Load credentials
cred = load_auth()
print(f"Loaded Bright Data credentials for user: {cred['username']}")
auth = f'{cred["username"]}:{cred["password"]}'
browser_url = f'wss://{auth}@{cred["host"]}'

async def search(metadata, page, search_text):
    print(f"Searching for {search_text} on {page.url}")
    search_field_query = metadata.get("search_field_query")
    search_button_query = metadata.get("search_button_query")

    if search_field_query and search_button_query:
        print("Filling input field")
        search_box = await page.wait_for_selector(search_field_query)
        await search_box.type(search_text)
        print("Pressing search button")
        button = await page.wait_for_selector(search_button_query)
        await button.click()
    else:
        raise Exception("Could not search.")

    await page.wait_for_load_state()
    return page

async def get_products(page, search_text, product_selector, func):
    print("Getting products.")
    await page.wait_for_selector(product_selector)
    product_divs = await page.query_selector_all(product_selector)
    print(f"Found {len(product_divs)} products.")

    tasks = [func(product_div) for product_div in product_divs]
    products = await asyncio.gather(*tasks)
    return products

def post_results(results, endpoint, search_text, source):
    payload = {
        "data": results,
        "search_text": search_text,
        "source": source
    }
    response = post(f"http://localhost:5000{endpoint}", json=payload)
    if response.status_code == 200:
        print("Results posted successfully.")
    else:
        print(f"Failed to post results: {response.status_code}")

async def main(url, search_text, response_route):
    metadata = URLS.get(url)
    if not metadata:
        print("Invalid URL.")
        return

    async with async_playwright() as pw:
        print('Connecting to browser.')
        browser = await pw.chromium.connect_over_cdp(browser_url)
        context = await browser.new_context()

        # Optionally, set user agent or other headers if needed
        # context = await browser.new_context(user_agent="Your User Agent")

        page = await context.new_page()
        print("Connected.")

        try:
            # Navigate to the URL
            await page.goto(url, timeout=120000)
            print("Navigated to initial page.")

            # Wait for the main content selector to ensure the page is fully loaded
            await page.wait_for_selector(metadata["main_content_selector"], timeout=120000)
            print("Main content loaded.")

            # Optionally handle any pop-ups or modals
            # await handle_popups(page)

        except PlaywrightTimeoutError:
            print(f"Timeout while navigating to {url}")
            await browser.close()
            return
        except Exception as e:
            print(f"Error navigating to {url}: {e}")
            await browser.close()
            return

        search_page = await search(metadata, page, search_text)

        if url == AMAZON:
            func = get_amazon_product
        else:
            raise Exception('Invalid URL')

        results = await get_products(search_page, search_text, metadata["product_selector"], func)
        print("Posting results.")
        post_results(results, response_route, search_text, url)
        await browser.close()
        print("Browser closed.")

async def handle_popups(page):
    # Example: Close location confirmation modal if it appears
    try:
        await page.click('button#GLUXConfirmClose')  # Selector for the close button
        print("Closed location confirmation modal.")
    except:
        # If the modal doesn't appear, continue
        pass

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python scraper.py <url> <search_text> <response_route>")
        sys.exit(1)
    url = sys.argv[1]
    search_text = sys.argv[2]
    response_route = sys.argv[3]

    asyncio.run(main(url, search_text, response_route))
