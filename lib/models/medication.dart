class Medication {
  static int _idCounter = 0;
  int id;
  int userId;
  String name;
  String form;
  String strength;
  int  stockQuantity;
  int refillThreshold;
  String instructions;
  Medication({
    required this.userId,
    required this.name,
    required this.form,
    required this.strength,
    required this.stockQuantity,
    required this.refillThreshold,
    required this.instructions,
  }) : id = _idCounter++;
}