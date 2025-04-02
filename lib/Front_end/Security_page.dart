import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {

  //show email options

void _showEmailOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Email Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color:Color.fromARGB(255, 42, 103, 34)),
                title: Text("Change Email"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete Email"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

 //show change phone number

void _showPhoneNumOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Phone Number Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color:Color.fromARGB(255, 42, 103, 34)),
                title: Text("Change Phone Num"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete Phone Num"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //show changing password
 void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
               SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showDeletingAccMsg() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
          'Attention ⚠️',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red, // Optional: You can change the text color
          ),
        ),
        content: Text(
          'Are you sure you want to delete this account?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black, // Optional: You can change the text color
          ),
        ),
           actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Settings"),
      ),
      body: ListView(
        children: [
          //authentication card
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Contact Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900),
            ),
          ),

          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children:  [
                ListTile(
                  leading: Icon(Icons.email, color: Color.fromARGB(255, 42, 103, 34)),
                  title: Text("Email"),
                  subtitle: Text("example@email.com"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _showEmailOptions,
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: const Color.fromARGB(255, 42, 103, 34)),
                  title: Text("Phone"),
                  subtitle: Text("+213 123 456 789"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _showPhoneNumOptions,
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),


          //security card
Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Security Card",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900),
            ),
          ),

          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.lock, color: const Color.fromARGB(255, 42, 103, 34)),
                  title: Text("Change Password"),
                  trailing: Icon(Icons.arrow_forward_ios),
                   onTap: _showChangePasswordDialog,
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),

          //account management card
Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Account Management",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900),
            ),
          ),

          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children:  [
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text("Delete Account'"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _showDeletingAccMsg,
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
