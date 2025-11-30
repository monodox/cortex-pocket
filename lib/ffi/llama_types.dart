import 'dart:ffi';

base class LlamaContext extends Opaque {}
base class LlamaModel extends Opaque {}

base class LlamaContextParams extends Struct {
  @Uint32()
  external int seed;
  
  @Uint32()
  external int nCtx;
  
  @Uint32()
  external int nBatch;
  
  @Uint32()
  external int nThreads;
  
  @Float()
  external double temperature;
  
  @Float()
  external double topP;
}

base class LlamaToken extends Struct {
  @Int32()
  external int id;
}

typedef LlamaTokenData = Pointer<LlamaToken>;