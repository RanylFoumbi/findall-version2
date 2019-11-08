
class Found{
  final String objectName;
  final String town;
  final String quarter;
  final String date;
  final String phone;
  final String postBy;
  final bool isLost;
  final String description;
  final String rewardAmount;
  final List imageUrl;


  Found(
        {
          this.objectName,
          this.town,
          this.quarter,
          this.date,
          this.phone,
          this.postBy,
          this.isLost,
          this.description,
          this.rewardAmount,
          this.imageUrl,
        }
    );
}