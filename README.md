# GP_Mobile_Web

Um projeto mobile flutter para o departamento de gestao de pessoas.

Versao   | Data atualizacao
--------- | ------
Versao 1.0 | 20/09/21
Versao 1.1 | 15/10/21

 - [Antes_do_Build]
    $ Mudar versão so aplicativo no pubspec : version: 1.x.x
    $ Mudar versão so aplicativo no versao/ValidaVersaoBloc : version: 1.x.x

 - [Build_Mobile]
    ```
    $ flutter clean
    $ flutter pub get
    $ flutter build apk

    ```
 - [Build_Web]
    ```
    $ flutter clean
    $ flutter pub get
    $ flutter build web

    ```

 - [Doc_Tecnica]
    *Antes de subir o projeto no Apache, sera necessario duas configuracoes no fonte index.html:*
    
    ##### 1º add o endpoint no [href](https://flutter.dev/docs/development/ui/navigation/url-strategies)
    ~~~html
    <base href="/mesmo_nome_do_endpoint/">
    ~~~


    ##### 2º para evitar cache de [versao](https://stackoverflow.com/questions/61286756/stop-saving-in-cache-memory-flutter-web-firebase-hosting)
    ~~~javascript
    <script src="main.dart.js`?version=1`" type="application/javascript"></script>
    ~~~

 #by @devtvas
