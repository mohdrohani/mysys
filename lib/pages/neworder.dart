import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:mysys/models/main_menu.dart';
import 'package:mysys/data/myappsettings.dart';

final List<Color> colors=myColors;
class Neworder extends StatelessWidget {
  const Neworder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[selectedPageGlobalGetter],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          //AppLocalizations.of(context)!.newOrder+"S:${Localizations.localeOf(context).toString()}C:${Localizations.localeOf(context).countryCode}L:${Localizations.localeOf(context).languageCode}",
          AppLocalizations.of(context)!.newOrder,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () 
            {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(        
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.qr_code, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "قراءة باركود المنتج",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF3C3C3C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A4A4A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("العميل",
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.white),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "العميل",
                                        style: TextStyle(
                                            color: Colors.white70, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A4A4A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("البائع",
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.white),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "2 - المندوب رقم 1",
                                        style: TextStyle(
                                            color: Colors.white70, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                     const Row(
                      children:[
                        Expanded(
                          child: Text("0.00 رس", style: TextStyle(color: Colors.white)),
                        ),
                        Expanded(
                          child: Text("الخصم : إضافة خصم",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.lightBlueAccent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children:[
                        Expanded(
                          child: Text("0.00 رس", style: TextStyle(color: Colors.white)),
                        ),
                        Expanded(
                          child: Text("الإجمالي:",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.lightGreenAccent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "الدفع",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "الملاحظة",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
