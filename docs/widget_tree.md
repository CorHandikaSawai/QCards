MaterialApp
│
├── ChangeNotifierProvider (UserPreference)
│
├── ChangeNotifierProvider (AuthenticationService)
│
├── Consumer<AuthenticationService>
│ └── if (user == null) → LoginScreen
│ └── if (user != null) → HomeScreen
│
├── LoginScreen
│ └── Form
│ ├── TextFormField (Email)
│ ├── TextFormField (Password)
│ ├── ElevatedButton (Login)
│ └── TextButton (Go to RegisterScreen)
│
├── RegisterUserScreen
│ └── Form
│ ├── TextFormField (First Name)
│ ├── TextFormField (Last Name)
│ ├── TextFormField (Email)
│ ├── TextFormField (Password)
│ ├── TextFormField (Confirm Password)
│ └── ElevatedButton (Register)
│
├── HomeScreen (not shown yet, assumed)
│ └── ListView of Subject Cards
│ └── onTap → StudyScreen(subjectName, userId)
│
├── StudyScreen
│ ├── AppBar (subjectName)
│ ├── Text (progress indicator: 1/10)
│ ├── FlippableCardWidget (FlipCard)
│ └── Arrow Buttons to switch cards
│
├── FlippableCardWidget
│ └── FlipCard
│ ├── front → Question text
│ └── back → Answer text
│
├── CardFormWidget (used when editing/creating)
│ └── TextFormField (Question)
│ └── TextFormField (Answer)
