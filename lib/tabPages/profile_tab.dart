import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../infoHandler/app_info.dart';
import '../mainScreens/info_design_ui.dart';


class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage>
{
  List<String> languages = ["en","de"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: LocaleText("Profile"),
        leading: Container(),
        actions: [
        //   IconButton( onPressed: ()
        // {
        //   fAuth.signOut();
        //   SystemNavigator.pop();
        // },
        //
        //     icon: Icon(Icons.logout)),
          DropdownButton<String>(
            dropdownColor: PRIMARY_COLOR,
            elevation: 5,
            underline: Divider(color: Colors.white,),
            icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
            items: languages.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem(value: value,
                child: Text(value,style: const TextStyle(color: Colors.white,),),
              );

            }).toList(),
            value: Locales.currentLocale(context)!.languageCode,
            hint: Text("Language",style: textMediumStyle.copyWith(fontWeight: FontWeight.w400),)
            , onChanged: (newValue){
              Locales.change(context, newValue as String);

          },

          ),


        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //name
            Text(
              onlineDriverData.name!,
              style: const TextStyle(
                fontSize: 50.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),


            Text(
               titleStarsRating +""+ Locales.string(context,"driver"),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(height: 38.0,),

            //phone
            InfoDesignUIWidget(
              textInfo: onlineDriverData.phone ??"",
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: onlineDriverData.email!,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: onlineDriverData.car_color! + " " + onlineDriverData.car_model! + " " +  onlineDriverData.car_number!,
              iconData: Icons.car_repair,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: ()async
              {
              await fAuth.signOut();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                primary: PRIMARY_COLOR,
              ),
              child: LocaleText(
                "logout",
                style: TextStyle(color: Colors.white),
              ),
            )

          ],
        ),
      ),
    );
  }
}
