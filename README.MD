Barbara Boeters
Student number: 10774513
Minor Programming at University of Amsterdam
Native App Studio: final assignment

With the 'Recipes' app you can search for recipes by (multiple) ingredients and add items on the list of groceries with different users whom are for example your housemates or your family. After you log in with your emailadres you will go to the next page where you can search for recipes. It will show you an amount of recipes if available with the title and a small image. When tapping one of the recipes it will show you a webview where you can see read the ingredients. Back to the searchpage you can go to your groceries list by tapping 'Groceries'. On this page you can add items which will show immediately in the tableview below. It also shows the user who added the item. You can tick items off and it will sort itself. You are also able to delete the items.

The Food2Fork API is used to retrieve the data. Important to know is that this API tends to go offline every now and then. As a database the app uses Firebase which stores the users and the groceries list. Use of State Restoration at the two textfields (email and searchbar). Only small user data (last logged in user) is persisted on the phone using Userdefaults.

NOTE: when using multiple ingredients please add a comma inbetween.

Used Tutorials: 
- https://www.raywenderlich.com/117471/state-restoration-tutorial
- https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
