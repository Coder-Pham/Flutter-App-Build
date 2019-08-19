# Test Widgets Note

After building **news_api_provider.dart** and model **ItemModel**, we want to check if these functions works properly as we expected.

That's why we need to test each **Provider**. Each test file is a isolate file so it requires a **main()** function.

## Import package

Beside **Provider** class must be imported, we also need:
- **dart:convert**, we're working with JSON-type so this is a must.
- **package:flutter_test**, is built on top of **test.dart**, is the important package.
- **package:http**, we need *http.dart* and *testing.dart*.

## Mocking HTTP Requests

For each **main()** function we can setup test cases, and each test case must be created as **test()** function Object.

Now we just know 2 parameters:
- **description**: name of test case
- **body Function**: how and what will be tested (Function Object).

Next thing, we don't want to test on live server because it takes time to do a lot of HTTP requests, so we create **MockClient** from **http/testing.dart**. Actually, there are a lot of issue happen when test with live server.

**MockClient()** is a implementation of **Client()**, so then we assign our **NewsApiProvider().client** as **MockClient()** and add return value from **MockClient()**.
- **MockClient** takes *Request* and returns *Response* -> async/await function
- Return type is wrapped by **Response** class.

## Check return value/type

Our **client** in API Provider is linked with **MockClient** so whenever API Provider takes new HTTP Request, it'll link to **MockClient**.

Even no matter what parameter pass to function, it only takes request to **MockClient()**.

Check value/result from what we get.

# SUMMARY

Steps to make API Provider test:
- Import enough and correct packages (*flutter_test*, *provider_itself*, etc...)
- Each test case is defined by **test()** method
    - *Function* body <=> () {}: Create direct function. If function relates with downloading or time-consuming work, this is should be **Async Algorithm**.
    - **Response** class: return type bắt buộc của Mock Client.
- Sử dụng hàm cần kiểm tra trong test.
    - Sử dụng *client* từ trong chính Provider đang kiểm tra.
