class EventData {
  String? event_ID;
  String? event_title;
  String? event_caption;
  String? event_location;
  String? event_start;
  String? event_end;
  String? event_audience;
  int? event_numAudience;
  String? event_poster;
  String? club_ID;

  EventData({
    this.event_ID,
    this.event_title,
    this.event_caption,
    this.event_location,
    this.event_start,
    this.event_end,
    this.event_audience,
    this.event_numAudience,
    this.event_poster,
    this.club_ID,
  });
}

class RegisterData {
  String? register_ID;
  String? event_ID;
  String? user_ID;
  String? register_time;

  RegisterData(
      {this.register_ID, this.event_ID, this.user_ID, this.register_time});
}
