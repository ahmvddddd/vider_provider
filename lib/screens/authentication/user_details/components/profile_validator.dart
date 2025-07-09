

// New: Validation class
class ProfileValidator {
  static String? validate({
  required String? bio,
  required String? category,
  required String? service,
  required List<String> skills,
  required bool dobSelected,
  required String? ageValidationMessage,
  required String? hourlyRate,
}) {
  if (!dobSelected) return "Please select your date of birth";
  if (ageValidationMessage != null) return "You must be at least 18 years old";
  if (bio == null || bio.trim().isEmpty) return "Bio cannot be empty";
  if (category == null) return "Please select a category";
  if (service == null) return "Please select a service";
  if (skills.isEmpty) return "Please add at least one skill";
  if (hourlyRate == null || hourlyRate.isEmpty) return "Hourly rate is required.";

  final rate = double.tryParse(hourlyRate);
  if (rate == null) return "Hourly rate must be a valid number.";
  if (rate < 5.0) return "Hourly rate must be at least \$5.";

  return null;
}

}