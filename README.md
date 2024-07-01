# A simple base Typescript Prettier Eslint Jest Project

You can call the endpoint:

```
curl --location 'http://localhost:7071/api/v1/hello?name=Lorenzo'

curl --location 'http://localhost:7071/api/v1/hello/Lorenzo' \
--header 'Content-Type: application/json' \
--data '{
    "surname":"Franceschini",
    "age": 46
}'
```

### Guides Used

1. https://learn.microsoft.com/it-it/azure/azure-functions/functions-reference-node?tabs=typescript%2Cwindows%2Cazure-cli&pivots=nodejs-model-v4
2. https://github.com/Azure/azure-functions-host/wiki
3. https://blog.logrocket.com/configuring-nodemon-typescript/
