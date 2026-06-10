// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerina/persist;
import ballerinax/persist.inmemory;

const EMPLOYEE = "employees";
final isolated table<Employee> key(id) employeesTable = table [];

# In-Memory persist client.
public isolated client class Client {
    *persist:AbstractPersistClient;

    private final map<inmemory:InMemoryClient> persistClients;

    public isolated function init() returns persist:Error? {
        final map<inmemory:TableMetadata> metadata = {
            [EMPLOYEE]: {
                keyFields: ["id"],
                query: queryEmployees,
                queryOne: queryOneEmployees
            }
        };
        self.persistClients = {[EMPLOYEE]: check new (metadata.get(EMPLOYEE).cloneReadOnly())};
    }

    # Get rows from Employee table.

    #

    # + targetType - Defines which fields to retrieve from the results

    # + return - A collection of matching records or an error
    isolated resource function get employees(EmployeeTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    # Get row from Employee table.

    #

    # + id - The value of the primary key field id

    # + targetType - Defines which fields to retrieve from the result

    # + return - The matching record or an error
    isolated resource function get employees/[string id](EmployeeTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    # Insert rows into Employee table.

    #

    # + data - A list of records to be inserted

    # + return - The primary key value(s) of the inserted rows or an error
    isolated resource function post employees(EmployeeInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach EmployeeInsert value in data {
            lock {
                if employeesTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("Employee", value.id);
                }
                employeesTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    # Update row in Employee table.

    #

    # + id - The value of the primary key field id

    # + value - The record containing updated field values

    # + return - The updated record or an error
    isolated resource function put employees/[string id](EmployeeUpdate value) returns Employee|persist:Error {
        lock {
            if !employeesTable.hasKey(id) {
                return persist:getNotFoundError("Employee", id);
            }
            Employee employee = employeesTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                employee[k] = v;
            }
            employeesTable.put(employee);
            return employee.clone();
        }
    }

    # Delete row from Employee table.

    #

    # + id - The value of the primary key field id

    # + return - The deleted record or an error
    isolated resource function delete employees/[string id]() returns Employee|persist:Error {
        lock {
            if !employeesTable.hasKey(id) {
                return persist:getNotFoundError("Employee", id);
            }
            return employeesTable.remove(id).clone();
        }
    }

    # Close the database client and release connections.

    #

    # + return - An error if closing fails
    public isolated function close() returns persist:Error? {
        return ();
    }
}

isolated function queryEmployees(string[] fields) returns stream<record {}, persist:Error?> {
    table<Employee> key(id) employeesClonedTable;
    lock {
        employeesClonedTable = employeesTable.clone();
    }
    return from record {} 'object in employeesClonedTable
        select persist:filterRecord({
                                        ...'object
                                    }, fields);
}

isolated function queryOneEmployees(anydata key) returns record {}|persist:NotFoundError {
    table<Employee> key(id) employeesClonedTable;
    lock {
        employeesClonedTable = employeesTable.clone();
    }
    from record {} 'object in employeesClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("Employee", key);
}

