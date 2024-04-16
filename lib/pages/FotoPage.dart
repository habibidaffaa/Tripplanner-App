import 'package:flutter/material.dart';

class FotoPage extends StatelessWidget {
  const FotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'poppins_bold',
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Color(0xFFC58940),
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/Logo_camera.png',
              width: 32,
              height: 32,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            // Saat tombol ditekan, gunakan warna yang berbeda
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.grey[
                                  100]; // Misalnya, gunakan warna yang lebih gelap saat ditekan
                            }
                            // Default: gunakan warna utama
                            return Colors.grey;
                          },
                        ),
                      ),
                      child: Text(
                        'Belly',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/images/Rectangle5.png',
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/images/Rectangle5.png',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      // body: GridView.builder(

      //   padding: const EdgeInsets.all(8),
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 3,
      //     crossAxisSpacing: 8,
      //     mainAxisSpacing: 8,
      //   ),
      //   itemCount: 6, // Ganti dengan jumlah foto yang ingin ditampilkan
      //   itemBuilder: (context, index) {
      //     return Container(
      //       margin: const EdgeInsets.only(top: 30),
      //       child: Image.asset(
      //         'assets/images  /Rectangle5.png',
      //         fit: BoxFit.cover,
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
