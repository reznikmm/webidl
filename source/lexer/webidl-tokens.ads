--  SPDX-FileCopyrightText: 2010-2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package WebIDL.Tokens is
   pragma Preelaborate;

   type Token_Kind is
     ('(', ')',
      ',', '-', '.', ':', ';',
      '<', '=', '>',
      '?',
      '[', ']',
      '{', '}',

      Ellipsis_Token,

      Any_Token,
      Async_Token,
      Attribute_Token,
      Bigint_Token,
      Boolean_Token,
      Byte_Token,
      Callback_Token,
      Const_Token,
      Constructor_Token,
      Deleter_Token,
      Dictionary_Token,
      Double_Token,
      Enum_Token,
      False_Token,
      Float_Token,
      Getter_Token,
      Includes_Token,
      Inherit_Token,
      Interface_Token,
      Iterable_Token,
      Long_Token,
      Maplike_Token,
      Mixin_Token,
      Namespace_Token,
      Null_Token,
      Object_Token,
      Octet_Token,
      Optional_Token,
      Or_Token,
      Other_Token,
      Partial_Token,
      Readonly_Token,
      Record_Token,
      Required_Token,
      Sequence_Token,
      Setlike_Token,
      Setter_Token,
      Short_Token,
      Static_Token,
      Stringifier_Token,
      Symbol_Token,
      True_Token,
      Typedef_Token,
      Undefined_Token,
      Unrestricted_Token,
      Unsigned_Token,

      ArrayBuffer_Token,
      ByteString_Token,
      DataView_Token,
      DOMString_Token,
      Float32Array_Token,
      Float64Array_Token,
      FrozenArray_Token,
      Infinity_Token,
      Int16Array_Token,
      Int32Array_Token,
      Int8Array_Token,
      NaN_Token,
      ObservableArray_Token,
      Promise_Token,
      Uint16Array_Token,
      Uint32Array_Token,
      Uint8Array_Token,
      Uint8ClampedArray_Token,
      USVString_Token,


      Integer_Token,
      Decimal_Token,
      Identifier_Token,
      String_Token,
      End_Of_Stream_Token,
      Error_Token);

   type Token (Kind : Token_Kind := End_Of_Stream_Token) is null record;

end WebIDL.Tokens;
