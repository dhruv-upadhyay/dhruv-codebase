import UIKit

/**
# iOS Architecture Patterns : #

 Nowadays we have many options when it comes to architecture design patterns:
1. MVC
2. MVP
3. MVVM
4. VIPER
 
First three of them assume putting the entities of the app into one of 3 categories:
 
 - **Models:** responsible for the domain data or a data access layer which manipulates the data, think of *Person* or *PersonDataProvider* classes.
 - **Views:** responsible for the presentation layer (GUI), for iOS environment think of everything starting with ‘UI’ prefix.
 - **Controller/Presenter/ViewModel:** the glue or the mediator between the Model and the View, in general responsible for altering the Model by reacting to the user’s actions performed on the View and updating the View with changes from the Model.
 
#Having entities divided allows us to
  - Understand them better (as we already know)
 - Reuse them (mostly applicable to the View and the Model)
 - Test them independently
 
#1. MVC (Model and View + Controller)
 
#Apple’s MVC
 
 #Expectation: 
 - The **Controller** is a mediator between the **View** and the **Model** so that they don’t know about each other. The least reusable is the **Controller** and this is usually fine for us, since we must have a place for all that tricky business logic that doesn’t fit into the **Model**.
 
#Reality:
 - Cocoa MVC encourages you to write Massive View Controllers, because they are so involved in **View’s** life cycle that it’s hard to say they are separate. Although you still have ability to offload some of the business logic and data transformation to the **Model**, you don’t have much choice when it comes to offloading work to the **View**, at most of times all the responsibility of the **View** is to send actions to the **Controller**. The view controller ends up being a delegate and a data source of everything, and is usually responsible for dispatching and cancelling the network requests.

*/
/** **Model** */
struct Person {
    let firstName: String
    let lastName: String
}

/** **View + Controller** */
class PersonViewController : UIViewController {
    var person: Person!
    let showGreetingButton = UIButton()
    let greetingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showGreetingButton.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
    }
    
    @objc
    func didTapButton(button: UIButton) {
        let greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
        self.greetingLabel.text = greeting
        
    }
    // layout code goes here
}
// Assembling of MVC
let model = Person(firstName: "David", lastName: "Blaine")
let view = PersonViewController()
view.person = model;


/**
 #2. MVVM (Model, View, and ViewModel)
 */

/** **Model** */
struct User {
    var name: String = ""
    var age: Int = 0
}

/** **View** */
class UserVC: UIViewController {
    var viewModel: UserViewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the viewModel safely
        print("Name: \(viewModel.getUser().name)")
        print("Age: \(viewModel.getUser().age) years old")
    }
}

/** **View Model** */
class UserViewModel {
    private var user = User()
    
    init() {
        setUserData()
    }
    
    private func setUserData() {
        user.name = "Dhruv"
        user.age = 32
    }
    
    func getUser() -> User {
        return user
    }
}
