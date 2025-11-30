import 'dart:ffi';

base class LlamaContext extends Opaque {}
base class LlamaModel extends Opaque {}

base class LlamaContextParams extends Struct {
  @Uint32()
  external int seed;
  
  @Uint32()
  external int n_ctx;
  
  @Uint32()
  external int n_batch;
  
  @Uint32()
  external int n_threads;
  
  @Float()
  external double temperature;
  
  @Float()
  external double top_p;
}

base class LlamaToken extends Struct {
  @Int32()
  external int id;
}

typedef LlamaTokenData = Pointer<LlamaToken>;