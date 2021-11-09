import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/details_page.dart';

const String routeSplash = '/splashWidget';
const String routeLoginWidget = '/loginWidget';
const String routeHomeWidget = '/homeWidget'; //0
const String routeFeriasWidget = '/feriasWidget';
const String routeBcoHorasWidget = '/bcoHorasWidget';
const String routePontoWidget = '/pontoWidget';
const String routeMyDayWidget = '/myDayWidget';
const String routeNiverWidget = '/niverWidget';
const String routeEnviarMensaWidget = '/enviarMensaWidget';
const String routeListarMensaWidget = '/listarMensaWidget';
const String routeEnviarDocWidget = '/listarDocWidget';
const String routeListarDocWidget = '/listarDocWidget';
const String routeConfigWidget = '/configWidget';
const String routeModoNoturno = '/modoNoturnoWidgetWeb';
const String routeSobreWidget = '/sobreWidget';
const String PAGE_NOTIFICATION_DETAILS = '/notification-details';
//
final navKey = new GlobalKey<NavigatorState>();

Map<String, WidgetBuilder> materialRoutes = {
  PAGE_NOTIFICATION_DETAILS: (context) =>
      NotificationDetailsPage(ModalRoute.of(context).settings.arguments),
};
