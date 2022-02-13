Singleton Design Pattern implemented for fetching related records

In this demo we use a trigger on the Contact object (ContactTrigger) and a method that populates the contacts' AccountName__c field with its respective parent account's name

Since it may be possible that other methods in the trigger require the account's fields, they would have to individually remap or requery for the accounts which would unnecessarily use system resouces, count against governor limits and increase execution time.

With the approach offered by this repo, the accounts (or any related records) only get fetched once to be used throughout the entire trigger execution and main logic code is simplified

In short, these are the implementation steps:

1. Create a class to store the collections to be accessed universally
2. Represent the collections as private static properties of this class
3. Add a getter for each collection
4. In each getter method, before all, check if the collection has already been defined. If so, just return it.

These 4 steps succesfully implement Singleton for this purpose, but we must still look out for a peculiarity in the force.com platform:

Since Salesforce DML operations process records in batches of 200, in case your DML operation involves more than 200 records, the accounts from further batches may not be mapped. That's because the collections will already be defined according to the first batch. Therefore, if a contact in this further batch has an account which is not present in the first one, it will not be mapped. So here's a quick workaround:

5. Create a method that resets the collections, by setting them back to null
6. Call this reset method on the very end of your trigger

There it goes! We're done.