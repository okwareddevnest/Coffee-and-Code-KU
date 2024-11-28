from asyncio import gather

async def get_product(product_div):
    # Query for all elements at once
    image_element_future = product_div.query_selector('img.s-image')
    name_element_future = product_div.query_selector('h2.a-size-mini a.a-link-normal span')
    price_whole_future = product_div.query_selector('span.a-price-whole')
    price_fraction_future = product_div.query_selector('span.a-price-fraction')
    url_element_future = product_div.query_selector('h2.a-size-mini a.a-link-normal')

    # Await all queries at once
    image_element, name_element, price_whole_element, price_fraction_element, url_element = await gather(
        image_element_future,
        name_element_future,
        price_whole_future,
        price_fraction_future,
        url_element_future,
    )

    # Fetch all attributes and text at once
    image_url = await image_element.get_attribute('src') if image_element else None
    product_name = await name_element.inner_text() if name_element else None

    # Combine whole and fractional price parts
    if price_whole_element and price_fraction_element:
        price_string = f"{await price_whole_element.inner_text()}.{await price_fraction_element.inner_text()}"
        try:
            product_price = float(price_string.replace(",", "").strip())
        except:
            product_price = None
    else:
        product_price = None

    product_url = await url_element.get_attribute('href') if url_element else None
    if product_url and not product_url.startswith('http'):
        product_url = f"https://www.amazon.ca{product_url}"

    return {
        "img": image_url,
        "name": product_name,
        "price": product_price,
        "url": product_url
    }
