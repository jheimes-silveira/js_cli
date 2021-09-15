import 'dart:io';

import 'package:js_cli/app/domain/models/entities/controller_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/datasource_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/datasource_interface_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/dto_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/entity_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/page_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/repository_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/repository_interface_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/usecase_design_pattern.dart';
import 'package:js_cli/app/domain/models/entities/usecase_interface_design_pattern.dart';
import 'package:recase/recase.dart';

class ReservedWords {
  ReservedWords._();

  static String removeWordsInFile({required String fileString}) {
    while (fileString.contains('{{')) {
      final start = fileString.indexOf('{{');
      final end = fileString.indexOf('}}');

      String? term = fileString.substring(start + 2, end);

      fileString = fileString.replaceFirst('{{$term}}', '');
    }

    while (fileString.startsWith('/')) {
      fileString = fileString.substring(1, fileString.length);
    }

    while (fileString.endsWith('/')) {
      fileString = fileString.substring(0, fileString.length - 1);
    }

    while (fileString.contains('//')) {
      fileString = fileString.replaceAll('//', '/');
    }

    return fileString;
  }

  static String replaceWordsInFile({
    required String fileString,
    String name = '',
    String path = '',
  }) {
    while (fileString.contains('{{')) {
      final start = fileString.indexOf('{{');
      final end = fileString.indexOf('}}');

      String? term = fileString.substring(start + 2, end);
      String? word = term.split('.')[0];
      String? extension;

      if (term.split('.').length > 1) extension = term.split('.')[1];

      if (!_containsWord(word)) {
        throw Exception('essa variavel não é aceita "$word"');
      }

      word = _replaceWordWithOptions(word, name, path);

      if (extension != null) {
        word = _recase(word!, extension);

        if (word == null) {
          throw Exception('extenção não aceita "$extension"');
        }
      }

      fileString = fileString.replaceFirst('{{$term}}', word!);
    }

    return fileString;
  }

  static bool _containsWord(String word) {
    return [
      'name',
      'path',
      'module',
      'fileExtension',
      'currentPathInterface',
      'currentNameFileInterface',
      'currentPath',
      'currentNameFile',
      'currentNameClassInterface',
      'currentNameClass',
      'repositoryPathInterface',
      'repositoryNameFileInterface',
      'repositoryPath',
      'repositoryNameFile',
      'repositoryNameClassInterface',
      'repositoryNameClass',
      'datasourcePathInterface',
      'datasourceNameFileInterface',
      'datasourcePath',
      'datasourceNameFile',
      'datasourceNameClassInterface',
      'datasourceNameClass',
      'usecasePathInterface',
      'usecaseNameFileInterface',
      'usecasePath',
      'usecaseNameFile',
      'usecaseNameClassInterface',
      'usecaseNameClass',
      'pagePath',
      'pageNameFile',
      'pageNameClass',
      'controllerPath',
      'controllerNameFile',
      'controllerNameClass',
      'entityPath',
      'entityNameFile',
      'entityNameClass',
      'dtoPath',
      'dtoNameFile',
      'dtoNameClass',
    ].contains(word);
  }

  static String? _recase(String word, String extension) {
    if (word.contains('{{')) {
      return word;
    } //TDOO implementar algoritimo que aplique o replace em tudo exceto o conteudo dentro dos mustaches {{name.snakeCase}}_controller
    if (word.contains('current')) {
      return word;
    } //TDOO a palavra current deve ser substituida no procimo laço
    if (word.contains('module')) {
      return word;
    } //TDOO a palavra current deve ser substituida no procimo laço
    if (word.contains('fileExtension')) {
      return word;
    } //TDOO a palavra current deve ser substituida no procimo laço
    if (extension == 'camelCase') {
      return word.camelCase; // exemple testeCase
    } else if (extension == 'constantCase') {
      return word.constantCase; // exemple TESTE_CASE
    } else if (extension == 'sentenceCase') {
      return word.sentenceCase; // exemple Teste case
    } else if (extension == 'snakeCase') {
      return word.snakeCase; // exemple teste_case
    } else if (extension == 'dotCase') {
      return word.dotCase; // exemple teste.case
    } else if (extension == 'paramCase') {
      return word.paramCase; // exemple teste-case
    } else if (extension == 'pathCase') {
      return word.pathCase; // exemple teste/case
    } else if (extension == 'pascalCase') {
      return word.pascalCase; // exemple TesteCase
    } else if (extension == 'headerCase') {
      return word.headerCase; // exemple Teste-Case
    } else if (extension == 'titleCase') {
      return word.titleCase; // exemple Teste Case
    } else {
      return null;
    }
  }

  static String? _replaceWordWithOptions(
    String word,
    String name,
    String path,
  ) {
    final action = {
      'module': Platform.isMacOS
          ? '${path.split('/').last}'
          : '${path.split('\\').last}',
      'name': name,
      'path': path,
      'repositoryPathInterface': RepositoryInterfaceDesignPattern().path(),
      'repositoryNameFileInterface':
          RepositoryInterfaceDesignPattern().nameFile(),
      'repositoryPath': RepositoryDesignPattern().path(),
      'repositoryNameFile': RepositoryDesignPattern().nameFile(),
      'repositoryNameClassInterface':
          RepositoryInterfaceDesignPattern().nameClass(),
      'repositoryNameClass': RepositoryDesignPattern().nameClass(),
      'datasourcePathInterface': DatasourceInterfaceDesignPattern().path(),
      'datasourceNameFileInterface':
          DatasourceInterfaceDesignPattern().nameFile(),
      'datasourcePath': DatasourceDesignPattern().path(),
      'datasourceNameFile': DatasourceDesignPattern().nameFile(),
      'datasourceNameClassInterface':
          DatasourceInterfaceDesignPattern().nameClass(),
      'datasourceNameClass': DatasourceDesignPattern().nameClass(),
      'usecasePathInterface': UsecaseInterfaceDesignPattern().path(),
      'usecaseNameFileInterface': UsecaseInterfaceDesignPattern().nameFile(),
      'usecasePath': UsecaseDesignPattern().path(),
      'usecaseNameFile': UsecaseDesignPattern().nameFile(),
      'usecaseNameClassInterface': UsecaseInterfaceDesignPattern().nameClass(),
      'usecaseNameClass': UsecaseDesignPattern().nameClass(),
      'pagePath': PageDesignPattern().path(),
      'pageNameFile': PageDesignPattern().nameFile(),
      'pageNameClass': PageDesignPattern().nameClass(),
      'controllerPath': ControllerDesignPattern().path(),
      'controllerNameFile': ControllerDesignPattern().nameFile(),
      'controllerNameClass': ControllerDesignPattern().nameClass(),
      'entityPath': EntityDesignPattern().path(),
      'entityNameFile': EntityDesignPattern().nameFile(),
      'entityNameClass': EntityDesignPattern().nameClass(),
      'dtoPath': DtoDesignPattern().path(),
      'dtoNameFile': DtoDesignPattern().nameFile(),
      'dtoNameClass': DtoDesignPattern().nameClass(),
    };

    return action[word];
  }
}
