import 'package:flutter/material.dart';
import 'package:simple_form_builder/global/constant.dart';
import 'package:simple_form_builder/src/widgets/customDropdownWidget.dart';

import 'models/checklistModel.dart';

class FormBuilder extends StatefulWidget {
  final Map<String, dynamic> initialData;
  String? multipleimage,
      dropdownImage,
      dateImage,
      textImage,
      checkboxImage,
      remarkImage;
  int index;
  bool showIcon;
  Function onSubmit;

  FormBuilder({
    required this.initialData,
    required this.index,
    this.multipleimage, //adds  image for case 'multiple'
    this.dropdownImage, //adds  image for case 'dropdown'
    this.checkboxImage, //adds  image for case 'checkbox'
    this.dateImage, //adds  image for case 'date'
    this.textImage, //adds  image for case 'text'
    this.remarkImage, //adds image for remarks
    this.showIcon = false, //to enable or disable question icon
    required this.onSubmit,
  });

  @override
  _FormBuilderState createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  ChecklistModel? checklistModel;
  @override
  void initState() {
    checklistModel = ChecklistModel.fromJson(widget.initialData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...checklistModel!.data![widget.index].questions!
                .map((e) => questionWidget(e, widget.showIcon))
                .toList(),
            SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onSubmit(getCompleteData());
                },
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCompleteData() {
    return checklistModel!.toJson();
  }

  Widget questionWidget(
    Questions e,
    remarks,
  ) {
    switch (e.type) {
      case "multiple":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16),
              child: Row(
                children: [
                  widget.showIcon
                      ? iconContainer(widget.multipleimage)
                      : Container(),
                  Text(
                      "${checklistModel!.data![widget.index].questions!.indexOf(e) + 1}. ${e.title}"),
                ],
              ),
            ),
            Column(
              children: e.fields!
                  .map(
                    (val) => RadioListTile(
                      value: val,
                      groupValue: e.answer,
                      title: Text(
                        val,
                        style: TextStyle(
                          color: e.answer != val ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth(
                            context: context,
                            mulBy: 0.04,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        e.answer = value;
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            remarkWidget(e, remarks, widget.remarkImage),
          ],
        );

      case "dropdown":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16),
              child: Row(
                children: [
                  widget.showIcon
                      ? iconContainer(widget.dropdownImage)
                      : Container(),
                  Text(
                      "${checklistModel!.data![widget.index].questions!.indexOf(e) + 1}. ${e.title}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24,
              ),
              child: Container(
                width: screenWidth(context: context, mulBy: 0.5),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: e.answer != null ? Colors.blue : Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: e.answer == null
                        ? Text('Filter by')
                        : Text(
                            e.answer,
                            style: TextStyle(
                              color:
                                  e.answer != null ? Colors.blue : Colors.grey,
                            ),
                          ),
                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.grey),
                    items: e.fields!.map(
                      (val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        e.answer = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            remarkWidget(e, remarks, widget.remarkImage),
          ],
        );

      case "checkbox":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16),
              child: Row(
                children: [
                  widget.showIcon
                      ? iconContainer(widget.checkboxImage)
                      : Container(),
                  Text(
                      "${checklistModel!.data![widget.index].questions!.indexOf(e) + 1}. ${e.title}"),
                ],
              ),
            ),
            Column(
              children: e.fields!
                  .map(
                    (val) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      title: Text(
                        val,
                        style: TextStyle(
                          color: e.answer[e.fields!.indexOf(val)] != true
                              ? Colors.grey
                              : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth(
                            context: context,
                            mulBy: 0.04,
                          ),
                        ),
                      ),
                      value: e.answer[e.fields!.indexOf(val)],
                      onChanged: (value) {
                        e.answer[e.fields!.indexOf(val)] = value;
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            remarkWidget(e, remarks, widget.remarkImage),
          ],
        );

      case "date":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16),
              child: Row(
                children: [
                  widget.showIcon
                      ? iconContainer(widget.dateImage)
                      : Container(),
                  Text(
                      "${checklistModel!.data![widget.index].questions!.indexOf(e) + 1}. ${e.title}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: <Widget>[
                  Theme(
                    data: ThemeData(),
                    child: Builder(
                      builder: (context) => customDropdownWidget(
                        onChanged: (val) {
                          print(val);
                        },
                        onTap: () async {
                          DateTime tempDate = await selectDate(context);

                          if (e.answer == null) {
                            setState(() {
                              e.answer = tempDate;
                            });
                          } else {
                            setState(() {
                              e.answer = DateTime(
                                tempDate.year,
                                tempDate.month,
                                tempDate.day,
                                e.answer.hour,
                                e.answer.minute,
                              );
                            });
                          }
                        },
                        title: e.answer == null
                            ? "DD-MM-YYYY"
                            : dateFormater.format(e.answer),
                        // date != null ? dateFormater.format(date) : "DD-MM-YYYY",
                        context: context,

                        showImage: false,
                        isRequired: false,
                        width: screenWidth(context: context, mulBy: 0.4),
                      ),
                    ),
                  ),
                  customDropdownWidget(
                    onChanged: (val) {},
                    onTap: () async {
                      TimeOfDay tempTime = await selectTime(context);

                      if (e.answer == null) {
                        setState(() {
                          e.answer = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            tempTime.hour,
                            tempTime.minute,
                          );
                        });
                      } else {
                        setState(() {
                          e.answer = DateTime(
                            e.answer.year,
                            e.answer.month,
                            e.answer.day,
                            tempTime.hour,
                            tempTime.minute,
                          );
                        });
                      }

                      // reminderController.updateIschanged(true);
                    },
                    title: e.answer != null
                        ? formatTimeOfDay(TimeOfDay.fromDateTime(e.answer))
                        : "Hr:Mins",
                    context: context,
                    showImage: false,
                    isRequired: false,
                    width: screenWidth(context: context, mulBy: 0.3),
                  ),
                ],
              ),
            ),
            remarkWidget(e, remarks, widget.remarkImage),
          ],
        );

      case "text":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16),
              child: Row(
                children: [
                  widget.showIcon
                      ? iconContainer(widget.textImage)
                      : Container(),
                  Text(
                      "${checklistModel!.data![widget.index].questions!.indexOf(e) + 1}. ${e.title}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 24,
              ),
              child: Container(
                width: screenWidth(context: context, mulBy: 0.7),
                child: TextField(
                  onChanged: (value) {
                    // e.answer = value;
                    setState(() {
                      e.answer = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter text here",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            remarkWidget(e, remarks, widget.remarkImage),
          ],
        );

      default:
        return SizedBox();
    }
  }

  Widget iconContainer(image) {
    return image == null
        ? Container()
        : Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              image,
              height: 20,
            ),
          );
  }

  Widget remarkWidget(Questions e, showIcon, image) {
    return e.remark
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: <Widget>[
                    showIcon == false
                        ? SizedBox(
                            width: 16,
                          )
                        : image == null
                            ? Container(
                                padding: EdgeInsets.only(left: 16),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Image.asset(
                                  image,
                                  height: 20,
                                ),
                              ),
                    Text("Enter remarks"),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        e.remarkData = value;
                        setState(() {});
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: "Enter your remarks",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
