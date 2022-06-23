class ClubData {
  String? club_ID;
  String? club_name;
  String? club_desc;
  String? club_logo;
  String? club_email;
  String? club_category;
  String? club_registerDate;
  String? club_chairman;

  ClubData(
      {this.club_ID,
      this.club_name,
      this.club_desc,
      this.club_logo,
      this.club_email,
      this.club_category,
      this.club_registerDate,
      this.club_chairman});
}

class CommitteeData {
  String? committee_ID;
  String? club_ID;
  String? user_ID;
  bool? isApproved;
  String? approved_by;
  String? approved_date;
  String? position;

  CommitteeData(
      {this.committee_ID,
      this.club_ID,
      this.user_ID,
      this.isApproved,
      this.approved_by,
      this.approved_date,
      this.position});
}
