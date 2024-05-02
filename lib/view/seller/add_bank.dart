import 'package:e_kantin/size_config.dart';
import 'package:flutter/material.dart';

class AddBankSeller extends StatefulWidget {
  const AddBankSeller({super.key});

  @override
  State<AddBankSeller> createState() => _AddBankSellerState();
}

class _AddBankSellerState extends State<AddBankSeller> {
  final TextEditingController rekeningController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> bankNames = ["Bank A", "Bank B", "Bank C", "Bank D"];
  String? selectedBank;

  final List<Map<String, String>> bankAccounts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bank Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenHeight(40),
            vertical: getProportionateScreenHeight(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Form untuk menambah bank
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Field No. Rekening
                    TextFormField(
                      controller: rekeningController,
                      decoration: const InputDecoration(
                        labelText: 'No. Rekening',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    // Dropdown Bank Name
                    DropdownButtonFormField<String>(
                      value: selectedBank,
                      decoration: const InputDecoration(
                        labelText: 'Bank Name',
                        border: OutlineInputBorder(),
                      ),
                      items: bankNames.map((String bank) {
                        return DropdownMenuItem<String>(
                          value: bank,
                          child: Text(bank),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedBank = newValue;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a bank';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),

                    // Tombol untuk menambah bank
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Tambahkan informasi ke daftar rekening
                            setState(() {
                              bankAccounts.add({
                                'account': rekeningController.text,
                                'bank': selectedBank!,
                              });
                            });

                            // Kosongkan input field
                            rekeningController.clear();
                            selectedBank = null;
                          }
                        },
                        // ignore: sort_child_properties_last
                        child: const Text('Add Bank Account'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          padding: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),

              // Daftar rekening yang sudah ditambahkan
              Column(
                children: bankAccounts.map((account) {
                  return Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_balance, color: Colors.blue),
                      title: Text(account['account']!),
                      subtitle: Text('Bank: ${account['bank']!}'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
