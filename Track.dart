import 'dart:io';



class Track {

String author;
String trackName;
int plays;
int duration;
String surah;
int date;
String audioFile;
//final player = AudioPlayer();    


  Track({required this.author, required this.trackName, required this.plays, required this.duration, 
  required this.surah, required this.date, required this.audioFile});

String getAuthor() {
  return author;
}

String getTrackName() {
  return trackName;
}

void increasePlays() {
  plays++;
}

int getPlays() {
  return plays;
}
int getDuration() {
  return duration;
}

String getSurah() {
  return surah;
}

int getDate(){
  return date;
}

String getAudioFile() {
  return audioFile;
}

void play(String audioFile) {
File myFile = File(audioFile);
}



}