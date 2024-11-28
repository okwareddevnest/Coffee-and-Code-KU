import sys
import os
import asyncio

# Ensure the script directory and parent directory are in the Python path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PARENT_DIR = os.path.dirname(BASE_DIR)
sys.path.append(BASE_DIR)
sys.path.append(PARENT_DIR)

from main import main

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print('Usage: python scraper.py <url> <search_text> <endpoint>')
        sys.exit(1)

    url = sys.argv[1]
    search_text = sys.argv[2]
    endpoint = sys.argv[3]

    # Run the scraper asynchronously
    asyncio.run(main(url, search_text, endpoint))
