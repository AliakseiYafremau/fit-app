abstract interface class TransactionManager {
  void commit();
  void rollback();
}