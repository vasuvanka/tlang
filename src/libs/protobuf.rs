// protobuf - Protocol Buffers encoding/decoding library
// Provides fast binary serialization as an alternative to JSON
// Based on Google's Protocol Buffers wire format

pub fn generate_protobuf_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <stdint.h>\n");
    code.push_str("#include <stdbool.h>\n\n");
    
    // Protobuf wire types
    code.push_str("// Protobuf wire types\n");
    code.push_str("#define PROTOBUF_WIRE_VARINT 0\n");
    code.push_str("#define PROTOBUF_WIRE_FIXED64 1\n");
    code.push_str("#define PROTOBUF_WIRE_LENGTH_DELIMITED 2\n");
    code.push_str("#define PROTOBUF_WIRE_START_GROUP 3\n");
    code.push_str("#define PROTOBUF_WIRE_END_GROUP 4\n");
    code.push_str("#define PROTOBUF_WIRE_FIXED32 5\n\n");
    
    // Buffer structure for encoding/decoding
    code.push_str("// Protobuf buffer for encoding/decoding\n");
    code.push_str("typedef struct ProtobufBuffer {\n");
    code.push_str("    uint8_t* data;\n");
    code.push_str("    size_t size;\n");
    code.push_str("    size_t capacity;\n");
    code.push_str("    size_t pos;  // For reading\n");
    code.push_str("} ProtobufBuffer;\n\n");
    
    // Initialize buffer
    code.push_str("// Initialize protobuf buffer\n");
    code.push_str("ProtobufBuffer* protobuf_buffer_new(size_t initial_capacity) {\n");
    code.push_str("    ProtobufBuffer* buf = (ProtobufBuffer*)malloc(sizeof(ProtobufBuffer));\n");
    code.push_str("    if (!buf) return NULL;\n");
    code.push_str("    buf->capacity = initial_capacity > 0 ? initial_capacity : 256;\n");
    code.push_str("    buf->data = (uint8_t*)malloc(buf->capacity);\n");
    code.push_str("    if (!buf->data) { free(buf); return NULL; }\n");
    code.push_str("    buf->size = 0;\n");
    code.push_str("    buf->pos = 0;\n");
    code.push_str("    return buf;\n");
    code.push_str("}\n\n");
    
    // Free buffer
    code.push_str("// Free protobuf buffer\n");
    code.push_str("void protobuf_buffer_free(ProtobufBuffer* buf) {\n");
    code.push_str("    if (!buf) return;\n");
    code.push_str("    if (buf->data) free(buf->data);\n");
    code.push_str("    free(buf);\n");
    code.push_str("}\n\n");
    
    // Ensure capacity
    code.push_str("// Ensure buffer has enough capacity\n");
    code.push_str("int protobuf_buffer_ensure(ProtobufBuffer* buf, size_t needed) {\n");
    code.push_str("    if (!buf) return 0;\n");
    code.push_str("    if (buf->size + needed <= buf->capacity) return 1;\n");
    code.push_str("    size_t new_capacity = buf->capacity * 2;\n");
    code.push_str("    while (new_capacity < buf->size + needed) new_capacity *= 2;\n");
    code.push_str("    uint8_t* new_data = (uint8_t*)realloc(buf->data, new_capacity);\n");
    code.push_str("    if (!new_data) return 0;\n");
    code.push_str("    buf->data = new_data;\n");
    code.push_str("    buf->capacity = new_capacity;\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode varint (variable-length integer)
    code.push_str("// Encode varint (variable-length integer)\n");
    code.push_str("int protobuf_encode_varint(ProtobufBuffer* buf, uint64_t value) {\n");
    code.push_str("    if (!buf) return 0;\n");
    code.push_str("    while (value >= 0x80) {\n");
    code.push_str("        if (!protobuf_buffer_ensure(buf, 1)) return 0;\n");
    code.push_str("        buf->data[buf->size++] = (uint8_t)((value & 0x7F) | 0x80);\n");
    code.push_str("        value >>= 7;\n");
    code.push_str("    }\n");
    code.push_str("    if (!protobuf_buffer_ensure(buf, 1)) return 0;\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)(value & 0x7F);\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Decode varint
    code.push_str("// Decode varint\n");
    code.push_str("int protobuf_decode_varint(ProtobufBuffer* buf, uint64_t* value) {\n");
    code.push_str("    if (!buf || !value || buf->pos >= buf->size) return 0;\n");
    code.push_str("    uint64_t result = 0;\n");
    code.push_str("    int shift = 0;\n");
    code.push_str("    while (buf->pos < buf->size) {\n");
    code.push_str("        uint8_t byte = buf->data[buf->pos++];\n");
    code.push_str("        result |= ((uint64_t)(byte & 0x7F) << shift);\n");
    code.push_str("        if ((byte & 0x80) == 0) {\n");
    code.push_str("            *value = result;\n");
    code.push_str("            return 1;\n");
    code.push_str("        }\n");
    code.push_str("        shift += 7;\n");
    code.push_str("        if (shift >= 64) return 0;  // Invalid varint\n");
    code.push_str("    }\n");
    code.push_str("    return 0;  // Incomplete varint\n");
    code.push_str("}\n\n");
    
    // Encode field tag (field number + wire type)
    code.push_str("// Encode field tag (field_number << 3 | wire_type)\n");
    code.push_str("int protobuf_encode_tag(ProtobufBuffer* buf, int field_number, int wire_type) {\n");
    code.push_str("    if (!buf || field_number < 1 || field_number > 536870911) return 0;\n");
    code.push_str("    uint32_t tag = ((uint32_t)field_number << 3) | (wire_type & 0x7);\n");
    code.push_str("    return protobuf_encode_varint(buf, tag);\n");
    code.push_str("}\n\n");
    
    // Decode field tag
    code.push_str("// Decode field tag\n");
    code.push_str("int protobuf_decode_tag(ProtobufBuffer* buf, int* field_number, int* wire_type) {\n");
    code.push_str("    if (!buf || !field_number || !wire_type) return 0;\n");
    code.push_str("    uint64_t tag;\n");
    code.push_str("    if (!protobuf_decode_varint(buf, &tag)) return 0;\n");
    code.push_str("    *field_number = (int)(tag >> 3);\n");
    code.push_str("    *wire_type = (int)(tag & 0x7);\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode int32
    code.push_str("// Encode int32 (signed varint)\n");
    code.push_str("int protobuf_encode_int32(ProtobufBuffer* buf, int32_t value) {\n");
    code.push_str("    // Zigzag encoding for signed integers\n");
    code.push_str("    uint32_t zigzag = (uint32_t)((value << 1) ^ (value >> 31));\n");
    code.push_str("    return protobuf_encode_varint(buf, zigzag);\n");
    code.push_str("}\n\n");
    
    // Decode int32
    code.push_str("// Decode int32\n");
    code.push_str("int protobuf_decode_int32(ProtobufBuffer* buf, int32_t* value) {\n");
    code.push_str("    if (!buf || !value) return 0;\n");
    code.push_str("    uint64_t zigzag;\n");
    code.push_str("    if (!protobuf_decode_varint(buf, &zigzag)) return 0;\n");
    code.push_str("    // Zigzag decoding\n");
    code.push_str("    *value = (int32_t)((zigzag >> 1) ^ -(int32_t)(zigzag & 1));\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode int64
    code.push_str("// Encode int64 (signed varint)\n");
    code.push_str("int protobuf_encode_int64(ProtobufBuffer* buf, int64_t value) {\n");
    code.push_str("    uint64_t zigzag = (uint64_t)((value << 1) ^ (value >> 63));\n");
    code.push_str("    return protobuf_encode_varint(buf, zigzag);\n");
    code.push_str("}\n\n");
    
    // Decode int64
    code.push_str("// Decode int64\n");
    code.push_str("int protobuf_decode_int64(ProtobufBuffer* buf, int64_t* value) {\n");
    code.push_str("    if (!buf || !value) return 0;\n");
    code.push_str("    uint64_t zigzag;\n");
    code.push_str("    if (!protobuf_decode_varint(buf, &zigzag)) return 0;\n");
    code.push_str("    *value = (int64_t)((zigzag >> 1) ^ -(int64_t)(zigzag & 1));\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode uint32
    code.push_str("// Encode uint32 (unsigned varint)\n");
    code.push_str("int protobuf_encode_uint32(ProtobufBuffer* buf, uint32_t value) {\n");
    code.push_str("    return protobuf_encode_varint(buf, value);\n");
    code.push_str("}\n\n");
    
    // Decode uint32
    code.push_str("// Decode uint32\n");
    code.push_str("int protobuf_decode_uint32(ProtobufBuffer* buf, uint32_t* value) {\n");
    code.push_str("    if (!buf || !value) return 0;\n");
    code.push_str("    uint64_t v;\n");
    code.push_str("    if (!protobuf_decode_varint(buf, &v)) return 0;\n");
    code.push_str("    *value = (uint32_t)v;\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode bool
    code.push_str("// Encode bool (as varint: 0 or 1)\n");
    code.push_str("int protobuf_encode_bool(ProtobufBuffer* buf, int value) {\n");
    code.push_str("    return protobuf_encode_varint(buf, value ? 1 : 0);\n");
    code.push_str("}\n\n");
    
    // Decode bool
    code.push_str("// Decode bool\n");
    code.push_str("int protobuf_decode_bool(ProtobufBuffer* buf, int* value) {\n");
    code.push_str("    if (!buf || !value) return 0;\n");
    code.push_str("    uint64_t v;\n");
    code.push_str("    if (!protobuf_decode_varint(buf, &v)) return 0;\n");
    code.push_str("    *value = (v != 0) ? 1 : 0;\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode float (fixed32)
    code.push_str("// Encode float (fixed32, little-endian)\n");
    code.push_str("int protobuf_encode_float(ProtobufBuffer* buf, float value) {\n");
    code.push_str("    if (!buf || !protobuf_buffer_ensure(buf, 4)) return 0;\n");
    code.push_str("    union { float f; uint32_t i; } u;\n");
    code.push_str("    u.f = value;\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)(u.i & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 8) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 16) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 24) & 0xFF);\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Decode float
    code.push_str("// Decode float\n");
    code.push_str("int protobuf_decode_float(ProtobufBuffer* buf, float* value) {\n");
    code.push_str("    if (!buf || !value || buf->pos + 4 > buf->size) return 0;\n");
    code.push_str("    union { float f; uint32_t i; } u;\n");
    code.push_str("    u.i = (uint32_t)buf->data[buf->pos++];\n");
    code.push_str("    u.i |= (uint32_t)buf->data[buf->pos++] << 8;\n");
    code.push_str("    u.i |= (uint32_t)buf->data[buf->pos++] << 16;\n");
    code.push_str("    u.i |= (uint32_t)buf->data[buf->pos++] << 24;\n");
    code.push_str("    *value = u.f;\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode double (fixed64)
    code.push_str("// Encode double (fixed64, little-endian)\n");
    code.push_str("int protobuf_encode_double(ProtobufBuffer* buf, double value) {\n");
    code.push_str("    if (!buf || !protobuf_buffer_ensure(buf, 8)) return 0;\n");
    code.push_str("    union { double d; uint64_t i; } u;\n");
    code.push_str("    u.d = value;\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)(u.i & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 8) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 16) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 24) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 32) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 40) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 48) & 0xFF);\n");
    code.push_str("    buf->data[buf->size++] = (uint8_t)((u.i >> 56) & 0xFF);\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Decode double
    code.push_str("// Decode double\n");
    code.push_str("int protobuf_decode_double(ProtobufBuffer* buf, double* value) {\n");
    code.push_str("    if (!buf || !value || buf->pos + 8 > buf->size) return 0;\n");
    code.push_str("    union { double d; uint64_t i; } u;\n");
    code.push_str("    u.i = (uint64_t)buf->data[buf->pos++];\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 8;\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 16;\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 24;\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 32;\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 40;\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 48;\n");
    code.push_str("    u.i |= (uint64_t)buf->data[buf->pos++] << 56;\n");
    code.push_str("    *value = u.d;\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Encode string (length-delimited)
    code.push_str("// Encode string (length-delimited)\n");
    code.push_str("int protobuf_encode_string(ProtobufBuffer* buf, const char* str) {\n");
    code.push_str("    if (!buf || !str) return 0;\n");
    code.push_str("    size_t len = strlen(str);\n");
    code.push_str("    if (!protobuf_encode_varint(buf, len)) return 0;\n");
    code.push_str("    if (!protobuf_buffer_ensure(buf, len)) return 0;\n");
    code.push_str("    memcpy(buf->data + buf->size, str, len);\n");
    code.push_str("    buf->size += len;\n");
    code.push_str("    return 1;\n");
    code.push_str("}\n\n");
    
    // Decode string
    code.push_str("// Decode string\n");
    code.push_str("char* protobuf_decode_string(ProtobufBuffer* buf) {\n");
    code.push_str("    if (!buf) return NULL;\n");
    code.push_str("    uint64_t len;\n");
    code.push_str("    if (!protobuf_decode_varint(buf, &len)) return NULL;\n");
    code.push_str("    if (buf->pos + len > buf->size) return NULL;\n");
    code.push_str("    char* str = (char*)malloc(len + 1);\n");
    code.push_str("    if (!str) return NULL;\n");
    code.push_str("    memcpy(str, buf->data + buf->pos, len);\n");
    code.push_str("    str[len] = '\\0';\n");
    code.push_str("    buf->pos += len;\n");
    code.push_str("    return str;\n");
    code.push_str("}\n\n");
    
    // Public API: Marshal (encode struct to binary)
    code.push_str("// protobuf.Marshal - Encode struct to binary protobuf format\n");
    code.push_str("// Returns: binary data as char* (caller must free), NULL on error\n");
    code.push_str("// Note: For structs, use compiler-generated protobuf_marshal_<structname>() functions\n");
    code.push_str("char* protobuf_Marshal(ProtobufBuffer* buf) {\n");
    code.push_str("    if (!buf || buf->size == 0) return NULL;\n");
    code.push_str("    char* result = (char*)malloc(buf->size);\n");
    code.push_str("    if (!result) return NULL;\n");
    code.push_str("    memcpy(result, buf->data, buf->size);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // Public API: Unmarshal (decode binary to struct)
    code.push_str("// protobuf.Unmarshal - Initialize buffer from binary data\n");
    code.push_str("// Returns: ProtobufBuffer* (caller must free with protobuf_buffer_free), NULL on error\n");
    code.push_str("ProtobufBuffer* protobuf_Unmarshal(const char* data, size_t len) {\n");
    code.push_str("    if (!data || len == 0) return NULL;\n");
    code.push_str("    ProtobufBuffer* buf = protobuf_buffer_new(len);\n");
    code.push_str("    if (!buf) return NULL;\n");
    code.push_str("    memcpy(buf->data, data, len);\n");
    code.push_str("    buf->size = len;\n");
    code.push_str("    buf->pos = 0;\n");
    code.push_str("    return buf;\n");
    code.push_str("}\n\n");
    
    // Helper: Get buffer size
    code.push_str("// Get encoded buffer size\n");
    code.push_str("size_t protobuf_Size(ProtobufBuffer* buf) {\n");
    code.push_str("    return buf ? buf->size : 0;\n");
    code.push_str("}\n\n");
    
    // Helper: Reset buffer position for reading
    code.push_str("// Reset buffer position for reading\n");
    code.push_str("void protobuf_Reset(ProtobufBuffer* buf) {\n");
    code.push_str("    if (buf) buf->pos = 0;\n");
    code.push_str("}\n\n");
    
    code
}
