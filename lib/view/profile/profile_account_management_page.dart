import 'package:rayo/utils/import_index.dart';

class ProfileAccountManagementPage extends StatelessWidget {
  const ProfileAccountManagementPage({super.key});

  @override
  Widget build(context) {
    InkWell settingMenu({required VoidCallback func, required String text}) {
      return InkWell(
        onTap: func,
        child: Container(
          width: double.infinity,
          color: white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            text,
            style: TextStyle(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 19.09 / 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('accountManagement'.tr()),
        backgroundColor: white,
        leading: BackBtn(
            color: black,
            func: () async {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        children: [
          settingMenu(
              text: 'deleteAccount'.tr(),
              func: () =>
                  Navigator.pushNamed(context, NAV_ProfileAccountClosePage)),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
