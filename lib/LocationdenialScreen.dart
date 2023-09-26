import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:sextconfidential/pojo/googleplacepojo.dart';
// import 'package:searchfield/searchfield.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/Networks.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class LocationdenialScreen extends StatefulWidget {
  const LocationdenialScreen({super.key});

  @override
  LocationdenialScreenState createState() => LocationdenialScreenState();
}

class LocationdenialScreenState extends State<LocationdenialScreen> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  List<String> suggestons = [];
  List<String> selectedItems = [];
  TextEditingController addresscontroller = TextEditingController();
  static const kGoogleApiKey = "AIzaSyBQtYk9yhLQ-VX3Y2dPuZ0phbE0CSBwVps";
  int suggestionsCount = 12;
  final focus = FocusNode();
  //bool? _isSelected;
  Googleplacepojo? googleplacepojo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final suggestions =List.generate(suggestionsCount, (index) => 'suggestion $index');
    return Scaffold(
      backgroundColor: Appcolors().backgroundcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolors().bottomnavbgcolor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            print("Click back");
          },
          child: Container(
              // color: Colors.white,
              margin: EdgeInsets.only(left: 2.w),
              child: const Icon(Icons.arrow_back_ios_rounded)),
        ),
        title: Text(
          StringConstants.locationdeniel,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "PulpDisplay",
              fontWeight: FontWeight.w500,
              color: Appcolors().whitecolor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 3.w, right: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3.h,
            ),
            // placesAutoCompleteTextField()
            TypeAheadField(
              animationStart: 0,
              animationDuration: Duration.zero,
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  // focusNode: FocusNode(canRequestFocus: false),
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                  decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Appcolors().loginhintcolor)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Appcolors().logintextformborder),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Appcolors().logintextformborder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Appcolors().logintextformborder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Appcolors().logintextformborder),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 2.w,right: 2.w,top: 1.h,bottom: 1.h),
                        child: Container(
                          // : EdgeInsets.only(top: 3.h,bottom: 3.h),
                          margin: EdgeInsets.only(right: 2.w),
                          height: 4.h,
                          width: 20.w,
                          alignment: Alignment.center,
                          // padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Appcolors().selectedaddressbg,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Appcolors().whitecolor,
                              )),
                          child: Text(
                            "Seleted:${selectedItems.length}  ",
                            style: TextStyle(
                              color: Appcolors().whitecolor,
                            ),
                          ),
                        ),
                      )),
                  onChanged: (value) {
                    searchlocation(value);
                  }),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: Appcolors().loginhintcolor,
              ),
              suggestionsCallback: (pattern) {
                List<String> matches = <String>[];
                matches.addAll(suggestons);
                matches.retainWhere((s) {
                  return s.toLowerCase().contains(pattern.toLowerCase());
                });
                return matches;
              },
              itemBuilder: (context, sone) {
                return Container(
                  color: Appcolors().bottomnavbgcolor,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      selectedItems.contains(sone)
                          ? Icon(
                              Icons.check_box_outlined,
                              color: Appcolors().whitecolor,
                            )
                          : Icon(Icons.check_box_outline_blank,
                              color: Appcolors().whitecolor),
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          sone.toString(),
                          style: const TextStyle(
                              fontFamily: "PulpDisplay",
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  selectedItems.contains(suggestion)
                      ? selectedItems.remove(suggestion)
                      : selectedItems.add(suggestion);
                });
                print("Suggestions:-$suggestion");
              },
            ),
            Expanded(
              child:


              ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return
                    Column(
                    children: [
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 3.h),
                        decoration: BoxDecoration(
                            color: Appcolors().selectedaddressbg,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Appcolors().whitecolor,
                            )),
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 7, bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:75.w,
                              child: Text(
                                selectedItems.elementAt(index),
                                style: TextStyle(
                                  fontFamily: "PulpDisplay",
                                  color: Appcolors().whitecolor,
                                    fontSize: 12.sp,),overflow: TextOverflow.ellipsis
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  print("Removed");
                                  setState(() {
                                    selectedItems.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.clear_rounded,
                                  size: 25.sp,
                                  color: Appcolors().whitecolor,
                                ))
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
            // Container(
            //   height: 5.h,
            //   decoration: BoxDecoration(
            //       color: Appcolors().bottomnavbgcolor,
            //       borderRadius: BorderRadius.circular(10)
            //   ),
            //   width: double.infinity,
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton2(
            //       isExpanded: true,
            //       hint: Container(
            //         padding: EdgeInsets.only(left: 3.w,right: 3.w),
            //         alignment: AlignmentDirectional.centerStart,
            //         child: Text(
            //           'Select Items',
            //           style: TextStyle(
            //             fontSize: 14,
            //             color: Appcolors().whitecolor,
            //           ),
            //         ),
            //       ),
            //       items: items.map((item) {
            //         return DropdownMenuItem<String>(
            //           value: item,
            //           //disable default onTap to avoid closing menu when selecting an item
            //           enabled: true,
            //           child: StatefulBuilder(
            //             builder: (context, menuSetState) {
            //               final _isSelected = selectedItems.contains(item);
            //               return InkWell(
            //                 onTap: () {
            //                   _isSelected
            //                       ? selectedItems.remove(item)
            //                       : selectedItems.add(item);
            //                   //This rebuilds the StatefulWidget to update the button's text
            //                   setState(() {});
            //                   //This rebuilds the dropdownMenu Widget to update the check mark
            //                   menuSetState(() {});
            //                 },
            //                 child: Container(
            //                   color: Appcolors().bottomnavbgcolor,
            //                   height: double.infinity,
            //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //                   child: Row(
            //                     children: [
            //                       _isSelected
            //                           ?  Icon(Icons.check_box_outlined,color: Appcolors().whitecolor,)
            //                           :  Icon(Icons.check_box_outline_blank,color: Appcolors().whitecolor),
            //                       const SizedBox(width: 16),
            //                       Text(
            //                         item,
            //                         style: TextStyle(
            //                           fontSize: 14,
            //                             color: Appcolors().whitecolor
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //       }).toList(),
            //       //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
            //       value: selectedItems.isEmpty ? null : selectedItems.last,
            //       onChanged: (value) {},
            //       selectedItemBuilder: (context) {
            //         return items.map(
            //               (item) {
            //             return Container(
            //               alignment: AlignmentDirectional.center,
            //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //               child: Text(
            //                 selectedItems.join(', '),
            //                 style: const TextStyle(
            //                   fontSize: 14,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 maxLines: 1,
            //               ),
            //             );
            //           },
            //         ).toList();
            //       },
            //       buttonStyleData: const ButtonStyleData(
            //         height: 40,
            //         width: 140,
            //       ),
            //       menuItemStyleData: const MenuItemStyleData(
            //         height: 40,
            //         padding: EdgeInsets.zero,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
          textStyle: const TextStyle(color: Colors.white),
          textEditingController: addresscontroller,
          googleAPIKey: "AIzaSyBQtYk9yhLQ-VX3Y2dPuZ0phbE0CSBwVps",
          inputDecoration: const InputDecoration(
              hintText: "Search your location",
              hintStyle: TextStyle(color: Colors.white)),
          debounceTime: 800,
          // countries: ["in", "fr"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails${prediction.lng}");
          },
          itemClick: (Prediction prediction) {
            addresscontroller.text = prediction.description!;
            addresscontroller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          }
          // default 600 ms ,
          ),
    );
  }

  Future<void> searchlocation(String searchdata) async {
    // Helpingwidgets.showLoadingDialog(context, key);
    var jsonResponse;
    var response = await http.get(
      Uri.parse(
          "${Networks.autocompletebase}$searchdata&key=$kGoogleApiKey"),
    );
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        print("Response message:-${jsonResponse["message"]}");
        // Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
      } else {
        setState(() {
          suggestons.clear();
          googleplacepojo = Googleplacepojo.fromJson(jsonResponse);
          for (int i = 0; i <= googleplacepojo!.predictions!.length - 1; i++) {
            suggestons.add(googleplacepojo!.predictions!
                .elementAt(i)
                .description
                .toString());
          }
        });
        // Navigator.pop(context);
        // Helpingwidgets.successsnackbar(jsonResponse["message"].toString(), context);
        print("Response:${jsonResponse["message"]}");
      }
    } else {
      print("Response message:-${jsonResponse["message"]}");
      // Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
      // Navigator.pop(context);
    }
  }
}
