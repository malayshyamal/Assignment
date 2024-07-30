import 'package:flutter/material.dart';
import 'package:flutter_assigment/apiServices.dart';
import 'package:flutter_assigment/model.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  bool isLoading = false;
  bool isLoadingMore = false;
  List<User> userData = [];
  List<User> filterByUser = [];
  String? countryName;
  String? genderName;
  ApiServices apiServices = ApiServices();
  int currentPage = 0;
  int itemslimit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchApiData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  void filterByCountry(String value) {
    setState(() {
      filterByUser = value.isEmpty
          ? userData
          : userData
              .where((element) => element.address.country == value)
              .toList();
      countryName = value;
    });
  }

  void filterByGender(String value) {
    setState(() {
      filterByUser = value.isEmpty
          ? userData
          : userData.where((element) => element.gender == value).toList();
      genderName = value;
    });
  }

  Future fetchApiData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedData = await apiServices.fetchUserData();
      setState(() {
        userData = fetchedData;
        filterByUser = userData;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void loadMoreData() {
    if ((currentPage + 1) * itemslimit < filterByUser.length) {
      setState(() {
        isLoadingMore = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            currentPage++;
            isLoadingMore = false;
          });
        }
      });
    }
  }

  List<User> get _currentItemsList {
    int start = currentPage * itemslimit;
    int end = start + itemslimit;
    return filterByUser.sublist(
        start, end > filterByUser.length ? filterByUser.length : end);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : userData.isEmpty
                ? Center(
                    child: Text('Data Not Found'),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'lib/images/pixel6.jpeg',
                              height: height * 0.1,
                            ),
                            Icon(Icons.menu, color: Colors.red),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Employees',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.filter_list_alt,
                                  size: height * 0.04,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: width * 0.3,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: SizedBox.shrink(),
                                      icon: Icon(Icons.keyboard_arrow_down,
                                          size: 15),
                                      hint: Text('Country',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      value: countryName,
                                      items: userData
                                          .map((e) => e.address.country)
                                          .toSet()
                                          .map((e) => DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(e,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold))))
                                          .toList(),
                                      onChanged: (value) {
                                        filterByCountry(value!);
                                      }),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: width * 0.2,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: SizedBox.shrink(),
                                      icon: Icon(Icons.keyboard_arrow_down,
                                          size: 15),
                                      hint: Text('Gender',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      value: genderName,
                                      items: userData
                                          .map((e) => e.gender)
                                          .toSet()
                                          .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold))))
                                          .toList(),
                                      onChanged: (value) {
                                        filterByGender(value!);
                                      }),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Row(
                                      children: [
                                        Text('ID'),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        Image.asset(
                                          'lib/images/up-and-down-arrows.png',
                                          height: height * 0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataColumn(label: Text('Image')),
                                  DataColumn(
                                    label: Row(
                                      children: [
                                        Text('Full Name'),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        Image.asset(
                                          'lib/images/up-and-down-arrows.png',
                                          height: height * 0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataColumn(label: Text('Demography')),
                                  DataColumn(label: Text('Designation')),
                                  DataColumn(label: Text('Location')),
                                ],
                                rows: _currentItemsList.map((userEmployee) {
                                  return DataRow(cells: [
                                    DataCell(Text(userEmployee.id.toString())),
                                    DataCell(Image.network(userEmployee.image)),
                                    DataCell(Text(
                                        '${userEmployee.firstName} ${userEmployee.maidenName} ${userEmployee.lastName}')),
                                    DataCell(Text(
                                        '${userEmployee.gender == 'female' ? 'F' : 'M'}/${userEmployee.age}')),
                                    DataCell(Text(userEmployee.company.title)),
                                    DataCell(Text(
                                        '${userEmployee.address.state}, ${userEmployee.address.country == 'United States' ? 'US' : userEmployee.address.country}')),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        if (isLoadingMore)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ));
  }
}
