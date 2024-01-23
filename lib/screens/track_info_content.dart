import 'dart:collection';

import 'package:first_project/screens/profile_content.dart';
import 'package:first_project/screens/upload_options_content.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/track.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// DropdownMenuEntry labels and values for the first dropdown menu.

class TrackInfoContent extends StatefulWidget {
  final String trackPath;

  TrackInfoContent({Key? key, required this.trackPath}) : super(key: key);

  @override
  State<TrackInfoContent> createState() => _TrackInfoContentState(trackPath);
}

class _TrackInfoContentState extends State<TrackInfoContent> {
  String trackPath = "";

  _TrackInfoContentState(String path) {
    trackPath = path;
  }

  String? selectedSurah;
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      overlayColor: Colors.green,
      isCloseButton: false,
      isButtonVisible: false,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.green,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.green,
      ),
      
    );
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Existing code...
              Padding(
                padding: EdgeInsets.only(bottom: 200.0),
                child: Text(
                  "Recitation Info",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
              ),
              QawlSubtitleText(title: "Surah Name"),
              // Dropdown for Surah selection
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: DropdownButton<SurahLabel>(
                  value: null, // Set the initial selected value if needed
                  hint: selectedSurah != null
                      ? Text(selectedSurah!)
                      : Text('Select a Surah'),
                  onChanged: (SurahLabel? newValue) {
                    setState(() {
                      selectedSurah = newValue?.label;
                    });
                    print('Selected Surah: $selectedSurah');
                  },
                  items: SurahLabel.values.map((SurahLabel surahLabel) {
                    return DropdownMenuItem<SurahLabel>(
                      value: surahLabel,
                      child: Text(surahLabel.label),
                    );
                  }).toList(),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 13, 161, 99),
                              Color.fromARGB(255, 22, 181, 93),
                              Color.fromARGB(255, 32, 220, 85),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size(250, 70),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        textStyle: const TextStyle(fontSize: 50),
                      ),
                      onPressed: () async {
                        debugPrint(
                            "you should post the track and send us back to the profile page");
                        Navigator.pop(
                          context
                        );
                        Navigator.pop(
                          context
                        );
                        Navigator.pop(
                          context
                        );
                        Alert( image: Icon(Icons.check, size: 100.0,), style: alertStyle, context: context, title: "Posted! ").show();
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QawlSubtitleText extends StatelessWidget {
  String title = "";
  QawlSubtitleText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }
}

