import 'package:flutter/material.dart';
import 'package:carrental/services/auth_services.dart';

import 'ContactUsScreen.dart';

class Dr extends StatelessWidget {
  const Dr({super.key});

  @override
  Widget build(BuildContext context) {
    const itemTextStyle = TextStyle(fontSize: 24, color: Colors.white);
    const itemIconColor = Colors.white;

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/car2.jpg'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.home_outlined, size: 30, color: itemIconColor),
            title: Text('Home', style: itemTextStyle),
            onTap: () {},
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.contact_mail_outlined,
              size: 30,
              color: itemIconColor,
            ),
            title: Text('Contact Us', style: itemTextStyle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Contactusscreen()),
              );
            },
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              size: 30,
              color: itemIconColor,
            ),
            title: Text('Logout', style: itemTextStyle),
            onTap: () async {
              Navigator.of(context).pop();

              await AuthService().signOut();
            },
          ),
        ],
      ),
    );
  }
}
