import 'package:first_project/model/track.dart';

class faketrackdata {
  static var defaultTrack = Track(author: "no author", 
  id: "0",
  trackName: "none", 
  plays: 0, 
  surah: "none",
  audioFile: "https://server8.mp3quran.net/ahmad_huth/001.mp3",
  coverImagePath: "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg",
  );

  static var fakeTrack1 = Track(author: "Mahmoud Hussary", 
  id: "1",
  trackName: "Al-Fatihah", 
  plays: 2000000, 
  surah: "fatihah",
  audioFile: "https://server8.mp3quran.net/ahmad_huth/001.mp3",
  coverImagePath: "https://quran.com.kw/en/wp-content/uploads/alhusarey.jpg",
  );
    static var fakeTrack2 = Track(author: "Mohamed Minshawi", 
  id: "2",
  trackName: "Al-Baqarah", 
  plays: 309444, 
  surah: "baqarah",
  audioFile: "https://server8.mp3quran.net/ahmad_huth/002.mp3",
  coverImagePath: "https://static.qurancdn.com/images/reciters/7/mohamed-siddiq-el-minshawi-profile.jpeg?v=1",
  );

  static var fakeTrack3 = Track(author: "Abdul Al-Sudais", 
  id: "3",
  trackName: "Al-e-Imran", 
  plays: 654243, 
  surah: "Aali imran",
  audioFile: "https://server8.mp3quran.net/ahmad_huth/003.mp3",
  coverImagePath: "https://upload.wikimedia.org/wikipedia/commons/1/18/Abdul-Rahman_Al-Sudais_%28Cropped%2C_2011%29.jpg?20210429184005",
  );

  static var fakeTrack4 = Track(author: "Noreen Siddig", 
  id: "4",
  trackName: "An-Nisaa", 
  plays: 3543, 
  surah: "Nisaa",
  audioFile: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
  coverImagePath: "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );
  
  static var fakeTrack5 = Track(author: "Noreen Siddig", 
  id: "5",
  trackName: "An-Nisaa", 
  plays: 1234, 
  surah: "Nisaa",
  audioFile: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
  coverImagePath: "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );


}
