abstract class UseCase<Payload, Output> {
  Future<Output> execute(Payload payload);
}

class Nothing {}