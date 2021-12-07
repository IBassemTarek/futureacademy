import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../Models/modal_progress_hub.dart';
import '../Models/user.dart';
import '../services/auth_services.dart';
import '../wrapper.dart';
import '../../../const.dart';
import 'custom_text_field.dart';

// ignore: must_be_immutable
class SignIn extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final adminPassword = 'SaryAcademy12345';
  final _auth = AuthService();
  late String _email, _password;

  SignIn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHub>(context).isLoading,
        child: Builder(builder: (context) {
          return Form(
            key: _globalKey,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Container(
                  height: 0.43998 * _height,
                  width: _width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    gradient: LinearGradient(
                        colors: [
                          kGradColor1.withOpacity(1),
                          kGradColor2.withOpacity(1),
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                        stops: const [0.3, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: _height * 0.0971,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        height: 0.17299 * _height,
                        width: 0.4589372 * _width,
                      ),
                      SizedBox(
                        height: _height * 0.016875,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("مرحبا",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                        color: kBackgroundColor, fontSize: 36)),
                            SizedBox(
                              height: _height * 0.02232143,
                            ),
                            Text("قم بتسحيل دخولك بالبريد الإليكتروني",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: kBackgroundColor)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.0725446 * _height,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.120773 * _width),
                  width: _width * 0.758454,
                  //  height: 0.068080*_height,
                  child: CustomTextField(
                    lableText: 'البريد الايكتروني',
                    hintText: "info@futureacademy.com",
                    onClick: (value) {
                      _email = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 0.049107 * _height,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.120773 * _width),
                  width: _width * 0.758454,
                  //  height: 0.068080*_height,
                  child: CustomTextField(
                    lableText: 'كلمة السر',
                    hintText: "Ss@21062020",
                    onClick: (value) {
                      _password = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 0.08800 * _height,
                ),
                Builder(
                  builder: (context) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.2 * _width),
                    child: InkWell(
                      onTap: () async {
                        _validate(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: _width * 0.718454,
                        height: 0.058080 * _height,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: kTextColor,
                        ),
                        child: Text('تسجيل دخول',
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                    color: kBackgroundColor, fontSize: 24)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.02116 * _height,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _validate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final modelhud = Provider.of<ModelHub>(context, listen: false);
    modelhud.changeIsLoading(true);
    if (_globalKey.currentState!.validate()) {
      _globalKey.currentState!.save();

      try {
        if (_password != adminPassword) {
          prefs.setBool("isAdmin", false);
          dynamic userData = await _auth.signIn(_email, _password);
          if (userData != null) {
            modelhud.changeIsLoading(false);
            UserModel user = _auth.userFromFirebaseUser(userData);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(user.id),
            ));
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Wrapper()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("you are an admin please switch to admin mode"),
          ));
        }
      } catch (e) {
        modelhud.changeIsLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
    modelhud.changeIsLoading(false);
  }
}
