// Tlang Standard Library Modules
// Ported from Go's standard library

pub mod fmt;
pub mod strings;
pub mod math;
pub mod strconv;
pub mod os;
pub mod time;
pub mod bytes;
pub mod sort;
pub mod json;
pub mod http;
pub mod io;
pub mod filepath;
pub mod testing;
pub mod args;
pub mod regexp;
pub mod rand;
pub mod log;
pub mod flag;
pub mod crypto;
pub mod hex;
pub mod url;
pub mod unicode;
pub mod csv;
pub mod xml;
pub mod neturl;
pub mod bufio;
pub mod benchmark;
pub mod net;
pub mod doc;
pub mod reflect;
pub mod base64;
pub mod errors;
pub mod protobuf;
pub mod sandarbham;

pub fn generate_all_libs() -> String {
    let mut all_code = String::new();
    
    // Add required headers
    all_code.push_str("#include <stdarg.h>\n");
    all_code.push_str("#include <stdio.h>\n");
    all_code.push_str("#include <stdlib.h>\n");
    all_code.push_str("#include <string.h>\n");
    all_code.push_str("#include <ctype.h>\n");
    all_code.push_str("#include <math.h>\n");
    all_code.push_str("\n");
    
    // Generate all libraries
    all_code.push_str("// ========== fmt library ==========\n");
    all_code.push_str(&fmt::generate_fmt_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== strings library ==========\n");
    all_code.push_str(&strings::generate_strings_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== math library ==========\n");
    all_code.push_str(&math::generate_math_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== strconv library ==========\n");
    all_code.push_str(&strconv::generate_strconv_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== os library ==========\n");
    all_code.push_str(&os::generate_os_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== time library ==========\n");
    all_code.push_str(&time::generate_time_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== bytes library ==========\n");
    all_code.push_str(&bytes::generate_bytes_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== sort library ==========\n");
    all_code.push_str(&sort::generate_sort_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== json library ==========\n");
    all_code.push_str(&json::generate_json_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== http library ==========\n");
    all_code.push_str(&http::generate_http_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== io library ==========\n");
    all_code.push_str(&io::generate_io_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== filepath library ==========\n");
    all_code.push_str(&filepath::generate_filepath_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== testing library ==========\n");
    all_code.push_str(&testing::generate_testing_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== args library ==========\n");
    all_code.push_str(&args::generate_args_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== regexp library ==========\n");
    all_code.push_str(&regexp::generate_regexp_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== rand library ==========\n");
    all_code.push_str(&rand::generate_rand_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== log library ==========\n");
    all_code.push_str(&log::generate_log_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== flag library ==========\n");
    all_code.push_str(&flag::generate_flag_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== crypto/hash library ==========\n");
    all_code.push_str(&crypto::generate_crypto_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== encoding/hex library ==========\n");
    all_code.push_str(&hex::generate_hex_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== url library ==========\n");
    all_code.push_str(&url::generate_url_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== unicode library ==========\n");
    all_code.push_str(&unicode::generate_unicode_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== encoding/csv library ==========\n");
    all_code.push_str(&csv::generate_csv_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== encoding/xml library ==========\n");
    all_code.push_str(&xml::generate_xml_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== net/url library ==========\n");
    all_code.push_str(&neturl::generate_neturl_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== bufio library ==========\n");
    all_code.push_str(&bufio::generate_bufio_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== testing/benchmark library ==========\n");
    all_code.push_str(&benchmark::generate_benchmark_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== doc library ==========\n");
    all_code.push_str(&doc::generate_doc_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== reflect library ==========\n");
    all_code.push_str(&reflect::generate_reflect_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== encoding/base64 library ==========\n");
    all_code.push_str(&base64::generate_base64_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== errors library ==========\n");
    all_code.push_str(&errors::generate_errors_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== net library ==========\n");
    all_code.push_str(&net::generate_net_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== protobuf library ==========\n");
    all_code.push_str(&protobuf::generate_protobuf_lib());
    all_code.push_str("\n");
    
    all_code.push_str("// ========== sandarbham (context) library ==========\n");
    all_code.push_str(&sandarbham::generate_sandarbham_lib());
    all_code.push_str("\n");
    
    all_code
}
