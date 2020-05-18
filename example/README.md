# Examples for User Accounts Microservice

This is accounts microservice from Pip.Services library. 
It keeps a list of supported accounts that are referenced from other content microservices.

Define configuration parameters that match the configuration of the microservice's external API
```dart
// Service/Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the service
```dart
persistence = AccountsMemoryPersistence();
persistence.configure(ConfigParams());

controller = AccountsController();
controller.configure(ConfigParams());

service = AccountsHttpServiceV1();
service.configure(httpConfig);

var references = References.fromTuples([
    Descriptor('pip-services-accounts', 'persistence', 'memory',
        'default', '1.0'),
    persistence,
    Descriptor('pip-services-accounts', 'controller', 'default',
        'default', '1.0'),
    controller,
    Descriptor(
        'pip-services-accounts', 'service', 'http', 'default', '1.0'),
    service
]);

controller.setReferences(references);
service.setReferences(references);

await persistence.open(null);
await service.open(null);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = AccountsHttpClientV1(config);

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
```

Now the client is ready to perform operations
```dart
// Create a new account
final ACCOUNT = AccountV1(
    id: '1',
    login: 'user1@conceptual.vision',
    name: 'Test User 1',
    deleted: false
);

    // Create the account
    try {
      var account = await client.createAccount('123', ACCOUNT);
      // Do something with the returned account...
    } catch(err) {
      // Error handling...     
    }
```

```dart
// Get the account
try {
var account = await client.getAccountByLogin(
    null,
    'somebody@somewhere.com');
    // Do something with account...

    } catch(err) { // Error handling}
``` 

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services-users/pip-services-accounts-dart/tree/master/test).
