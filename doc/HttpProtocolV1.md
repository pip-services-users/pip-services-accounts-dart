# HTTP REST Protocol (version 1) <br/> User Accounts Microservice

User accounts microservice implements a REST compatible API, that can be accessed on configured port.
All input and output data is serialized in JSON format. Errors are returned in [standard format]().

* [AccountV1 class](#class1)
* [DataPage<AccountV1> class](#class2)
* [POST /accounts/get_accounts](#operation1)
* [POST /accounts/get_account_by_id](#operation2)
* [POST /accounts/get_account_by_login](#operation3)
* [POST /accounts/get_account_by_id_or_login](#operation4)
* [POST /accounts/create_account](#operation5)
* [POST /accounts/update_account](#operation6)
* [POST /accounts/delete_account_by_id](#operation7)

## Data types

### <a name="class1"></a> AccountV1 class

Represents a account account with his ID, name, email, password and key settings.
It also tracks signup/signin dates. 

**Properties:**
- id: string - unique account id
- name: string - full account name (first and last name)
- login: string - user login or primary email if controller is configured so
- created_time: Date - date and time when account account was created
- active: boolean - true if account account is active, and false for disabled accounts
- time_zone: int - account selected time_zone
- language: string - account selected language (and culture)
- theme: string - account selected application color theme
- custom_hdr: Object - custom data summary that is always returned (in list and details)
- custom_dat: Object - custom data details that is returned only when a single object is returned (details)

### <a name="class2"></a> DataPage<AccountV1> class

Represents a paged result with subset of requested Account objects

**Properties:**
- data: [AccountV1] - array of retrieved Account page
- count: int - total number of objects in retrieved resultset

## Operations

### <a name="operation1"></a> Method: 'POST', route '/accounts/get_accounts'

Retrieves a list of accounts by specified criteria

**Request body:**
- filter: object - filter parameters
  - search: string - (optional) search substring to find in source, type or message
  - id: string - (optional) account id
  - login: string - (optional) user login
  - name: stromg - (optional) user name
  - from\_create\_time: Date - (optional) start of the time range
  - to\_create\_time: Date - (optional) end of the time range
- paging: object - paging parameters
  - skip: int - (optional) start of page (default: 0)
  - take: int - (optional) page length (default: 100)
  - total: boolean - (optional) include total counter into paged result (default: false)

**Response body:**
DataPage<AccountV1> object or error

### <a name="operation2"></a> Method: 'POST', route '/accounts/get\_account\_by_id'

Gets an account by its unique id

**Request body:**
- account_id: string - (optional) unique account id

**Response body:**
AccountV1 account or null if account wasn't found or error

### <a name="operation3"></a> Method: 'POST', route '/accounts/get\_account\_by_login'

Gets an account by user login

**Request boty:**
- login: string - user login

**Response body:**
AccountV1 account or null if account wasn't found or error

### <a name="operation4"></a> Method: 'POST', route '/accounts/get\_account\_by_login'

Gets an account by account id or user login

**Request boty:**
- idOrLogin: string - account id or user login

**Response body:**
AccountV1 account or null if account wasn't found or error

### <a name="operation5"></a> Method: 'POST', route '/accounts/create_account'

Registers a new account in the system and creates an account for him.

**Request body:**
- account: AccountV1 - user account object

**Response body:**
Created AccountV1 object or error

### <a name="operation6"></a> Method: 'POST', route '/accounts/update_account'

Changes name, login or other account settings.

**Request body:**
- account: AccountV1 - user account object

**Response body:**
Updated AccountV1 object or error

### <a name="operation7"></a> Method: 'POST', route '/accounts/delete\_account\_by_id'

Deletes account account from the system (use it carefully!)

**Parameters:** 
- account_id: string - unique account id

**Response body:**
Deleted AccountV1 object or error
