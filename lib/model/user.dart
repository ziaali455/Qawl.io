class QawlUser {
  final String imagePath;
  final String id;
  final String name;
  final String email;
  final String about;
  final String country;
  int followers = 0;

  QawlUser({
    required this.imagePath,
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.country,
    required this.followers,
  });

  //MUSA: See line 26 of profile_picture_widget. I just ran one method to build every PFP in the app 
  //as the pfp of the Firebase user, but obviously I will change that later. It was just for 
  //the sake of practicing changin ur personal pfp and then seeing it
  //MUSA: Create a method that returns the imagePath property of a user given the Firebase UID of the user. 
  //First find the QawlUser with the uID get request, and then return this person's imagePath
  static getPfp(String uid){

  }
  //MUSA: Create a method that edits the imagePath property of a user given the Firebase UID of the user and path. 
  //First find the QawlUser with the uID get request, and then update this person's imagePath
  static postPfp(String uid){

  }
}
