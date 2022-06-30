import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/event/event_poster.dart';
import 'package:scms/services/event_database.dart';
import 'package:scms/shared/constants.dart';

class EditEvent extends StatefulWidget {
  String club_ID;
  EventData eventData;
  EditEvent({Key? key, required this.club_ID, required this.eventData})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstLoad = true;
  String error = '';
  String noImageSelect = '';
  String formattedStartDate = '';
  String formattedEndDate = '';

  DateTime eventStart = DateTime.now();
  DateTime eventEnd = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

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
    if (isFirstLoad) {
      titleController.text = widget.eventData.event_title!;
      captionController.text = widget.eventData.event_caption!;
      locationController.text = widget.eventData.event_location!;

      eventStart = DateTime.parse(widget.eventData.event_start!);
      eventEnd = DateTime.parse(widget.eventData.event_end!);
      formattedStartDate = DateFormat('dd-MMM-yyyy').format(eventStart);
      formattedEndDate = DateFormat('dd-MMM-yyyy').format(eventEnd);
      dateRangeController.text = '$formattedStartDate - $formattedEndDate';

      startTime = TimeOfDay.fromDateTime(eventStart);
      endTime = TimeOfDay.fromDateTime(eventEnd);
      startTimeController.text = startTime.format(context);
      endTimeController.text = endTime.format(context);
      audienceController.text = widget.eventData.event_audience!;
      numberAudienceController.text =
          widget.eventData.event_numAudience!.toString();
      isFirstLoad = false;
    }
    double horizontalSpace = MediaQuery.of(context).size.width * 0.05;
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Event'),
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
                                      ? Image.network(
                                          '${widget.eventData.event_poster}')
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
                                        'Start Time', Icons.timelapse, true)),
                                SizedBox(width: horizontalSpace),
                                Flexible(
                                    child: buildTimeForm(endTimeController,
                                        'End Time', Icons.timelapse, false))
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
                                if (_imageFile == null &&
                                    widget.eventData.event_poster == null) {
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
                                      event_start: eventStart.toString(),
                                      event_end: eventEnd.toString(),
                                      event_audience: audienceController.text,
                                      event_numAudience: int.parse(
                                          numberAudienceController.text),
                                    );
                                    dynamic result = EventDatabaseService(
                                            cid: widget.club_ID,
                                            eid: widget.eventData.event_ID)
                                        .updateEventData(
                                            eventData, _imageFile, context)
                                        .whenComplete(() {
                                      showSuccessSnackBar(
                                          'Event Updated !', context);
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
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
          );
  }

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
            initialDateRange: DateTimeRange(start: eventStart, end: eventEnd),
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 5));
        if (pickedDate != null) {
          eventStart = pickedDate.start;
          eventEnd = pickedDate.end;
          String formattedStartDate =
              DateFormat('dd-MMM-yyyy').format(pickedDate.start);
          String formattedEndDate =
              DateFormat('dd-MMM-yyyy').format(pickedDate.end);
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

  TextFormField buildTimeForm(TextEditingController controller,
      String labelText, IconData icons, bool isStartTime) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (value) =>
          value!.isEmpty ? "The event time is required !" : null,
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: isStartTime ? startTime : endTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          if (isStartTime) {
            startTime = pickedTime;
            eventStart = join(eventStart, pickedTime);
          } else {
            endTime = pickedTime;
            eventEnd = join(eventEnd, pickedTime);
          }
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
      value: controller.text,
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
