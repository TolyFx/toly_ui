// import 'dart:ffi';

import 'dart:ffi';

typedef HandleAllocateNewPageResult = Void Function(Pointer<Handle> object, Pointer<Void> page);

typedef HandleAllocateNewPageResult1 = Int32 Function(Int32 pageSize);

int handleAllocateNewPageResult1(int pageSize) {
  return 0; // Success
}

void handleAllocateNewPageResult(Pointer<Handle> object, Pointer<Void> page) {}

Pointer<NativeFunction<HandleAllocateNewPageResult1>> funcPointer =
    Pointer.fromFunction<HandleAllocateNewPageResult1>(handleAllocateNewPageResult1, 0);

Pointer<NativeFunction<HandleAllocateNewPageResult>> f =
    Pointer.fromFunction<HandleAllocateNewPageResult>(
  handleAllocateNewPageResult,
);
