import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/event/event_poster.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class CreateEvents extends StatefulWidget {
  String club_ID;
  CreateEvents({Key? key, required this.club_ID}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';
  String noImageSelect = '';
  String formattedStartDate = '';
  String formattedEndDate = '';

  final List<String> audienceList = ['Public', 'Private'];

  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateRangeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController audienceController = TextEditingController();
  TextEditingController numberAudienceController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    double horizontalSpace = MediaQuery.of(context).size.width * 0.05;
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Create New Event'),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (_imageFile == null) {
                                  final imageFile = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => eventPoster()),
                                  );
                                  setState(() {
                                    _imageFile = imageFile;
                                  });
                                } else {
                                  final imageFile = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => eventPoster(
                                            selectImage: _imageFile)),
                                  );
                                  setState(() {
                                    _imageFile = imageFile;
                                  });
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.blue)),
                                  height: 200,
                                  child: _imageFile == null
                                      ? const Center(
                                          child: Text('No Image Selected'))
                                      : Image.file(_imageFile!,
                                          fit: BoxFit.fill)),
                            ),
                            Text(noImageSelect,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                            const SizedBox(height: 20),
                            buildForm(titleController, 'Title',
                                eventNameValidator, Icons.title_sharp),
                            const SizedBox(height: 20.0),
                            buildForm(captionController, 'Caption',
                                captionValidator, Icons.description_outlined),
                            const SizedBox(height: 20.0),
                            buildForm(locationController, 'Location',
                                locationValidator, Icons.location_on_outlined),
                            const SizedBox(height: 20.0),
                            buildDateForm(dateRangeController, 'Date Range',
                                Icons.date_range_outlined),
                            const SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: buildTimeForm(startTimeController,
                                        'Start Time', Icons.timelapse)),
                                SizedBox(width: horizontalSpace),
                                Flexible(
                                    child: buildTimeForm(endTimeController,
                                        'End Time', Icons.timelapse))
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            audienceDropDownButton(
                                audienceController,
                                'Audience',
                                MdiIcons.accountGroupOutline,
                                audienceList),
                            const SizedBox(height: 20.0),
                            buildNumberForm(numberAudienceController,
                                'Number of Audience', Icons.numbers),
                            Text(error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                            ElevatedButton(
                              onPressed: () async {
                                if (_imageFile == null) {
                                  setState(() {
                                    noImageSelect =
                                        'Event Poster is required !';
                                  });
                                } else {
                                  setState(() => noImageSelect = '');
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);
                                    EventData eventData = EventData(
                                      event_title: titleController.text,
                                      event_caption: captionController.text,
                                      event_location: locationController.text,
                                      event_startDate: formattedStartDate,
                                      event_endDate: formattedEndDate,
                                      event_startTime: startTimeController.text,
                                      event_endTime: startTimeController.text,
                                      event_audience: audienceController.text,
                                      event_numAudience: int.parse(
                                          numberAudienceController.text),
                                    );
                                    dynamic result =
                                        ClubDatabaseService(cid: widget.club_ID)
                                            .createEvents(
                                                eventData, _imageFile, context)
                                            .whenComplete(() {
                                      showSuccessSnackBar(
                                          'Event Published !', context);
                                      Navigator.of(context).pop();
                                    }).catchError((e) => showFailedSnackBar(
                                                e.toString(), context));

                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'Could not publish the event, please try again';
                                        isLoading = false;
                                      });
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: const Text(
                                'Create',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
          );
  }

  TextFormField buildForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  TextFormField buildDateForm(
      TextEditingController controller, String labelText, IconData icons) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDateRangePicker(
            initialDateRange: DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(hours: 24 * 3))),
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 5));
        if (pickedDate != null) {
          formattedStartDate =
              DateFormat('dd-MMM-yyyy').format(pickedDate.start);
          formattedEndDate = DateFormat('dd-MMM-yyyy').format(pickedDate.end);
          controller.text = '$formattedStartDate - $formattedEndDate';
        }
      },
      onSaved: (value) {
        controller.text = value!;
      },
      validator: (value) =>
          value!.isEmpty ? "The event date is required !" : null,
      decoration: textInputDecoration.copyWith(
          labelText: labelText, prefixIcon: Icon(icons)),
    );
  }

  TextFormField buildTimeForm(
      TextEditingController controller, String labelText, IconData icons) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (value) =>
          value!.isEmpty ? "The event time is required !" : null,
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          String formattedTime = pickedTime.format(context);
          controller.text = formattedTime;
        }
      },
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: labelText, prefixIcon: Icon(icons)),
    );
  }

  DropdownButtonFormField2<String> audienceDropDownButton(
      TextEditingController controller,
      String labelText,
      IconData icon,
      List dropDownItem) {
    return DropdownButtonFormField2(
      hint: Text(labelText),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 24),
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: dropDownItem
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {
        controller.text = value!;
      },
      validator: (value) =>
          value == null ? "Please state your event's audience" : null,
    );
  }

  TextFormField buildNumberForm(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: (value) =>
          value!.isEmpty ? "Please state number of audience" : null,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  String? eventNameValidator(value) {
    if (value.isEmpty) {
      return 'The event name is required !';
    } else if (value.contains(' ')) {
      return null;
    } else {
      return 'Please input valid event name';
    }
  }

  String? captionValidator(value) {
    if (value.isEmpty) {
      return 'The caption is required !';
    } else if (value.contains(' ')) {
      return null;
    } else {
      return 'Please input valid caption';
    }
  }

  String? locationValidator(value) {
    if (value.isEmpty) {
      return 'The location is required !';
    } else {
      return null;
    }
  }
}
