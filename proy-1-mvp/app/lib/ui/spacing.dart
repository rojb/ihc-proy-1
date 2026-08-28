/// Escala de espaciado. Base 8.
///
/// Antes de este archivo las distancias se elegían pantalla por pantalla:
/// convivían 2, 4, 6, 8, 10, 12, 14, 20, 24 y 32 sin una razón que las
/// distinguiera. Eso no se ve como un error —cada pantalla por separado está
/// bien— pero al recorrer la app el ritmo cambia sin motivo, y no había forma
/// de explicar por qué dos elementos estaban a 10 y otros dos a 12.
///
/// La escala no es una cárcel: es una manera de que la distancia signifique
/// algo. Más cerca = se leen juntos. Más lejos = son momentos distintos de la
/// tarea.
///
/// Misma escala que los wireframes (`wireframes/README.md`), para que Figma y
/// código representen la misma pantalla.
abstract final class AppSpacing {
  /// Medio paso. Solo para lo que se lee como una sola unidad: una etiqueta
  /// sobre su valor, dos líneas de un mismo dato.
  static const double half = 4;

  /// Dentro de un grupo: ícono y su texto, etiqueta y campo, dato y unidad.
  static const double s1 = 8;

  /// Contenido relacionado. También el margen lateral de toda la app.
  static const double s2 = 16;

  /// Entre grupos distintos de la misma pantalla.
  static const double s3 = 24;

  /// Entre secciones, o entre momentos distintos de la tarea.
  static const double s4 = 32;

  /// Radios. También sobre la escala, para que el redondeo no sea otro
  /// número suelto por componente.
  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusPill = 999;
}
