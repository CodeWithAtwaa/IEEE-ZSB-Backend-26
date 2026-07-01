# Research Questions

## GET & POST Method
### GET 
- Appends the form data to the URL, in name/value pairs
- NEVER use GET to send sensitive data! (the submitted form data is visible in the URL!)
- The length of a URL is limited (2048 characters)
- Useful for form submissions where a user wants to bookmark the result
- GET is good for non-secure data, like query strings in Google

### POST
- Appends the form data inside the body of the HTTP request (the submitted form data is not shown in the URL)
- POST has no size limitations, and can be used to send large amounts of data.
- Form submissions with POST cannot be bookmarked



## Semantic HTML
- A semantic element clearly describes its meaning to both the browser and the developer



## The Request/Response Cycle
1. User enters google.com
2. Browser asks DNS for the IP
3. DNS returns the IP address
4. Browser sends HTTP request to the server
5. Server processes the request
6. Server sends response (HTML, CSS, JS)
7. Browser renders the webpage






> in this Questions i use W3schools