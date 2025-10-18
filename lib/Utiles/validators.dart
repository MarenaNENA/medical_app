class Validators {
  static String? validateRequired(String? value){
    if (value == null || value.trim().isEmpty){
      return"This value is required";
    }
    return null;
  }

  static String? validateEmail(String? value){
    if (value == null || value.trim().isEmpty){
      return"Email is required";
    }
     final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
     if (!emailRegex.hasMatch(value)){
      return "Enter a valid Email";
     }
     return null;
  }

  static String? validatepassword(String? value){
    if (value == null || value.trim().isEmpty){
      return"password is required";
    }
     if (value.length< 8){
      return "Password must be at least 8 characters";
     }
     return null;
  }
  
  static String? validateDepartment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a department';
    }
    return null;
  }
}