extension SurahLabelExtension on SurahLabel {
  String get label {
    switch (this) {
      case SurahLabel.none:
        return 'None';
      case SurahLabel.alFatiha:
        return 'Al-Fatiha (The Opening)';
      case SurahLabel.alBaqarah:
        return 'Al-Baqarah (The Cow)';
      case SurahLabel.alImran:
        return 'Aal-E-Imran (The Family of Imran)';
      case SurahLabel.anNisa:
        return 'An-Nisa\' (The Women)';
      case SurahLabel.alMaidah:
        return 'Al-Maidah (The Table Spread)';
      case SurahLabel.alAnam:
        return 'Al-Anam (The Cattle)';
      case SurahLabel.alAraf:
        return 'Al-Araf (The Heights)';
      case SurahLabel.alAnfal:
        return 'Al-Anfal (The Spoils of War)';
      case SurahLabel.atTawbah:
        return 'At-Tawbah (The Repentance)';
      case SurahLabel.yunus:
        return 'Yunus (Jonah)';
      case SurahLabel.hud:
        return 'Hud (Hud)';
      case SurahLabel.yusuf:
        return 'Yusuf (Joseph)';
      case SurahLabel.arRad:
        return 'Ar-Ra\'d (The Thunder)';
      case SurahLabel.ibrahim:
        return 'Ibrahim (Abraham)';
      case SurahLabel.alHijr:
        return 'Al-Hijr (The Rocky Tract)';
      case SurahLabel.anNahl:
        return 'An-Nahl (The Bee)';
      case SurahLabel.alIsra:
        return 'Al-Isra (The Night Journey)';
      case SurahLabel.alKahf:
        return 'Al-Kahf (The Cave)';
      case SurahLabel.maryam:
        return 'Maryam (Mary)';
      case SurahLabel.taHa:
        return 'Ta-Ha (Ta-Ha)';
      case SurahLabel.alAnbiya:
        return 'Al-Anbiya (The Prophets)';
      case SurahLabel.alHajj:
        return 'Al-Hajj (The Pilgrimage)';
      case SurahLabel.alMuminun:
        return 'Al-Mu\'minun (The Believers)';
      case SurahLabel.anNur:
        return 'An-Nur (The Light)';
      case SurahLabel.alFurqan:
        return 'Al-Furqan (The Criterion)';
      case SurahLabel.ashShuara:
        return 'Ash-Shu\'ara (The Poets)';
      case SurahLabel.anNaml:
        return 'An-Naml (The Ant)';
      case SurahLabel.alQasas:
        return 'Al-Qasas (The Stories)';
      case SurahLabel.alAnkabut:
        return 'Al-Ankabut (The Spider)';
      case SurahLabel.arRum:
        return 'Ar-Rum (The Romans)';
      case SurahLabel.luqman:
        return 'Luqman (Luqman)';
      case SurahLabel.asSajda:
        return 'As-Sajda (The Prostration)';
      case SurahLabel.alAhzab:
        return 'Al-Ahzab (The Combined Forces)';
      case SurahLabel.saba:
        return 'Saba\' (Sheba)';
      case SurahLabel.fatir:
        return 'Fatir (The Originator)';
      case SurahLabel.yaSin:
        return 'Ya-Sin (Ya-Sin)';
      case SurahLabel.asSaffat:
        return 'As-Saffat (Those who set the Ranks)';
      case SurahLabel.sad:
        return 'Sad (The Letter Sad)';
      case SurahLabel.azZumar:
        return 'Az-Zumar (The Troops)';
      case SurahLabel.ghafir:
        return 'Ghafir (The Forgiver)';
      case SurahLabel.fussilat:
        return 'Fussilat (Explained in Detail)';
      case SurahLabel.ashShura:
        return 'Ash-Shura (The Consultation)';
      case SurahLabel.azZukhruf:
        return 'Az-Zukhruf (The Gold Adornments)';
      case SurahLabel.adDukhan:
        return 'Ad-Dukhan (The Smoke)';
      case SurahLabel.alJathiya:
        return 'Al-Jathiya (The Crouching)';
      case SurahLabel.alAhqaf:
        return 'Al-Ahqaf (The Wind-Curved Sandhills)';
      case SurahLabel.muhammad:
        return 'Muhammad (Muhammad)';
      case SurahLabel.alFath:
        return 'Al-Fath (The Victory)';
      case SurahLabel.alHujurat:
        return 'Al-Hujurat (The Rooms)';
      case SurahLabel.qaf:
        return 'Qaf (The Letter Qaf)';
      case SurahLabel.adhDhariyat:
        return 'Adh-Dhariyat (The Winnowing Winds)';
      case SurahLabel.atTur:
        return 'At-Tur (The Mount)';
      case SurahLabel.anNajm:
        return 'An-Najm (The Star)';
      case SurahLabel.alQamar:
        return 'Al-Qamar (The Moon)';
      case SurahLabel.arRahman:
        return 'Ar-Rahman (The Beneficent)';
      case SurahLabel.alWaqia:
        return 'Al-Waqi\'a (The Inevitable)';
      case SurahLabel.alHadid:
        return 'Al-Hadid (The Iron)';
      case SurahLabel.alMujadila:
        return 'Al-Mujadila (The Pleading Woman)';
      case SurahLabel.alHashr:
        return 'Al-Hashr (The Exile)';
      case SurahLabel.alMumtahina:
        return 'Al-Mumtahina (The Woman to be examined)';
      case SurahLabel.asSaff:
        return 'As-Saff (The Ranks)';
      case SurahLabel.alJumua:
        return 'Al-Jumu\'a (The Congregation)';
      case SurahLabel.alMunafiqun:
        return 'Al-Munafiqun (The Hypocrites)';
      case SurahLabel.atTaghabun:
        return 'At-Taghabun (The Mutual Disillusion)';
      case SurahLabel.atTalaq:
        return 'At-Talaq (The Divorce)';
      case SurahLabel.atTahrim:
        return 'At-Tahrim (The Prohibition)';
      case SurahLabel.alMulk:
        return 'Al-Mulk (The Sovereignty)';
      case SurahLabel.alQalam:
        return 'Al-Qalam (The Pen)';
      case SurahLabel.alHaaqqa:
        return 'Al-Haaqqa (The Reality)';
      case SurahLabel.alMaarij:
        return 'Al-Ma\'arij (The Ascending Stairways)';
      case SurahLabel.nuh:
        return 'Nuh (Noah)';
      case SurahLabel.alJinn:
        return 'Al-Jinn (The Jinn)';
      case SurahLabel.alMuzzammil:
        return 'Al-Muzzammil (The Enshrouded One)';
      case SurahLabel.alMuddathir:
        return 'Al-Muddathir (The Cloaked One)';
      case SurahLabel.alQiyama:
        return 'Al-Qiyama (The Resurrection)';
      case SurahLabel.alInsan:
        return 'Al-Insan (Man)';
      case SurahLabel.alMursalat:
        return 'Al-Mursalat (The Emissaries)';
      case SurahLabel.anNaba:
        return 'An-Naba\' (The Tidings)';
      case SurahLabel.anNaziat:
        return 'An-Naziat (Those who drag forth)';
      case SurahLabel.abasa:
        return 'Abasa (He frowned)';
      case SurahLabel.atTakwir:
        return 'At-Takwir (The Overthrowing)';
      case SurahLabel.alInfitar:
        return 'Al-Infitar (The Cleaving)';
      case SurahLabel.alMutaffifin:
        return 'Al-Mutaffifin (Defrauding)';
      case SurahLabel.alInshiqaq:
        return 'Al-Inshiqaq (The Splitting Open)';
      case SurahLabel.alBuruj:
        return 'Al-Buruj (The Mansions of the Stars)';
      case SurahLabel.atTariq:
        return 'At-Tariq (The Morning Star)';
      case SurahLabel.alAla:
        return 'Al-Ala (The Most High)';
      case SurahLabel.alGhashiya:
        return 'Al-Ghashiyah (The Overwhelming)';
      case SurahLabel.alFajr:
        return 'Al-Fajr (The Dawn)';
      case SurahLabel.alBalad:
        return 'Al-Balad (The City)';
      case SurahLabel.ashShams:
        return 'Ash-Shams (The Sun)';
      case SurahLabel.alLayl:
        return 'Al-Layl (The Night)';
      case SurahLabel.adhDhuha:
        return 'Adh-Dhuha (The Morning Hours)';
      case SurahLabel.ashSharh:
        return 'Ash-Sharh (The Relief)';
      case SurahLabel.atTeen:
        return 'At-Tin (The Fig)';
      case SurahLabel.alAlaq:
        return 'Al-Alaq (The Clot)';
      case SurahLabel.alQadr:
        return 'Al-Qadr (The Power)';
      case SurahLabel.alBayyina:
        return 'Al-Bayyina (The Clear Proof)';
      case SurahLabel.azZalzala:
        return 'Az-Zalzala (The Earthquake)';
      case SurahLabel.alAdiyat:
        return 'Al-Adiyat (The Courser)';
      case SurahLabel.alQaria:
        return 'Al-Qaria (The Calamity)';
      case SurahLabel.atTakathur:
        return 'At-Takathur (The Rivalry in World Increase)';
      case SurahLabel.alAsr:
        return 'Al-Asr (The Declining Day)';
      case SurahLabel.alHumaza:
        return 'Al-Humaza (The Traducer)';
      case SurahLabel.alFil:
        return 'Al-Fil (The Elephant)';
      case SurahLabel.quraish:
        return 'Quraish (Quraish)';
      case SurahLabel.alMaun:
        return 'Al-Ma\'un (Acts of Kindness)';
      case SurahLabel.alKawthar:
        return 'Al-Kawthar (The Abundance)';
      case SurahLabel.alKafirun:
        return 'Al-Kafirun (The Disbelievers)';
      case SurahLabel.anNasr:
        return 'An-Nasr (The Help)';
      case SurahLabel.alMasad:
        return 'Al-Masad (The Palm Fiber)';
      case SurahLabel.alIkhlas:
        return 'Al-Ikhlas (The Sincerity)';
      case SurahLabel.alFalaq:
        return 'Al-Falaq (The Daybreak)';
      case SurahLabel.anNas:
        return 'An-Nas (Mankind)';
    }
  }
}

