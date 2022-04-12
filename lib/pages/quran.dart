import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monggo_sholat/core/viewmodel/base_viewmodel.dart';
import 'package:monggo_sholat/core/viewmodel/home_viewmodel.dart';
import 'package:monggo_sholat/pages/base_view.dart';
import 'package:monggo_sholat/pages/menu.dart';
import 'package:monggo_sholat/pages/read_surah.dart';
import 'package:monggo_sholat/services/api.dart';

class Quran extends StatefulWidget {
  Quran({Key? key}) : super(key: key);

  @override
  _QuranState createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  List? quranList;
  List? barang;
  bool playPause = false;

  List<bool> playpause = [];

  Future getListQuran() async {
    Response response = await Dio().get('${BaseUrl.listQuran}');
    setState(() {
      quranList = response.data;
    });
    debugPrint('cek: ${quranList.toString()}');
  }

  Future getBarang() async {
    Response response = await Dio().get('${BaseUrl.barang}');
    setState(() {
      barang = response.data;
    });
    debugPrint('barang = ${barang.toString()}');
  }

  @override
  void initState() {
    super.initState();
    getListQuran();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    final assetsAudioPlayer = AssetsAudioPlayer();

    void togglePlayPause(x, i) {
      setState(() {
        playpause[i] = !playpause[i];
      });
      setState(() {
        try {
          playpause[i]
              ? assetsAudioPlayer.open(Audio.liveStream('$x'))
              : assetsAudioPlayer.stop();
        } catch (e) {}
      });
    }

    return BaseView<HomeViewModel>(
      onModelReady: (data) {
        data.getSurah(context);
        playpause = List.generate(144, (_) => false);
      },
      builder: (context, data, child) => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          centerTitle: true,
          title: Row(
            children: [
              Center(
                child: Text(
                  "Al - Qur'an",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          leading: InkWell(
            child: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MenuHome()));
            },
          ),
        ),
        body: data.surah == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: ListView.builder(
                    itemCount: data.surah!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final x = data.surah![index];
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              trailing: Text(
                                '${x.nama}',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              leading: Text('${x.nomor}'),
                              title: Text('Surah : ${x.namaLatin}'),
                              subtitle: Text('Jumlah Ayat : ${x.jumlahAyat}'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReadSurah(
                                              surah: [x],
                                              index: index,
                                            )));
                              },
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Putar Murrotal'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: playpause[index]
                                        ? Icon(
                                            Icons.stop_circle_outlined,
                                            color: Colors.pink,
                                          )
                                        : Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.pink,
                                          ),
                                    onTap: () async {
                                      togglePlayPause(x.audio, index);
                                    },
                                  )
                                ]),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
      ),
    );
    //  Scaffold(
    //   backgroundColor: Colors.grey[100],
    //   appBar: AppBar(
    //     backgroundColor: Colors.green.shade800,
    //     centerTitle: true,
    //     title: Row(
    //       children: [
    //         Center(
    //           child: Text(
    //             "Al - Qur'an",
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ],
    //     ),
    //     leading: InkWell(
    //       child: Icon(
    //         Icons.keyboard_backspace,
    //         color: Colors.white,
    //       ),
    //       onTap: () {
    //         Navigator.push(
    //             context, MaterialPageRoute(builder: (context) => MenuHome()));
    //       },
    //     ),
    //   ),
    //   body: quranList == null
    //       ? Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : Padding(
    //           padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
    //           child: ListView.builder(
    //               itemCount: quranList!.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 final x = quranList![index];
    //                 return Card(
    //                   child: Column(
    //                     children: [
    //                       ListTile(
    //                         trailing: Text(
    //                           '${x['nama']}',
    //                           style: GoogleFonts.nunitoSans(
    //                               fontSize: 16, fontWeight: FontWeight.bold),
    //                         ),
    //                         leading: Text('${x['nomor']}'),
    //                         title: Text('Surah : ${x['nama_latin']}'),
    //                         subtitle: Text('Jumlah Ayat : ${x['jumlah_ayat']}'),
    //                         onTap: () {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => ReadSurah(
    //                                         surah: [x],
    //                                         index: index,
    //                                       )));
    //                         },
    //                       ),
    //                       Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text('Putar Murrotal'),
    //                             SizedBox(
    //                               width: 10,
    //                             ),
    //                             GestureDetector(
    //                               child: playPause
    //                                   ? Icon(
    //                                       Icons.stop_circle_outlined,
    //                                       color: Colors.pink,
    //                                     )
    //                                   : Icon(
    //                                       Icons.play_circle_outline,
    //                                       color: Colors.pink,
    //                                     ),
    //                               onTap: () async {
    //                                 togglePlayPause(x);
    //                               },
    //                             )
    //                           ]),
    //                       SizedBox(
    //                         height: 5,
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               }),
    //         ),
    // );
  }
}
