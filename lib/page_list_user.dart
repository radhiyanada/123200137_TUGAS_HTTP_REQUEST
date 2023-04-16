import 'package:flutter/material.dart';
import 'package:pertemuan6/api_data_source.dart';
import 'users_model.dart';
import 'page_detail_user.dart';

class PageListUsers extends StatelessWidget {
  const PageListUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List dari User'),
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if(snapshot.hasData){
            UsersModel usersModel = UsersModel.fromJson(snapshot.data);
            return _buildSuccessSection(usersModel);
          } 
        return _buildLoadingSection();
        },
      ),
    );
  }
  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
      return Center(
        child: CircularProgressIndicator(),
      );
  }

  Widget _buildSuccessSection(UsersModel data) {
      return ListView.builder(
        itemCount: data.data!.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItemUsers(context, data.data![index]);
        },
      );
  }

  Widget _buildItemUsers(BuildContext context, Data userData) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageDetailUser(idUser: userData.id!,))
      ),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Container(
              width: 100,
              child: Image.network(userData.avatar!),
          ),
          SizedBox(width: 20,),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userData.firstName! + " " + userData.lastName!),
                Text(userData.email!)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

