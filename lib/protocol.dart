enum Branches { alex, cairo, main }

enum Commands { ready, create, withdraw, transfer, deposit, initialSetup, accounts }

Map<String, dynamic> map(String branch, String command, dynamic data) => {
  "branch": branch,
  "command": command,
  "data": data,
};