enum SurahLabel {
  none,
  alFatiha,
  alBaqarah,
  alImran,
  anNisa,
  alMaidah,
  alAnam,
  alAraf,
  alAnfal,
  atTawbah,
  yunus,
  hud,
  yusuf,
  arRad,
  ibrahim,
  alHijr,
  anNahl,
  alIsra,
  alKahf,
  maryam,
  taHa,
  alAnbiya,
  alHajj,
  alMuminun,
  anNur,
  alFurqan,
  ashShuara,
  anNaml,
  alQasas,
  alAnkabut,
  arRum,
  luqman,
  asSajda,
  alAhzab,
  saba,
  fatir,
  yaSin,
  asSaffat,
  sad,
  azZumar,
  ghafir,
  fussilat,
  ashShura,
  azZukhruf,
  adDukhan,
  alJathiya,
  alAhqaf,
  muhammad,
  alFath,
  alHujurat,
  qaf,
  adhDhariyat,
  atTur,
  anNajm,
  alQamar,
  arRahman,
  alWaqia,
  alHadid,
  alMujadila,
  alHashr,
  alMumtahina,
  asSaff,
  alJumua,
  alMunafiqun,
  atTaghabun,
  atTalaq,
  atTahrim,
  alMulk,
  alQalam,
  alHaaqqa,
  alMaarij,
  nuh,
  alJinn,
  alMuzzammil,
  alMuddathir,
  alQiyama,
  alInsan,
  alMursalat,
  anNaba,
  anNaziat,
  abasa,
  atTakwir,
  alInfitar,
  alMutaffifin,
  alInshiqaq,
  alBuruj,
  atTariq,
  alAla,
  alGhashiya,
  alFajr,
  alBalad,
  ashShams,
  alLayl,
  adhDhuha,
  ashSharh,
  atTeen,
  alAlaq,
  alQadr,
  alBayyina,
  azZalzala,
  alAdiyat,
  alQaria,
  atTakathur,
  alAsr,
  alHumaza,
  alFil,
  quraish,
  alMaun,
  alKawthar,
  alKafirun,
  anNasr,
  alMasad,
  alIkhlas,
  alFalaq,
  anNas,
}
