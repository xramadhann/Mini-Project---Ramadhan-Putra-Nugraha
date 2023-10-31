import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:myspbu/ui/pages/login_page.dart';

class ProfilePageScreen extends StatefulWidget {
  @override
  _ProfilePageScreenState createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  late DatabaseReference _userRef;
  UserData userData = UserData();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController namaPenggunaController = TextEditingController();
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isEditingNamaPengguna = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _userRef =
        FirebaseDatabase.instance.reference().child('User').child('user1');

    _userRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map<dynamic, dynamic>;
        if (data != null) {
          setState(() {
            userData = UserData(
              namaPengguna: data['namaPengguna'] ?? "Data tidak ditemukan",
              emailPengguna: data['emailPengguna'] ?? "Data tidak ditemukan",
              telephonePengguna:
                  data['telephonePengguna'] ?? "Data tidak ditemukan",
              usernamePengguna:
                  data['usernamePengguna'] ?? "Data tidak ditemukan",
            );
            usernameController.text = userData.usernamePengguna;
            emailController.text = userData.emailPengguna;
            phoneController.text = userData.telephonePengguna;
            namaPenggunaController.text = userData.namaPengguna;
          });
        }
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Simpan gambar ke Firebase atau ke lokasi penyimpanan yang Anda inginkan
      // Kemudian perbarui tampilan gambar profil
      final image = File(pickedFile.path);
      // Selanjutnya, Anda bisa mengunggah gambar ke Firebase Storage atau menyimpannya ke lokasi yang sesuai.
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Gambar Profil"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () {
                    _pickImage();
                    Navigator.of(context).pop();
                  },
                ),
                // Anda juga dapat menambahkan opsi lain, seperti mengambil foto baru.
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    namaPenggunaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    _showImageDialog();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(
                'Nama Pengguna',
                userData.namaPengguna,
                isEditingNamaPengguna,
                () {
                  setState(() {
                    isEditingNamaPengguna = !isEditingNamaPengguna;
                  });
                },
                namaPenggunaController,
              ),
              const SizedBox(height: 20),
              buildTextField(
                'Username',
                userData.usernamePengguna,
                isEditingUsername,
                () {
                  setState(() {
                    isEditingUsername = !isEditingUsername;
                  });
                },
                usernameController,
              ),
              const SizedBox(height: 20),
              buildTextField(
                'Email',
                userData.emailPengguna,
                isEditingEmail,
                () {
                  setState(() {
                    isEditingEmail = !isEditingEmail;
                  });
                },
                emailController,
              ),
              const SizedBox(height: 20),
              buildTextField(
                'No Handphone',
                userData.telephonePengguna,
                isEditingPhone,
                () {
                  setState(() {
                    isEditingPhone = !isEditingPhone;
                  });
                },
                phoneController,
              ),
              const SizedBox(height: 20),
              buildSaveButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 60, left: 30),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.orange,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Profile Anda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String value,
    bool enabled,
    Function()? onPressed,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                prefixIcon: const Icon(Icons.person),
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
              enabled: enabled,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          if (onPressed != null)
            IconButton(
              icon: Icon(enabled ? Icons.check : Icons.edit),
              onPressed: () {
                String errorMessage = '';

                if (enabled) {
                  if (label == 'Nama Pengguna') {
                    if (!isNamaPenggunaValid(namaPenggunaController.text)) {
                      errorMessage =
                          'Nama Pengguna harus dimulai dengan huruf kapital dan tidak boleh kosong.';
                    }
                  } else if (label == 'Username') {
                    if (!isUsernameValid(usernameController.text)) {
                      errorMessage = 'Username harus diisi.';
                    }
                  } else if (label == 'Email') {
                    if (!isEmailValid(emailController.text)) {
                      errorMessage =
                          'Email harus diisi dengan format yang benar (@gmail.com).';
                    }
                  } else if (label == 'No Handphone') {
                    if (!isPhoneValid(phoneController.text)) {
                      errorMessage =
                          'No Telephone harus diisi dan berupa angka.';
                    }
                  }

                  if (errorMessage.isEmpty) {
                    // Simpan perubahan ke Firebase di sini

                    // Setelah perubahan berhasil disimpan, nonaktifkan mode pengeditan
                    setState(() {
                      isEditingUsername = false;
                      isEditingEmail = false;
                      isEditingPhone = false;
                      isEditingNamaPengguna = false;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Validasi Gagal'),
                          content: Text(errorMessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Tutup'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Aktifkan mode pengeditan
                  onPressed();
                }
              },
            )
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _userRef.update({
                  'usernamePengguna': usernameController.text,
                  'telephonePengguna': phoneController.text,
                  'emailPengguna': emailController.text,
                  'namaPengguna': namaPenggunaController.text,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil Anda telah diperbarui'),
                  ),
                );
              },
              child: const Text('Simpan Perubahan'),
            ),
          ),
          const SizedBox(
              width:
                  8), // Jarak antara tombol "Simpan Perubahan" dan tombol "Logout"
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    onTabTapped: (int) {},
                  ),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class UserData {
  String namaPengguna;
  String emailPengguna;
  String telephonePengguna;
  String usernamePengguna;

  UserData({
    this.namaPengguna = "Data tidak ditemukan",
    this.emailPengguna = "Data tidak ditemukan",
    this.telephonePengguna = "Data tidak ditemukan",
    this.usernamePengguna = "Data tidak ditemukan",
  });
}

bool isNumeric(String? value) {
  if (value == null) return false;
  return double.tryParse(value) != null;
}

bool isEmailValid(String? value) {
  if (value == null) return false;
  return value.isNotEmpty && value.contains('@gmail.com');
}

bool isUsernameValid(String? value) {
  if (value == null) return false;
  return value.isNotEmpty;
}

bool isPhoneValid(String? value) {
  if (value == null) return false;
  return value.isNotEmpty && isNumeric(value);
}

bool isNamaPenggunaValid(String? value) {
  if (value == null || value.isEmpty) return false;

  final words = value.split(' ');
  for (var word in words) {
    if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(word)) {
      return false;
    }
  }
  return true;
}

void main() {
  runApp(MaterialApp(
    home: ProfilePageScreen(),
  ));
}
