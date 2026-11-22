// Contract from TEAM.md §2, owned by Amina. Only the signature ApiClient
// needs; Amina adds the flutter_secure_storage implementation (R29).
abstract interface class SecureStore {
  Future<String?> readToken();
}
