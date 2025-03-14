# OpenAPI_Test

This is a test task project.

Run destination is iOS 15.6+
There will be some minor differences in UI for iOS 15 and 16+ because of the pre iOS 16 setup.

*Installation:*

To run the project on iOS Simulator -> just pull or fork the repo and open in Xcode, press "Play" button.

To run on the device use your dedicated Xcode setup for code signing.

*Dependencies*
No 3rd party dependencies used. Only the frameworks available for developer in Xcode by default.

*Brief overview*

The app has a root view (RootView) and a RootModel which are created at the app stattup.

RootView encloses a TabBarView (custom tab bar implementation)

TabBar view has 2 tabs: 
initially the UsersListView is the view for the first tab.
and the UserSignup View is the view for the second tab.


Each of theese "Content" views are loceted in the "Screens" folder of the project, together with the corresponding viewModels.

The Screen views are lazily initialized and required workers are provided to threir viewModels also lazily from the RootModel.

All the work with creating the API requests is moved to corresponding worker classes.

Screen view's viewModel calls(uses) corresponding dependencies which were provided through the initializer.

`To keep it faster and simpler to develop the screen view models are non-single responsibility objects.`



**Users List:**

 - UsersList view model is responsible for loading the Users data chaunk using paging and maintains the array of the loaded User UI info objects.
   - User profile avatar images are loaded asyncronously using the "singletone" shared ImageCache object and the corresponding List Item cells are updated.
 - Also it has ability to listen to the "New User did signup" ('subscribeForNewUserId(from:)') event and on the next UsersList view appearance starts reloading of the users list from an empty state.
   - The `subscribeForNewUserId(from:)` is called on UsersListViewModel when a SignupViewModel is created and a UserRegistrator object is passes as a dependency to it.

**User Signup:**

 - UserSignup view model is responsible for accepting user text inputs and validating them as well as accepting the selected user's profile image and validating it.
It uses separate text or imageData validators for those checks.

 - Also the SignupViewModel loads the selectable 'UserPosition's to display a selectable radio buttons list

 - Also the SignupViewModel is calling the "Registrator" dependency to register user and displays success or failure screen as a result of that action.

*Possible Improvements:*

make Signup View model's separation of concerns:
 - make the text and image data validators also injectable external dependencies
 - remove the direct Worker (API callers) calls from the viewModels further deeper into the Domain logic structure
 - generalize and broaden the error handlings, make it more precise.



