import 'package:admin_catalogo/core/result/result.dart';
import 'package:flutter/material.dart';

// CommandAction0 0 não possui parametros de entrada
typedef CommandAction0<Output extends Object> = Future<Result<Output>>
    Function();

typedef CommandAction1<Output extends Object, Input extends Object>
    = Future<Result<Output>> Function(Input);

abstract class Command<Output extends Object> extends ChangeNotifier {
  // Verifica se o command está em execução
  bool _running = false;
  bool get running => _running;

  // representação do nosso estado => Ok ou Error ou NULL
  Result<Output>? _result;
  Result<Output>? get result => _result;

  bool get completed =>
      _result is Ok; // Verifica se o nosso estado foi gerado com sucesso
  bool get error => _result is Error; // Verifica se o nosso estado é de erroe

  Future<void> _execute(CommandAction0<Output> action) async {
    if (_running) {
      return; // Impede que a action seja executada mais de uma vez simutaneamente
    }

    _running = true;
    _result = null;

    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

class Command0<Output extends Object> extends Command<Output> {
  final CommandAction0<Output> action;
  Command0(this.action);

  Future<void> execute() async {
    await _execute(() => action());
  }
}

class Command1<Output extends Object, Input extends Object>
    extends Command<Output> {
  final CommandAction1<Output, Input> action;

  Command1(this.action);

  Future<void> execute(Input params) async {
    await _execute(() => action(params));
  }
}
