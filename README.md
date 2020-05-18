# <img src="https://github.com/pip-services/pip-services/raw/master/design/Logo.png" alt="Pip.Services Logo" style="max-width:30%"> <br> User Accounts Microservice

This is a user account management microservice from Pip.Services library. 
* Registers users and creates their accounts
* Keeps key user descriptions and settings (about, location, language, theme, ...)

The microservice currently supports the following deployment options:
* Deployment platforms: Standalone Process, Seneca
* External APIs: HTTP/REST, Seneca
* Persistence: In-Memory, Flat Files, MongoDB

This microservice has optional dependencies on the following microservices:
- [pip-services-activities-dart](https://github.com/pip-services-users/pip-services-activities-dart) - to log user activities (signup, signin, change settings)

<a name="links"></a> Quick Links:

* [Download Links](doc/Downloads.md)
* [Development Guide](doc/Development.md)
* [Configuration Guide](doc/Configuration.md)
* [Deployment Guide](doc/Deployment.md)
* Client SDKs
  - [Node.js SDK](https://github.com/pip-services-users/pip-clients-accounts-node)
  - [Dart SDK](https://github.com/pip-services-users/pip-clients-accounts-dart)
* Communication Protocols
  - [HTTP Version 1](doc/HttpProtocolV1.md)

## Contract

Logical contract of the microservice is presented below. For physical implementation (HTTP/REST),
please, refer to documentation of the specific protocol.

```dart
class AccountV1 implements IStringIdentifiable {
  /* Identification */
  String id;
  String login;
  String name;
  
  /* Activity tracking */
  DateTime create_time;
  bool deleted;
  bool active;

  /* User preferences */
  String about;
  String time_zone;
  String language;
  String theme;

  /* Custom fields */
  var custom_hdr;
  var custom_dat;
}

abstract class IAccountsV1 {
  Future<DataPage<AccountV1>> getAccounts(
      String correlationId, FilterParams filter, PagingParams paging);

  Future<AccountV1> getAccountById(String correlationId, String id);

  Future<AccountV1> getAccountByLogin(String correlationId, String login);

  Future<AccountV1> getAccountByIdOrLogin(String correlationId, String idOrLogin);

  Future<AccountV1> createAccount(String correlationId, AccountV1 account);

  Future<AccountV1> updateAccount(String correlationId, AccountV1 account);

  Future<AccountV1> deleteAccountById(String correlationId, String accountId);
}
```

## Download

Right now the only way to get the microservice is to check it out directly from github repository
```bash
git clone git@github.com:pip-services-users/pip-services-accounts-dart.git
```

Pip.Service team is working to implement packaging and make stable releases available for your 
as zip downloadable archieves.

## Run

Add **config.yaml** file to the root of the microservice folder and set configuration parameters.

Example of microservice configuration
```yaml
---
# Container descriptor
- descriptor: "pip-services:context-info:default:default:1.0"
  name: "pip-services-accounts"
  description: "Accounts microservice for pip-services"

# Console logger
- descriptor: "pip-services:logger:console:default:1.0"
  level: "trace"

# Performance counters that posts values to log
- descriptor: "pip-services:counters:log:default:1.0"
  level: "trace"

{{#MEMORY_ENABLED}}
# In-memory persistence. Use only for testing!
- descriptor: "pip-services-accounts:persistence:memory:default:1.0"
{{/MEMORY_ENABLED}}

{{#FILE_ENABLED}}
# File persistence. Use it for testing of for simple standalone deployments
- descriptor: "pip-services-accounts:persistence:file:default:1.0"
  path: {{FILE_PATH}}{{^FILE_PATH}}"./data/accounts.json"{{/FILE_PATH}}
{{/FILE_ENABLED}}

{{#MONGO_ENABLED}}
# MongoDB Persistence
- descriptor: "pip-services-accounts:persistence:mongodb:default:1.0"
  collection: {{MONGO_COLLECTION}}{{^MONGO_COLLECTION}}accounts{{/MONGO_COLLECTION}}
  connection:
    uri: {{{MONGO_SERVICE_URI}}}
    host: {{{MONGO_SERVICE_HOST}}}{{^MONGO_SERVICE_HOST}}localhost{{/MONGO_SERVICE_HOST}}
    port: {{MONGO_SERVICE_PORT}}{{^MONGO_SERVICE_PORT}}27017{{/MONGO_SERVICE_PORT}}
    database: {{MONGO_DB}}{{#^MONGO_DB}}app{{/^MONGO_DB}}
  credential:
    username: {{MONGO_USER}}
    password: {{MONGO_PASS}}
{{/MONGO_ENABLED}}

{{^MEMORY_ENABLED}}{{^FILE_ENABLED}}{{^MONGO_ENABLED}}
# Default in-memory persistence
- descriptor: "pip-services-accounts:persistence:memory:default:1.0"
{{/MONGO_ENABLED}}{{/FILE_ENABLED}}{{/MEMORY_ENABLED}}

# Default controller
- descriptor: "pip-services-accounts:controller:default:default:1.0"

# Common HTTP endpoint
- descriptor: "pip-services:endpoint:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 8080

# HTTP endpoint version 1.0
- descriptor: "pip-services-accounts:service:http:default:1.0"

# Heartbeat service
- descriptor: "pip-services:heartbeat-service:http:default:1.0"

# Status service
- descriptor: "pip-services:status-service:http:default:1.0"
```
 
For more information on the microservice configuration see [Configuration Guide](doc/Configuration.md).

Start the microservice using the command:
```bash
dart ./bin/run.dart
```

## Use

The easiest way to work with the microservice is to use client SDK. 
The complete list of available client SDKs for different languages is listed in the [Quick Links](#links)

If you use dart, then get references to the required libraries:
- Pip.Services3.Commons : https://github.com/pip-services3-dart/pip-services3-commons-dart
- Pip.Services3.Rpc: 
https://github.com/pip-services3-dart/pip-services3-rpc-dart

Add **pip-services3-commons-dart**, **pip-services3-rpc-dart** and **pip-services_accounts** packages
```dart
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import 'package:pip_services_accounts/pip_services_accounts.dart';

```

Define client configuration parameters that match the configuration of the microservice's external API
```dart
// Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
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

## Acknowledgements

This microservice was created and currently maintained by
- **Sergey Seroukhov**.
- **Nuzhnykh Egor**
