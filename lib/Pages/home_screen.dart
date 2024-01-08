import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/repository.dart';
import '../Providers/home_provider.dart';

class HomePage extends StatelessWidget {


  RepositoryProvider? repositoryProvider;

  @override
  Widget build(BuildContext context) {
    repositoryProvider = Provider.of<RepositoryProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await repositoryProvider!.refreshData(context);
        },
        child: FutureBuilder<List<Repository>>(
          future: repositoryProvider!.fetchRepositories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                      child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data![index].image),
                        ),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].login),

                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}