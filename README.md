# jwt-cookie

We use jwt for user auth, and the server will set token in cookie.  
However, sometimes we don't want to use cookie directly for retrieving data in server,  since the CSRF issue.  
To bypass this attack, we use `Authorizaition` header instead.

## Tools

1. Nodejs
2. Express
3. [jsonwebtoken](https://github.com/auth0/node-jsonwebtoken)
4. cookie-parser

## algo

- jwt: use `HMAC SHA256` (default)
```javascript
let jwt = require('jsonwebtoken')
let token = jwt.sign({ userData: "user-data-here" }, 'key-for-encrypt')
```

1. `HMAC` => Symmetric Encryption, only need one key, which is used for encrypted and decrypted.
2. `SHA256` => A hash method.
```javascript
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret
)
```

## Flow

1. User logs in using their credentials by submitting a login form to the server.
2. Server verifies the credentials and generates an access token for the user.
3. Server sets an `HTTP-only` cookie containing the access token and sends the cookie back to the client in the response.
4. When the client needs to make an API request that requires authentication, it retrieves the access token from the cookie by making a server-side API call to a server endpoint that can read the `access_token` cookie and return its value.
5. The client includes the access token in the Authorization header of the API request.
6. The API endpoint on the server verifies the access token and processes the request.
7. Server sends the requested data back to the client in the response.

## APIs

1. [POST] `/api/login`

body:
```
{
  account: <account-here>,
  password: <pwd-here>
}
```

response:
```
{
  access_token: <token>
}
```

And it will generate coookie named `access_token` with `httpOnly` tag.  
  
2. [GET] `/api/getAccessToken`

You don't need to set header.  Only Cookie with `access_token` is needed.

response:
```
{
  access_token: <token>
}
```

3. [GET] `/api/data`
header:
```
{
  Authorization: "Bearer <token-here>"
}
```

response:
```
{
  user: "<username-here>"
}
```

## Resource

1. [Cookie、Session、Token与JWT解析](https://www.jianshu.com/p/cab856c32222)
2. ChatGPT