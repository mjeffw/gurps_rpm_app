/// A bi-directional converter (A -> B and B -> A).
abstract class Converter<A, B> {
  B toB(A input);
  A toA(B input);
}

abstract class StringToIntConverter implements Converter<String, int> {
  const StringToIntConverter();

  int toB(String input);
  String toA(int input);

  int asInt(String input) => toB(input);
  String asString(int input) => toA(input);
}

class IdentityStringToIntConverter extends StringToIntConverter {
  const IdentityStringToIntConverter();

  int toB(String input) => int.parse(input);
  String toA(int input) => input.toString();
}
