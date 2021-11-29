import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';

class BuscaUrl {
  Future<String> url(nomeUrl) async {
    String ambiente;
    String url;
    String portaAmbiente;
    String senhaAmbiente;
    await SharedPreferencesBloc().buscaParametro("ambiente").then((ret) async {
      //forçar ambiente de teste(Obs: ambiente setado no caminho: LoginBloc)
      ret = "Homologação";

      if (ret == "Produção") {
        portaAmbiente = "9911";
        senhaAmbiente = "ciIlbjQira";
      }
      if (ret == "Homologação") {
        portaAmbiente = "7711";
        senhaAmbiente = "bQddJcafni";
      }
      if (ret != "Homologação" && ret != "Produção") {
        portaAmbiente = "9911";
        senhaAmbiente = "ciIlbjQira";
      }

      ////////////////GETS////////////////////////
      if (nomeUrl == "token") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcGeraToken?usuario=super&senha=" +
            senhaAmbiente;
      }
      if (nomeUrl == "login") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsLoginUserDp?token="; //GET
      }
      if (nomeUrl == "contraCheque") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsFp4000?token="; //GET
      }
      if (nomeUrl == "cedulaC") {
        url =
            "https://intranet.grupohegidio.com.br:81/cgi-bin/equiplex.pl/gp/mobile/frcedulaCpdf?"; //GET
      }
      if (nomeUrl == "pontoPDF") {
        url =
            "https://intranet.grupohegidio.com.br/cgi-bin/equiplex.pl/gp/mobile/frespelhopdf?"; //GET
      }
      if (nomeUrl == "contraChequePDF") {
        url =
            "https://datasul.equiplex.com.br/cgi-bin/equiplex.pl/gp/mobile/frholeritepdfapp?"; //GET
        // "http://datasul.equiplex.com.br:81/cgi-bin/equiplex.pl/gp/mobile/frholeritepdf?"; //GET
      }
      if (nomeUrl == "ponto") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcEspelhoPonto?token="; //GET
      }
      if (nomeUrl == "bcoHoras") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcBancoHoras?token="; //GET
      }
      if (nomeUrl == "ferias") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcFerias?token="; //GET
      }
      if (nomeUrl == "aniversariantes") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcAniversariantes?token="; //GET
      }
      if (nomeUrl == "myDay") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcMeuDia?token="; //GET
      }
      //enviarMensa - receberMensa
      if (nomeUrl == "enviarRecebeMensa") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcGpMobileMensPOST?token="; //POST
      }
      if (nomeUrl == "receberArq") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcLog?token="; //GET
      }
      if (nomeUrl == "versionApp") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsKetec100?token="; //GET &chrSistema=DATASUL&chrModulo=APP_DP&chrPrograma=ARQUIVOS&chrRotina=ARQUIVOS_REG_INT&intTipoRetonoRegistros=2&dtIniFiltro=02/02/2021&dtFimFiltro=04/02/2021
      }
      ////////////////POSTS/////////////
      if (nomeUrl == "pontoAssinar") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcAssinarPonto?token="; //POST
      }
      if (nomeUrl == "pontoBater") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcBaterPonto?token="; //POST
      }
      if (nomeUrl == "enviarArq") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcArquivoBase64?token="; //POST
      }
      if (nomeUrl == "enviarSugestoes") {
        url = "https://pasoe.grupohegidio.com.br:" +
            portaAmbiente +
            "/rest/WebServiceFusionService/wsProcSugestoesColab?token="; //POST
      }
    });
    return url;
  }
}
