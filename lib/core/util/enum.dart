enum RouteName {
  home,
  calculator,
  policy,
  premiumTerm,
  premiumPolicy,
  taskManage,
  tax,
  user,
}

enum PolicyStatus {
  complete("COMPLETED"),
  pending("PENDING"),
  draft("DRAFT");

  final String label;
  const PolicyStatus(this.label);
}

enum FormType { create, edit, detail }

enum ClientServiceType { public, protected }
