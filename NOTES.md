# Random Notes

## Authentication

Unlike the previous versions of the software (DCNM 11.x and earlier), NDFC leverages HTTP cookies for presenting the authentication token/credentials to the API. To generate this token and corresponding cookie, the credentials are posted to a **/login** endpoint in the JSON request body, as opposed to leveraging BasicAuth headers.

If you leverage the Python [requests](https://requests.readthedocs.io/en/latest/), this shift to cookies makes the authentication a bit easier on the programming front. I've historically used the requests.Session class to manage the connections.

So, the authentication process looks like this for DCNM:

```python
# DCNM 11.x Authentication
import requests

host = 'https://dcnm.example.com'
body = { "expirationTime": 30000 }
auth = ( 'user', 'password' )

conn = requests.Session()
response = conn.post(f"{host}/rest/logon", json=body, auth=auth)
result = response.json()

conn.headers.update({'Dcnm-Token': result['Dcnm-Token']})
```

And for NDFC, like this:

```python
# NDFC 12.0 Authentication
import requests

host = 'https://dcnm.example.com'
body = {
        "userName": "user",
        "userPasswd": "password",
        "domain": "local"
       }

conn = requests.Session()
response = conn.post(f"{host}/login", json=body)
result = response.json()
```

Because the **requests.Session** class is really about maintaining state, the cookies generated from HTTP calls are stored in the object. There's no extra step required to process the response (aside from catching errors and such).

## Template APIs

The "List All Templates" endpoint (/appcenter/cisco/ndfc/api/v1/configtemplate/rest/config/templates) has an optional query string that you can pass to the endpoint. The query "key" is **filterStr** and the "value" it takes has the form of another key-value pair. The filterStr key is the attribute within the template and the filterStr value is the search substring.

For example, if I wanted to search for all templates with "vlan" in the name, the query string appended to the API endpoint would be:

```
filterStr=name=vlan
```

Or, more completely:

```
https://{{ndfc_ip_address}}/appcenter/cisco/ndfc/api/v1/configtemplate/rest/config/templates?filterStr=name=vlan
```

