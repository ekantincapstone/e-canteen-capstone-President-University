import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/admin/components/user_list_item.dart';
import 'package:e_kantin/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
  }

  void initAsync() async {
    final viewModel = Provider.of<UsersViewModel>(context, listen: false);
    await viewModel.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(80),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "List of Users",
        ),
      ),
      body: Consumer<UsersViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(20)),
            child: viewModel.users.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: viewModel.users
                          .map(
                            (user) => user.role == 2
                                ? const SizedBox()
                                : UserItem(
                                    user: user,
                                  ),
                          )
                          .toList(),
                    ),
                  )
                : const Center(
                    child: Text("No Users"),
                  ),
          );
        },
      ),
    );
  }
}
