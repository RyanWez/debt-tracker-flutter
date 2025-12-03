import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NhostService {
  static final NhostService _instance = NhostService._internal();
  factory NhostService() => _instance;
  NhostService._internal();

  late NhostClient client;
  late GraphQLClient graphql;

  void init() {
    client = NhostClient(
      subdomain: Subdomain(
        subdomain: 'xiajqknfgxoehwigxfrg',
        region: 'ap-southeast-1',
      ),
    );

    graphql = createNhostGraphQLClient(client);
  }
}
