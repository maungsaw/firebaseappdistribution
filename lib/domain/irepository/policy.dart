abstract class PolicyRepositoryImpl {
  Future<int> createPolicy(String no, String status);
  Future<int> getAll();
}
