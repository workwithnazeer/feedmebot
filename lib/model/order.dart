class Order extends Comparable {
  int orderId;
  String itemName;
  bool isMember;
  String orderStatus;

  Order(
      {required this.orderId,
      required this.itemName,
      required this.isMember,
      required this.orderStatus});

  @override
  int compareTo(other) {
    if (isMember == false && other.isMember == false) {
      return -1;
    }
    if (isMember == true && other.isMember == true) {
      return -1;
    }
    if (isMember == false) {
      return 1;
    }
    return 0;
  }
}
